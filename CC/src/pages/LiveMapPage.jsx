import React, { useState } from 'react';
import {
  Search,
  Filter,
  ChevronDown,
  ChevronRight,
  Shield,
  Layers,
  ArrowRight,
  X
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { MapView } from '../components/common/MapView';
import { SeverityBadge, StatusBadge } from '../components/common/Badge';
import { IncidentDetailDrawer } from '../components/drawers/IncidentDetailDrawer';

export const LiveMapPage = () => {
  const {
    incidents,
    selectedIncidentId,
    setSelectedIncidentId,
    inspectIncident,
    isDrawerOpen,
    setIsDrawerOpen,
    isDemoMode,
    user
  } = useApp();

  const [searchQuery, setSearchQuery] = useState('');
  const [severityFilter, setSeverityFilter] = useState('All');
  const [statusFilter, setStatusFilter] = useState('All');
  const [showTeams, setShowTeams] = useState(true);

  // Filtered incidents
  const filteredIncidents = incidents.filter(i => {
    const matchesSearch =
      i.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      i.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      i.shortLocation.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesSeverity = severityFilter === 'All' || i.severity === severityFilter;
    const matchesStatus = statusFilter === 'All' || i.status === statusFilter;
    return matchesSearch && matchesSeverity && matchesStatus;
  });

  const selectedIncident = incidents.find(i => i.id === selectedIncidentId);
  const isVerifiedResponse = selectedIncident?.status === 'Verified';

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: 'calc(100vh - 68px)', overflow: 'hidden' }}>
      {/* Subheader & Controls */}
      <div
        style={{
          padding: '20px 28px 16px 28px',
          borderBottom: '1px solid #16243E',
          display: 'flex',
          flexDirection: 'column',
          gap: '16px',
          backgroundColor: '#070C16'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <h1 style={{ fontSize: '24px', fontWeight: 800, color: '#FFFFFF', letterSpacing: '-0.3px' }}>
              Live response map
            </h1>
            <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '2px' }}>
              Track incidents and deployed teams across {isDemoMode ? 'Ernakulam' : (user?.district || 'Uttarakhand')}.
            </p>
          </div>

          <div>
            {isVerifiedResponse ? (
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 14px',
                  borderRadius: '9999px',
                  backgroundColor: 'rgba(16, 185, 129, 0.15)',
                  border: '1px solid rgba(16, 185, 129, 0.4)',
                  color: '#10B981',
                  fontSize: '12px',
                  fontWeight: 600
                }}
              >
                <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#10B981' }} />
                Verified · Response initiated
              </div>
            ) : (
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 14px',
                  borderRadius: '9999px',
                  backgroundColor: 'rgba(16, 185, 129, 0.1)',
                  border: '1px solid rgba(16, 185, 129, 0.25)',
                  color: '#10B981',
                  fontSize: '12px',
                  fontWeight: 600
                }}
              >
                <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#10B981' }} />
                Live · 14:32 IST
              </div>
            )}
          </div>
        </div>

        {/* Filter Controls Bar */}
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
              padding: '8px 14px',
              backgroundColor: '#0D1527',
              border: '1px solid #1A263D',
              borderRadius: '8px',
              flex: '1',
              minWidth: '240px'
            }}
          >
            <Search size={16} color="#64748B" />
            <input
              type="text"
              placeholder="Search location or incident ID"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
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

          {/* Severity Dropdown */}
          <div style={{ position: 'relative' }}>
            <select
              value={severityFilter}
              onChange={(e) => setSeverityFilter(e.target.value)}
              style={{
                appearance: 'none',
                padding: '8px 32px 8px 14px',
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
              style={{ position: 'absolute', right: '12px', top: '12px', pointerEvents: 'none' }}
            />
          </div>

          {/* Status Dropdown */}
          <div style={{ position: 'relative' }}>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              style={{
                appearance: 'none',
                padding: '8px 32px 8px 14px',
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
              style={{ position: 'absolute', right: '12px', top: '12px', pointerEvents: 'none' }}
            />
          </div>

          {/* Show Teams Toggle */}
          <div
            onClick={() => setShowTeams(!showTeams)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
              padding: '6px 12px',
              backgroundColor: '#0D1527',
              border: '1px solid #1A263D',
              borderRadius: '8px',
              cursor: 'pointer'
            }}
          >
            <Layers size={15} color="#3B82F6" />
            <span style={{ fontSize: '13px', color: '#CBD5E1', fontWeight: 500 }}>
              Show teams
            </span>
            <span
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '4px',
                fontSize: '11px',
                fontWeight: 600,
                color: showTeams ? '#10B981' : '#64748B',
                backgroundColor: showTeams ? 'rgba(16, 185, 129, 0.15)' : '#162238',
                padding: '2px 8px',
                borderRadius: '9999px'
              }}
            >
              <span
                style={{
                  width: '5px',
                  height: '5px',
                  borderRadius: '50%',
                  backgroundColor: showTeams ? '#10B981' : '#64748B'
                }}
              />
              {showTeams ? 'On' : 'Off'}
            </span>
          </div>

          <div style={{ marginLeft: 'auto', fontSize: '13px', color: '#64748B' }}>
            {filteredIncidents.length} active incidents
          </div>
        </div>
      </div>

      {/* Main Map View & Side Panel */}
      <div style={{ display: 'flex', flex: 1, overflow: 'hidden', position: 'relative' }}>
        {/* Map Canvas */}
        <div style={{ flex: 1, padding: '20px', height: '100%', position: 'relative' }}>
          <MapView height="100%" showDetailsOnClick={true} />

          {/* Coordinates Overlay */}
          <div
            style={{
              position: 'absolute',
              bottom: '26px',
              left: '36px',
              fontSize: '11px',
              color: '#64748B',
              letterSpacing: '0.4px',
              zIndex: 20
            }}
            className="mono"
          >
            9.9658° N · 76.2421° E · Zoom 13
          </div>

          <div
            style={{
              position: 'absolute',
              bottom: '26px',
              right: '90px',
              fontSize: '11px',
              color: '#64748B',
              zIndex: 20
            }}
          >
            Satellite · {filteredIncidents.length} incidents in view
          </div>
        </div>

        {/* Right Side Dock: Incident List or Details Drawer */}
        {isDrawerOpen ? (
          <IncidentDetailDrawer />
        ) : (
          <div
            style={{
              width: '360px',
              minWidth: '360px',
              height: '100%',
              backgroundColor: '#0D1527',
              borderLeft: '1px solid #16243E',
              display: 'flex',
              flexDirection: 'column',
              overflowY: 'auto'
            }}
          >
            <div
              style={{
                padding: '20px 22px 14px 22px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                borderBottom: '1px solid #16243E'
              }}
            >
              <div>
                <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF' }}>
                  Incidents in view
                </h3>
                <span style={{ fontSize: '12px', color: '#64748B' }}>Highest priority first</span>
              </div>
              <span style={{ fontSize: '12px', color: '#3B82F6', fontWeight: 600 }}>
                {filteredIncidents.length} results
              </span>
            </div>

            <div style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {filteredIncidents.map((incident) => {
                const isSelected = selectedIncidentId === incident.id;
                return (
                  <div
                    key={incident.id}
                    onClick={() => inspectIncident(incident.id)}
                    style={{
                      padding: '14px 16px',
                      backgroundColor: isSelected ? '#12203D' : '#080E1C',
                      border: `1px solid ${isSelected ? '#2563EB' : '#162238'}`,
                      borderRadius: '12px',
                      cursor: 'pointer',
                      transition: 'all 0.15s ease'
                    }}
                    onMouseEnter={(e) => {
                      if (!isSelected) e.currentTarget.style.backgroundColor = '#0F1A30';
                    }}
                    onMouseLeave={(e) => {
                      if (!isSelected) e.currentTarget.style.backgroundColor = '#080E1C';
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                      <span style={{ fontSize: '14px', fontWeight: 700, color: '#FFFFFF' }}>
                        {incident.title}
                      </span>
                      <SeverityBadge severity={incident.severity} />
                    </div>

                    <div style={{ fontSize: '12px', color: '#94A3B8', marginTop: '4px' }}>
                      {incident.id} · {incident.shortLocation} · {incident.affected} affected
                    </div>

                    <div
                      style={{
                        marginTop: '10px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between'
                      }}
                    >
                      <span
                        style={{
                          fontSize: '12px',
                          color: '#3B82F6',
                          fontWeight: 600,
                          display: 'flex',
                          alignItems: 'center',
                          gap: '4px'
                        }}
                      >
                        View Incident Details <ArrowRight size={13} />
                      </span>

                      {incident.status === 'Escalated' && (
                        <span style={{ fontSize: '11px', color: '#F59E0B', fontWeight: 500 }}>
                          No team available
                        </span>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
