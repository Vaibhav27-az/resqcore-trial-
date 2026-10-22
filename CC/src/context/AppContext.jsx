import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import {
  initialIncidents,
  initialTeams,
  initialChannels,
  initialDirectMessages,
  initialMessages,
  initialAlerts,
  initialCameras
} from '../data/initialData';
import { api, connectRealtime } from '../services/api';

const AppContext = createContext();

export const AppProvider = ({ children }) => {
  // Navigation & Auth
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isDemoMode, setIsDemoMode] = useState(false);
  const [activeTab, setActiveTab] = useState('command-center');
  const [isBackendConnected, setIsBackendConnected] = useState(false);
  const [user, setUser] = useState({
    name: 'Ananya Kumar',
    role: 'Command Operator',
    email: 'ananya.kumar@resqcore.gov.in',
    district: 'Dehradun, Uttarakhand'
  });

  // Operational Data
  const [incidents, setIncidents] = useState(initialIncidents);
  const [teams, setTeams] = useState(initialTeams);
  const [cameras, setCameras] = useState(initialCameras);
  const [alerts, setAlerts] = useState(initialAlerts);
  
  // Selection & UI State
  const [selectedIncidentId, setSelectedIncidentId] = useState('INC-2048');
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [isLoadingSync, setIsLoadingSync] = useState(false);
  
  // Chat & Communication
  const [activeChannel, setActiveChannel] = useState('ernakulam-command');
  const [messages, setMessages] = useState(initialMessages);

  // Active Toasts
  const [toasts, setToasts] = useState([
    {
      id: 'toast-initial-high',
      type: 'high-incident',
      title: 'New High incident',
      code: 'INC-2048 · Flooding in Fort Kochi',
      detail: '320 people affected · Verification required',
      incidentId: 'INC-2048'
    }
  ]);

  // Modals
  const [assignModalTeam, setAssignModalTeam] = useState(null);

  // Get active selected incident object
  const selectedIncident = incidents.find(i => i.id === selectedIncidentId) || incidents[0] || {};

  // Helper to trigger a toast
  const addToast = useCallback((toast) => {
    const id = Date.now().toString() + Math.random().toString().slice(2, 5);
    const newToast = { id, ...toast };
    setToasts(prev => [newToast, ...prev]);
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 8000);
  }, []);

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  // Sync initial data from Unified Backend
  const syncWithBackend = useCallback(async () => {
    try {
      setIsLoadingSync(true);
      const [backendIncidents, backendTeams, backendAlerts] = await Promise.all([
        api.getIncidents().catch(() => null),
        api.getTeams().catch(() => null),
        api.getAlerts().catch(() => null)
      ]);

      if (backendIncidents && backendIncidents.length > 0) {
        setIncidents(backendIncidents);
      }
      if (backendTeams && backendTeams.length > 0) {
        setTeams(backendTeams);
      }
      if (backendAlerts && backendAlerts.length > 0) {
        setAlerts(backendAlerts);
      }
    } catch (e) {
      console.warn('[Sync] Using local initial data fallback:', e.message);
    } finally {
      setIsLoadingSync(false);
    }
  }, []);

  // Connect to Backend & WebSocket on mount
  useEffect(() => {
    syncWithBackend();

    const disconnect = connectRealtime({
      onStatusChange: (connected) => {
        setIsBackendConnected(connected);
      },
      onMessage: (payload) => {
        console.log('[App Realtime Event]', payload.type);

        if (payload.type === 'INCIDENT_CREATED') {
          const newIncident = payload.data;
          setIncidents(prev => [newIncident, ...prev.filter(i => i.id !== newIncident.id)]);
          addToast({
            type: 'high-incident',
            title: `Emergency Signal: ${newIncident.title}`,
            code: `${newIncident.id} · ${newIncident.shortLocation || newIncident.location}`,
            detail: `${newIncident.affected || 4} people affected · Citizen SOS Alert`,
            incidentId: newIncident.id
          });
        } else if (payload.type === 'INCIDENT_VERIFIED' || payload.type === 'INCIDENT_STATUS_UPDATED') {
          const updated = payload.data;
          setIncidents(prev => prev.map(i => i.id === updated.id ? { ...i, ...updated } : i));
        } else if (payload.type === 'INCIDENT_ASSIGNED') {
          const { data: updatedIncident, team } = payload;
          setIncidents(prev => prev.map(i => i.id === updatedIncident.id ? { ...i, ...updatedIncident } : i));
          if (team) {
            setTeams(prev => prev.map(t => t.id === team.id ? { ...t, ...team } : t));
          }
        } else if (payload.type === 'TEAM_UPDATED') {
          const updatedTeam = payload.data;
          setTeams(prev => prev.map(t => t.id === updatedTeam.id ? { ...t, ...updatedTeam } : t));
        } else if (payload.type === 'ALERT_BROADCAST') {
          const alert = payload.data;
          setAlerts(prev => [alert, ...prev.filter(a => a.id !== alert.id)]);
          addToast({
            type: 'broadcast-sent',
            title: alert.title,
            code: alert.code || 'ALERT',
            detail: alert.subtitle || alert.message
          });
        } else if (payload.type === 'MESSAGE_SENT') {
          const { channel, data: newMsg } = payload;
          setMessages(prev => ({
            ...prev,
            [channel]: [...(prev[channel] || []).filter(m => m.id !== newMsg.id), newMsg]
          }));
        }
      }
    });

    return () => disconnect();
  }, [syncWithBackend, addToast]);

  // Flow: Verify Incident
  const verifyIncident = async (id) => {
    const incident = incidents.find(item => item.id === id);
    if (!incident || incident.status !== 'Unverified') return;
    const availableTeam = teams.find(team => team.status === 'Available');
    if (!availableTeam) {
      addToast({
        type: 'high-incident',
        title: 'No rescue team available',
        code: id,
        detail: 'The SOS remains unverified. Make a team available, then try again.',
        incidentId: id
      });
      return;
    }

    try {
      const verifiedIncident = await api.verifyIncident(id, {
        assignedTeam: availableTeam.name,
        eta: 'ETA 12 min'
      });

      setIncidents(prev =>
        prev.map(item => item.id === id ? { ...item, ...verifiedIncident } : item)
      );
      setTeams(prev =>
        prev.map(team => team.id === availableTeam.id
          ? {
              ...team,
              status: 'Deployed',
              task: `${id} · ${incident.title}`,
              eta: 'ETA 12 min'
            }
          : team
        )
      );
      setToasts(prev => prev.filter(toast => toast.incidentId !== id));
      addToast({
        type: 'team-assigned',
        title: 'Team assigned',
        code: `${id} · ${availableTeam.name} · ETA 12 min`,
        detail: `Verified · En route to ${incident.shortLocation || incident.location}`,
        incidentId: id
      });
    } catch (e) {
      addToast({
        type: 'high-incident',
        title: 'Verification failed',
        code: id,
        detail: e.message || 'The incident remains in the review queue.',
        incidentId: id
      });
    }
  };

  // Flow: Assign specific team to an incident
  const assignTeamToIncident = async (teamId, incidentId) => {
    const team = teams.find(t => t.id === teamId);
    const incident = incidents.find(i => i.id === incidentId);

    if (!team || !incident) return;

    setTeams(prev =>
      prev.map(t => {
        if (t.id === teamId) {
          return {
            ...t,
            status: 'Deployed',
            task: `${incident.id} · ${incident.title}`,
            eta: 'ETA 15 min'
          };
        }
        return t;
      })
    );

    setIncidents(prev =>
      prev.map(i => {
        if (i.id === incidentId) {
          return {
            ...i,
            status: i.status === 'Unverified' ? 'Verified' : i.status,
            responseSummary: team.name,
            responseDetail: 'ETA 15 min',
            assignedTeam: team.name
          };
        }
        return i;
      })
    );

    addToast({
      type: 'team-assigned',
      title: 'Team assigned',
      code: `${incident.id} · ${team.name} · ETA 15 min`,
      detail: `Assigned · Dispatched to ${incident.shortLocation || incident.location}`,
      incidentId: incident.id
    });

    setAssignModalTeam(null);

    // Call unified backend API
    try {
      await api.assignTeam(incidentId, {
        teamId: team.id,
        teamName: team.name,
        eta: 'ETA 15 min'
      });
    } catch (e) {
      console.warn('[API] Backend assign team fallback:', e.message);
    }
  };

  // Flow: Send Chat Message
  const sendMessage = async (channelId, text) => {
    if (!text.trim()) return;
    const newMessage = {
      id: 'm-' + Date.now(),
      sender: `${user.name} · You`,
      initials: 'AK',
      isSelf: true,
      time: new Intl.DateTimeFormat('en-US', { hour: '2-digit', minute: '2-digit', hour12: false }).format(new Date()),
      text: text.trim()
    };

    setMessages(prev => ({
      ...prev,
      [channelId]: [...(prev[channelId] || []), newMessage]
    }));

    // Call unified backend API
    try {
      await api.sendMessage(channelId, {
        sender: user.name,
        initials: 'AK',
        isSelf: true,
        text: text.trim(),
        role: user.role
      });
    } catch (e) {
      console.warn('[API] Backend sendMessage fallback:', e.message);
    }
  };

  // Flow: Send Broadcast
  const sendBroadcast = async ({ recipients, message, severity = 'Info' }) => {
    const newAlert = {
      id: 'a-' + Date.now(),
      title: 'Command broadcast issued',
      code: 'ALL-UNITS',
      subtitle: message.slice(0, 45) + '...',
      timeAgo: 'Just now',
      severity,
      message,
      recipients
    };

    addToast({
      type: 'broadcast-sent',
      title: 'Broadcast Dispatched',
      code: `To: ${recipients}`,
      detail: message.slice(0, 70) + (message.length > 70 ? '...' : '')
    });

    setAlerts(prev => [newAlert, ...prev]);

    // Call unified backend API
    try {
      await api.sendBroadcast({
        title: 'Command broadcast issued',
        subtitle: message.slice(0, 45) + '...',
        message,
        recipients,
        severity
      });
    } catch (e) {
      console.warn('[API] Backend sendBroadcast fallback:', e.message);
    }
  };

  // Open incident in drawer & navigate
  const inspectIncident = (id, targetTab = null) => {
    setSelectedIncidentId(id);
    setIsDrawerOpen(true);
    if (targetTab) {
      setActiveTab(targetTab);
    }
  };

  return (
    <AppContext.Provider
      value={{
        isAuthenticated,
        setIsAuthenticated,
        activeTab,
        setActiveTab,
        user,
        setUser,
        incidents,
        setIncidents,
        teams,
        setTeams,
        cameras,
        setCameras,
        alerts,
        setAlerts,
        selectedIncidentId,
        setSelectedIncidentId,
        selectedIncident,
        isDrawerOpen,
        setIsDrawerOpen,
        inspectIncident,
        verifyIncident,
        assignTeamToIncident,
        assignModalTeam,
        setAssignModalTeam,
        activeChannel,
        setActiveChannel,
        messages,
        setMessages,
        sendMessage,
        sendBroadcast,
        toasts,
        setToasts,
        removeToast,
        addToast,
        isLoadingSync,
        setIsLoadingSync,
        isDemoMode,
        setIsDemoMode,
        isBackendConnected,
        syncWithBackend
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => useContext(AppContext);
