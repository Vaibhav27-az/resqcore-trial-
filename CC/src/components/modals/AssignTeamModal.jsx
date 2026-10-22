import React from 'react';
import { X, Shield, AlertTriangle, CheckCircle, ChevronRight } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { SeverityBadge } from '../common/Badge';

export const AssignTeamModal = () => {
  const { assignModalTeam, setAssignModalTeam, incidents, assignTeamToIncident } = useApp();

  if (!assignModalTeam) return null;

  const eligibleIncidents = incidents.filter(i => i.status !== 'Unverified' && !i.assignedTeam);

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        backgroundColor: 'rgba(3, 7, 18, 0.75)',
        backdropFilter: 'blur(6px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 999,
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
        {/* Modal Header */}
        <div
          style={{
            padding: '20px 24px',
            borderBottom: '1px solid #16243E',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between'
          }}
        >
          <div>
            <h3 style={{ fontSize: '17px', fontWeight: 700, color: '#FFFFFF' }}>
              Dispatch Response Team
            </h3>
            <div style={{ fontSize: '13px', color: '#94A3B8', marginTop: '2px' }}>
              Assign {assignModalTeam.name} ({assignModalTeam.specialization}) to an active incident
            </div>
          </div>
          <button
            onClick={() => setAssignModalTeam(null)}
            style={{
              background: 'transparent',
              color: '#64748B',
              padding: '4px',
              borderRadius: '6px'
            }}
            onMouseEnter={(e) => (e.currentTarget.style.color = '#FFFFFF')}
            onMouseLeave={(e) => (e.currentTarget.style.color = '#64748B')}
          >
            <X size={18} />
          </button>
        </div>

        {/* Modal Body - Incident list */}
        <div style={{ padding: '20px 24px', maxHeight: '360px', overflowY: 'auto' }}>
          <div
            style={{
              fontSize: '11px',
              fontWeight: 700,
              color: '#64748B',
              textTransform: 'uppercase',
              letterSpacing: '0.6px',
              marginBottom: '12px'
            }}
          >
            Available Incidents Requiring Response ({eligibleIncidents.length})
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {eligibleIncidents.length === 0 ? (
              <div style={{ padding: '18px 12px', color: '#94A3B8', fontSize: '13px', textAlign: 'center' }}>
                No verified incidents are currently awaiting a team.
              </div>
            ) : eligibleIncidents.map((incident) => (
              <div
                key={incident.id}
                onClick={() => assignTeamToIncident(assignModalTeam.id, incident.id)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  padding: '12px 16px',
                  backgroundColor: '#091122',
                  border: '1px solid #16243E',
                  borderRadius: '10px',
                  cursor: 'pointer',
                  transition: 'all 0.15s ease'
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.backgroundColor = '#121F38';
                  e.currentTarget.style.borderColor = '#2563EB';
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.backgroundColor = '#091122';
                  e.currentTarget.style.borderColor = '#16243E';
                }}
              >
                <div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <span style={{ fontSize: '12px', fontWeight: 600, color: '#3B82F6' }}>
                      {incident.id}
                    </span>
                    <SeverityBadge severity={incident.severity} />
                  </div>
                  <div style={{ fontSize: '14px', fontWeight: 600, color: '#FFFFFF', marginTop: '4px' }}>
                    {incident.title}
                  </div>
                  <div style={{ fontSize: '12px', color: '#94A3B8', marginTop: '2px' }}>
                    {incident.shortLocation} · {incident.affected} people affected
                  </div>
                </div>

                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '4px',
                    fontSize: '12px',
                    color: '#3B82F6',
                    fontWeight: 600
                  }}
                >
                  <span>Dispatch</span>
                  <ChevronRight size={14} />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Modal Footer */}
        <div
          style={{
            padding: '16px 24px',
            backgroundColor: '#09101E',
            borderTop: '1px solid #16243E',
            display: 'flex',
            justifyContent: 'flex-end',
            gap: '10px'
          }}
        >
          <button
            onClick={() => setAssignModalTeam(null)}
            style={{
              padding: '8px 16px',
              borderRadius: '8px',
              backgroundColor: 'transparent',
              border: '1px solid #1E2D4A',
              color: '#94A3B8',
              fontSize: '13px',
              fontWeight: 500
            }}
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};
