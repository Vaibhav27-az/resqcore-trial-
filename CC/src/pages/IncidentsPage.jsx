import React, { useState } from 'react';
import {
  Search,
  Plus,
  AlertTriangle,
  ChevronRight,
  ChevronDown,
  Download,
  X,
  FileQuestion,
  ExternalLink,
  ShieldAlert
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { SeverityBadge, StatusBadge } from '../components/common/Badge';
import { IncidentDetailDrawer } from '../components/drawers/IncidentDetailDrawer';

export const IncidentsPage = () => {
  const {
    incidents,
    setIncidents,
    inspectIncident,
    setActiveTab,
    isDrawerOpen,
    addToast,
    isDemoMode,
    user
  } = useApp();

  const [searchQuery, setSearchQuery] = useState('');
  const [severityFilter, setSeverityFilter] = useState('All');
  const [statusFilter, setStatusFilter] = useState('All');
  const [page, setPage] = useState(1);
  const pageSize = 8;

  // New Incident Modal State
  const [isNewIncidentModalOpen, setIsNewIncidentModalOpen] = useState(false);
  const [newTitle, setNewTitle] = useState('');
  const [newLocation, setNewLocation] = useState('Fort Kochi');
  const [newSeverity, setNewSeverity] = useState('High');
  const [newAffected, setNewAffected] = useState(150);
  const [newDescription, setNewDescription] = useState('');

  // Escalated incidents
  const escalatedIncidents = incidents.filter(i => i.status === 'Escalated');

  // Filtered incidents
  const filteredIncidents = incidents.filter(i => {
    const matchesSearch =
      i.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      i.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      i.location.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesSeverity = severityFilter === 'All' || i.severity === severityFilter;
    const matchesStatus = statusFilter === 'All' || i.status === statusFilter;
    return matchesSearch && matchesSeverity && matchesStatus;
  });

  const totalPages = Math.ceil(filteredIncidents.length / pageSize) || 1;
  const paginatedIncidents = filteredIncidents.slice((page - 1) * pageSize, page * pageSize);

  const handleCreateIncident = (e) => {
    e.preventDefault();
    const id = `INC-${Math.floor(2050 + Math.random() * 50)}`;
    const newInc = {
      id,
      title: newTitle || 'Emergency Alert',
      location: `${newLocation} · ${isDemoMode ? 'Ernakulam, Kerala' : (user?.district || 'Uttarakhand')}`,
      shortLocation: newLocation,
      area: newLocation,
      affected: Number(newAffected) || 100,
      time: '14:35 IST',
      timeAgo: 'Now',
      severity: newSeverity,
      status: 'Unverified',
      responseSummary: 'Awaiting verification',
      responseDetail: 'Verify to respond',
      description: newDescription || 'Urgent incident report requiring assessment.',
      fieldReport: 'Field report · Operator reported',
      coordinates: { lat: '9.9700° N', lng: '76.2500° E', x: 45, y: 50 },
      assignedTeam: null
    };

    setIncidents(prev => [newInc, ...prev]);
    setIsNewIncidentModalOpen(false);
    addToast({
      type: 'high-incident',
      title: 'New Incident Logged',
      code: `${id} · ${newInc.title}`,
      detail: `${newInc.affected} affected · Verification required`,
      incidentId: id
    });
  };

  return (
    <div style={{ display: 'flex', height: 'calc(100vh - 68px)', overflow: 'hidden' }}>
      {/* Main Content Area */}
      <div
        style={{
          flex: 1,
          overflowY: 'auto',
          padding: '28px 32px',
          display: 'flex',
          flexDirection: 'column',
          gap: '20px'
        }}
      >
        {/* Page Header */}
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: '14px' }}>
          <div>
            <h1 style={{ fontSize: '26px', fontWeight: 800, color: '#FFFFFF', letterSpacing: '-0.4px' }}>
              Incident register
            </h1>
            <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '4px' }}>
              All reported, active and resolved incidents in {isDemoMode ? 'Ernakulam' : (user?.district || 'Uttarakhand')} district.
            </p>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <button
              onClick={() => {
                alert('Exporting incident dataset as CSV...');
              }}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                padding: '9px 16px',
                borderRadius: '8px',
                backgroundColor: '#0D1527',
                border: '1px solid #1A263D',
                color: '#CBD5E1',
                fontSize: '13px',
                fontWeight: 500
              }}
            >
              <Download size={15} />
              <span>Export CSV</span>
            </button>

            <button
              onClick={() => setIsNewIncidentModalOpen(true)}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                padding: '9px 18px',
                borderRadius: '8px',
                backgroundColor: '#2563EB',
                color: '#FFFFFF',
                fontSize: '13.5px',
                fontWeight: 600,
                boxShadow: '0 4px 14px rgba(37, 99, 235, 0.4)'
              }}
            >
              <Plus size={16} />
              <span>New incident</span>
            </button>
          </div>
        </div>

        {/* ESCALATED WARNING BANNER (Matching No team available · Escalated.png) */}
        {escalatedIncidents.length > 0 && (
          <div
            style={{
              padding: '16px 20px',
              borderRadius: '12px',
              backgroundColor: 'rgba(245, 158, 11, 0.08)',
              border: '1px solid rgba(245, 158, 11, 0.35)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              gap: '16px'
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
              <div
                style={{
                  width: '36px',
                  height: '36px',
                  borderRadius: '8px',
                  backgroundColor: 'rgba(245, 158, 11, 0.15)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: '#F59E0B',
                  flexShrink: 0
                }}
              >
                <AlertTriangle size={20} />
              </div>
              <div>
                <div style={{ fontSize: '14px', fontWeight: 700, color: '#F59E0B' }}>
                  {escalatedIncidents.length} high incident requires team assignment
                </div>
                <div style={{ fontSize: '12.5px', color: '#CBD5E1', marginTop: '2px' }}>
                  {escalatedIncidents[0].id} · {escalatedIncidents[0].title} · {escalatedIncidents[0].escalationNote || 'No local team available · District response notified at 14:30 IST.'}
                </div>
              </div>
            </div>

            <button
              onClick={() => inspectIncident(escalatedIncidents[0].id, 'live-map')}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '6px',
                padding: '8px 14px',
                borderRadius: '8px',
                backgroundColor: 'rgba(245, 158, 11, 0.15)',
                border: '1px solid rgba(245, 158, 11, 0.4)',
                color: '#FBBF24',
                fontSize: '12.5px',
                fontWeight: 600,
                whiteSpace: 'nowrap'
              }}
            >
              <span>View in Live Map</span>
              <ExternalLink size={14} />
            </button>
          </div>
        )}

        {/* Filter Bar */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            flexWrap: 'wrap'
          }}
        >
          {/* Search Input */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
              padding: '9px 14px',
              backgroundColor: '#0D1527',
              border: '1px solid #1A263D',
              borderRadius: '8px',
              flex: '1',
              minWidth: '260px'
            }}
          >
            <Search size={16} color="#64748B" />
            <input
              type="text"
              placeholder="Search by ID, location or keywords..."
              value={searchQuery}
              onChange={(e) => {
                setSearchQuery(e.target.value);
                setPage(1);
              }}
              style={{
                background: 'transparent',
                border: 'none',
                color: '#FFFFFF',
                fontSize: '13px',
                width: '100%'
              }}
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery('')}
                style={{ background: 'transparent', color: '#64748B' }}
              >
                <X size={14} />
              </button>
            )}
          </div>

          {/* Severity Filter */}
          <div style={{ position: 'relative' }}>
            <select
              value={severityFilter}
              onChange={(e) => {
                setSeverityFilter(e.target.value);
                setPage(1);
              }}
              style={{
                appearance: 'none',
                padding: '9px 34px 9px 14px',
                backgroundColor: '#0D1527',
                border: '1px solid #1A263D',
                borderRadius: '8px',
                color: '#F1F5F9',
                fontSize: '13px',
                fontWeight: 500,
                cursor: 'pointer'
              }}
            >
              <option value="All">All severity</option>
              <option value="High">High</option>
              <option value="Medium">Medium</option>
              <option value="Info">Info</option>
            </select>
            <ChevronDown
              size={14}
              color="#64748B"
              style={{ position: 'absolute', right: '12px', top: '13px', pointerEvents: 'none' }}
            />
          </div>

          {/* Status Filter */}
          <div style={{ position: 'relative' }}>
            <select
              value={statusFilter}
              onChange={(e) => {
                setStatusFilter(e.target.value);
                setPage(1);
              }}
              style={{
                appearance: 'none',
                padding: '9px 34px 9px 14px',
                backgroundColor: '#0D1527',
                border: '1px solid #1A263D',
                borderRadius: '8px',
                color: '#F1F5F9',
                fontSize: '13px',
                fontWeight: 500,
                cursor: 'pointer'
              }}
            >
              <option value="All">All statuses</option>
              <option value="Unverified">Unverified</option>
              <option value="Verified">Verified</option>
              <option value="Responding">Responding</option>
              <option value="Escalated">Escalated</option>
              <option value="On site">On site</option>
              <option value="Monitoring">Monitoring</option>
            </select>
            <ChevronDown
              size={14}
              color="#64748B"
              style={{ position: 'absolute', right: '12px', top: '13px', pointerEvents: 'none' }}
            />
          </div>
        </div>

        {/* Incidents Table or Empty Search State */}
        {filteredIncidents.length === 0 ? (
          /* EMPTY STATE (Matching Empty state · Incident search.png) */
          <div
            style={{
              padding: '64px 32px',
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              borderRadius: '16px',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              textAlign: 'center'
            }}
          >
            <div
              style={{
                width: '56px',
                height: '56px',
                borderRadius: '50%',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#3B82F6',
                marginBottom: '16px'
              }}
            >
              <Search size={26} />
            </div>

            <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#FFFFFF' }}>
              No incidents match your search
            </h3>

            <p style={{ fontSize: '13.5px', color: '#64748B', maxWidth: '420px', marginTop: '6px' }}>
              Try adjusting your search terms or clearing current filters to view active incidents in {isDemoMode ? 'Ernakulam' : (user?.district || 'Uttarakhand')}.
            </p>

            <button
              onClick={() => {
                setSearchQuery('');
                setSeverityFilter('All');
                setStatusFilter('All');
              }}
              style={{
                marginTop: '20px',
                padding: '9px 20px',
                borderRadius: '8px',
                backgroundColor: '#2563EB',
                color: '#FFFFFF',
                fontSize: '13px',
                fontWeight: 600
              }}
            >
              Clear search filters
            </button>
          </div>
        ) : (
          /* Table Container */
          <div
            style={{
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              borderRadius: '16px',
              overflow: 'hidden'
            }}
          >
            <div style={{ overflowX: 'auto' }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                <thead>
                  <tr
                    style={{
                      borderBottom: '1px solid #16243E',
                      fontSize: '11px',
                      fontWeight: 700,
                      color: '#64748B',
                      letterSpacing: '0.6px',
                      textTransform: 'uppercase'
                    }}
                  >
                    <th style={{ padding: '14px 20px' }}>Incident</th>
                    <th style={{ padding: '14px 16px' }}>Location</th>
                    <th style={{ padding: '14px 16px' }}>Severity</th>
                    <th style={{ padding: '14px 16px' }}>Status</th>
                    <th style={{ padding: '14px 16px' }}>Response Assigned</th>
                    <th style={{ padding: '14px 16px' }}>Affected</th>
                    <th style={{ padding: '14px 16px' }}>Reported</th>
                    <th style={{ padding: '14px 20px', textAlign: 'right' }}>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {paginatedIncidents.map((incident) => {
                    return (
                      <tr
                        key={incident.id}
                        onClick={() => inspectIncident(incident.id)}
                        style={{
                          borderBottom: '1px solid #121E34',
                          cursor: 'pointer',
                          transition: 'background-color 0.15s ease'
                        }}
                        onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#111D36')}
                        onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = 'transparent')}
                      >
                        {/* Incident ID & Title */}
                        <td style={{ padding: '16px 20px' }}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                            <span style={{ fontSize: '12px', fontWeight: 600, color: '#3B82F6' }}>
                              {incident.id}
                            </span>
                          </div>
                          <div style={{ fontSize: '14px', fontWeight: 600, color: '#FFFFFF', marginTop: '2px' }}>
                            {incident.title}
                          </div>
                        </td>

                        {/* Location */}
                        <td style={{ padding: '16px 16px', fontSize: '13px', color: '#CBD5E1' }}>
                          {incident.shortLocation}
                        </td>

                        {/* Severity */}
                        <td style={{ padding: '16px 16px' }}>
                          <SeverityBadge severity={incident.severity} />
                        </td>

                        {/* Status */}
                        <td style={{ padding: '16px 16px' }}>
                          <StatusBadge status={incident.status} />
                        </td>

                        {/* Response Assigned */}
                        <td style={{ padding: '16px 16px' }}>
                          <div style={{ fontSize: '13px', color: '#FFFFFF', fontWeight: 500 }}>
                            {incident.responseSummary}
                          </div>
                          <div style={{ fontSize: '11px', color: '#64748B', marginTop: '2px' }}>
                            {incident.responseDetail}
                          </div>
                        </td>

                        {/* Affected */}
                        <td style={{ padding: '16px 16px', fontSize: '13.5px', fontWeight: 600, color: '#FFFFFF' }}>
                          {incident.affected}
                        </td>

                        {/* Reported */}
                        <td style={{ padding: '16px 16px', fontSize: '12.5px', color: '#94A3B8' }}>
                          {incident.time}
                        </td>

                        {/* Action Chevron */}
                        <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                          <button
                            style={{
                              background: 'transparent',
                              color: '#64748B',
                              padding: '6px',
                              borderRadius: '6px'
                            }}
                          >
                            <ChevronRight size={16} />
                          </button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Pagination Controls */}
            <div
              style={{
                padding: '16px 20px',
                borderTop: '1px solid #16243E',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                fontSize: '13px',
                color: '#64748B'
              }}
            >
              <div>
                Showing {(page - 1) * pageSize + 1} to {Math.min(page * pageSize, filteredIncidents.length)} of {filteredIncidents.length} incidents
              </div>

              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <button
                  disabled={page === 1}
                  onClick={() => setPage(p => Math.max(p - 1, 1))}
                  style={{
                    padding: '6px 12px',
                    borderRadius: '6px',
                    backgroundColor: page === 1 ? 'transparent' : '#142340',
                    border: '1px solid #1D3560',
                    color: page === 1 ? '#475569' : '#CBD5E1',
                    fontSize: '12px',
                    cursor: page === 1 ? 'not-allowed' : 'pointer'
                  }}
                >
                  Previous
                </button>

                {Array.from({ length: totalPages }).map((_, i) => (
                  <button
                    key={i}
                    onClick={() => setPage(i + 1)}
                    style={{
                      width: '28px',
                      height: '28px',
                      borderRadius: '6px',
                      backgroundColor: page === i + 1 ? '#2563EB' : 'transparent',
                      color: page === i + 1 ? '#FFFFFF' : '#94A3B8',
                      fontSize: '12px',
                      fontWeight: 600
                    }}
                  >
                    {i + 1}
                  </button>
                ))}

                <button
                  disabled={page === totalPages}
                  onClick={() => setPage(p => Math.min(p + 1, totalPages))}
                  style={{
                    padding: '6px 12px',
                    borderRadius: '6px',
                    backgroundColor: page === totalPages ? 'transparent' : '#142340',
                    border: '1px solid #1D3560',
                    color: page === totalPages ? '#475569' : '#CBD5E1',
                    fontSize: '12px',
                    cursor: page === totalPages ? 'not-allowed' : 'pointer'
                  }}
                >
                  Next
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Right Details Drawer */}
      {isDrawerOpen && <IncidentDetailDrawer />}

      {/* New Incident Modal */}
      {isNewIncidentModalOpen && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(3, 7, 18, 0.75)',
            backdropFilter: 'blur(6px)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 1000,
            padding: '20px'
          }}
        >
          <div
            className="animate-slide-up"
            style={{
              width: '100%',
              maxWidth: '520px',
              backgroundColor: '#0D1527',
              border: '1px solid #1E2E4B',
              borderRadius: '16px',
              boxShadow: '0 24px 48px rgba(0, 0, 0, 0.8)',
              overflow: 'hidden'
            }}
          >
            <div
              style={{
                padding: '20px 24px',
                borderBottom: '1px solid #16243E',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between'
              }}
            >
              <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#FFFFFF' }}>
                Log New Incident
              </h3>
              <button
                onClick={() => setIsNewIncidentModalOpen(false)}
                style={{ background: 'transparent', color: '#64748B', padding: '4px' }}
              >
                <X size={18} />
              </button>
            </div>

            <form onSubmit={handleCreateIncident} style={{ padding: '24px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div>
                <label style={{ display: 'block', fontSize: '12px', fontWeight: 600, color: '#94A3B8', marginBottom: '6px' }}>
                  Incident Title
                </label>
                <input
                  type="text"
                  placeholder="e.g. Inundated bypass road"
                  value={newTitle}
                  onChange={(e) => setNewTitle(e.target.value)}
                  required
                  style={{
                    width: '100%',
                    padding: '10px 14px',
                    backgroundColor: '#091122',
                    border: '1px solid #1A263D',
                    borderRadius: '8px',
                    color: '#FFFFFF',
                    fontSize: '13.5px'
                  }}
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '12px', fontWeight: 600, color: '#94A3B8', marginBottom: '6px' }}>
                    Location
                  </label>
                  <input
                    type="text"
                    value={newLocation}
                    onChange={(e) => setNewLocation(e.target.value)}
                    required
                    style={{
                      width: '100%',
                      padding: '10px 14px',
                      backgroundColor: '#091122',
                      border: '1px solid #1A263D',
                      borderRadius: '8px',
                      color: '#FFFFFF',
                      fontSize: '13.5px'
                    }}
                  />
                </div>

                <div>
                  <label style={{ display: 'block', fontSize: '12px', fontWeight: 600, color: '#94A3B8', marginBottom: '6px' }}>
                    Severity
                  </label>
                  <select
                    value={newSeverity}
                    onChange={(e) => setNewSeverity(e.target.value)}
                    style={{
                      width: '100%',
                      padding: '10px 14px',
                      backgroundColor: '#091122',
                      border: '1px solid #1A263D',
                      borderRadius: '8px',
                      color: '#FFFFFF',
                      fontSize: '13.5px'
                    }}
                  >
                    <option value="High">High</option>
                    <option value="Medium">Medium</option>
                    <option value="Info">Info</option>
                  </select>
                </div>
              </div>

              <div>
                <label style={{ display: 'block', fontSize: '12px', fontWeight: 600, color: '#94A3B8', marginBottom: '6px' }}>
                  Estimated Affected Citizens
                </label>
                <input
                  type="number"
                  value={newAffected}
                  onChange={(e) => setNewAffected(e.target.value)}
                  style={{
                    width: '100%',
                    padding: '10px 14px',
                    backgroundColor: '#091122',
                    border: '1px solid #1A263D',
                    borderRadius: '8px',
                    color: '#FFFFFF',
                    fontSize: '13.5px'
                  }}
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: '12px', fontWeight: 600, color: '#94A3B8', marginBottom: '6px' }}>
                  Situation Details
                </label>
                <textarea
                  rows={3}
                  placeholder="Detail the urgent conditions..."
                  value={newDescription}
                  onChange={(e) => setNewDescription(e.target.value)}
                  style={{
                    width: '100%',
                    padding: '10px 14px',
                    backgroundColor: '#091122',
                    border: '1px solid #1A263D',
                    borderRadius: '8px',
                    color: '#FFFFFF',
                    fontSize: '13.5px',
                    resize: 'none'
                  }}
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '10px' }}>
                <button
                  type="button"
                  onClick={() => setIsNewIncidentModalOpen(false)}
                  style={{
                    padding: '9px 16px',
                    borderRadius: '8px',
                    backgroundColor: 'transparent',
                    border: '1px solid #1E2D4A',
                    color: '#94A3B8',
                    fontSize: '13px'
                  }}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  style={{
                    padding: '9px 20px',
                    borderRadius: '8px',
                    backgroundColor: '#2563EB',
                    color: '#FFFFFF',
                    fontSize: '13px',
                    fontWeight: 600
                  }}
                >
                  Register Incident
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
