// API client and real-time WebSocket connection to the Unified ResQCore Backend Hub

const configuredBaseUrl = import.meta.env.VITE_BACKEND_URL?.trim();
const localHosts = new Set(['localhost', '127.0.0.1', '::1', '[::1]']);
const pageHost = window.location.hostname;
const configuredUrl = configuredBaseUrl
  ? new URL(configuredBaseUrl, window.location.origin)
  : null;

if (configuredUrl && localHosts.has(configuredUrl.hostname) && !localHosts.has(pageHost)) {
  configuredUrl.hostname = pageHost;
}

const BASE_URL = (configuredUrl || new URL(`${window.location.protocol}//${pageHost}:5000`))
  .toString()
  .replace(/\/$/, '');
const WS_URL = BASE_URL.replace(/^http/, 'ws') + '/ws';

export const api = {
  // Health
  async getHealth() {
    const res = await fetch(`${BASE_URL}/api/health`);
    return res.json();
  },

  // Isolated seeded operating-system simulator
  async getOsMonitor() {
    const res = await fetch(`${BASE_URL}/api/os-monitor`);
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not load OS monitor');
    return json.data;
  },

  async runOsScenario(scenario) {
    const res = await fetch(`${BASE_URL}/api/os-monitor/scenarios/${encodeURIComponent(scenario)}`, {
      method: 'POST'
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not run OS monitor demo');
    return json.data;
  },

  async resetOsMonitor() {
    const res = await fetch(`${BASE_URL}/api/os-monitor/reset`, { method: 'POST' });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not reset OS monitor');
    return json.data;
  },

  async dispatchOsProcess(pid, teamId) {
    const res = await fetch(`${BASE_URL}/api/os-monitor/dispatch/${encodeURIComponent(pid)}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ teamId })
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not dispatch demo process');
    return json.data;
  },

  async completeOsProcess(pid) {
    const res = await fetch(`${BASE_URL}/api/os-monitor/complete/${encodeURIComponent(pid)}`, {
      method: 'POST'
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not complete demo process');
    return json.data;
  },

  // Stats
  async getStats() {
    const res = await fetch(`${BASE_URL}/api/stats`);
    return res.json();
  },

  // Incidents
  async getIncidents() {
    const res = await fetch(`${BASE_URL}/api/incidents`);
    const json = await res.json();
    return json.data || [];
  },

  async getIncident(id) {
    const res = await fetch(`${BASE_URL}/api/incidents/${id}`);
    const json = await res.json();
    return json.data;
  },

  async createIncident(incidentData) {
    const res = await fetch(`${BASE_URL}/api/incidents`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(incidentData)
    });
    const json = await res.json();
    return json.data;
  },

  async verifyIncident(id, { assignedTeam = 'Bravo 02', eta = 'ETA 12 min' } = {}) {
    const res = await fetch(`${BASE_URL}/api/incidents/${id}/verify`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ assignedTeam, eta })
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not verify incident');
    return json.data;
  },

  async assignTeam(incidentId, { teamId, teamName, eta }) {
    const res = await fetch(`${BASE_URL}/api/incidents/${incidentId}/assign`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ teamId, teamName, eta })
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message || 'Could not assign team');
    return json.data;
  },

  async updateIncidentStatus(id, { status, substatus, dispatchUpdate }) {
    const res = await fetch(`${BASE_URL}/api/incidents/${id}/status`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status, substatus, dispatchUpdate })
    });
    const json = await res.json();
    return json.data;
  },

  // Teams
  async getTeams() {
    const res = await fetch(`${BASE_URL}/api/teams`);
    const json = await res.json();
    return json.data || [];
  },

  async updateTeam(id, patch) {
    const res = await fetch(`${BASE_URL}/api/teams/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(patch)
    });
    const json = await res.json();
    return json.data;
  },

  // Alerts
  async getAlerts() {
    const res = await fetch(`${BASE_URL}/api/alerts`);
    const json = await res.json();
    return json.data || [];
  },

  async sendBroadcast(broadcastData) {
    const res = await fetch(`${BASE_URL}/api/alerts`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(broadcastData)
    });
    const json = await res.json();
    return json.data;
  },

  // Chat
  async getMessages(channel) {
    const res = await fetch(`${BASE_URL}/api/messages/${channel}`);
    const json = await res.json();
    return json.data || [];
  },

  async sendMessage(channel, messageData) {
    const res = await fetch(`${BASE_URL}/api/messages/${channel}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(messageData)
    });
    const json = await res.json();
    return json.data;
  }
};

// WebSocket Real-time event listener helper
export function connectRealtime({ onMessage, onStatusChange }) {
  let ws = null;
  let reconnectTimeout = null;

  function connect() {
    try {
      ws = new WebSocket(WS_URL);

      ws.onopen = () => {
        console.log('[Realtime] Connected to backend WebSocket');
        if (onStatusChange) onStatusChange(true);
      };

      ws.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          if (onMessage) onMessage(data);
        } catch (e) {
          console.error('[Realtime] Parse error:', e);
        }
      };

      ws.onclose = () => {
        console.warn('[Realtime] WebSocket disconnected. Reconnecting in 3s...');
        if (onStatusChange) onStatusChange(false);
        reconnectTimeout = setTimeout(connect, 3000);
      };

      ws.onerror = (err) => {
        console.error('[Realtime] Socket error:', err);
      };
    } catch (e) {
      console.error('[Realtime] Connection failed:', e);
      reconnectTimeout = setTimeout(connect, 3000);
    }
  }

  connect();

  return () => {
    if (reconnectTimeout) clearTimeout(reconnectTimeout);
    if (ws) ws.close();
  };
}
