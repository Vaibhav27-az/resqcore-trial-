import React, { useState } from 'react';
import {
  Users,
  Shield,
  Search,
  ChevronDown,
  Radio,
  CheckCircle2,
  Clock,
  ArrowRight,
  MapPin,
  LifeBuoy
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { StatusBadge } from '../components/common/Badge';
import { AssignTeamModal } from '../components/modals/AssignTeamModal';

export const TeamsPage = () => {
  const { teams, setAssignModalTeam, isDemoMode, user } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');

  const filteredTeams = teams.filter(team => {
    const matchesSearch =
      team.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      team.lead.toLowerCase().includes(searchQuery.toLowerCase()) ||
      team.specialization.toLowerCase().includes(searchQuery.toLowerCase()) ||
      team.staging.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus = statusFilter === 'All' || team.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const deployedCount = teams.filter(t => t.status === 'Deployed' || t.status === 'On site').length;
  const availableCount = teams.filter(t => t.status === 'Available').length;

  return (
    <div style={{ padding: '28px 32px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
      {/* Header & Metrics */}
      <div
        style={{
          display: 'flex',
          alignItems: 'flex-start',
          justifyContent: 'space-between',
          flexWrap: 'wrap',
          gap: '16px'
        }}
      >
        <div>
          <h1 style={{ fontSize: '26px', fontWeight: 800, color: '#FFFFFF', letterSpacing: '-0.4px' }}>
            Response teams
          </h1>
          <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '4px' }}>
            Coordinate deployed and available units in {isDemoMode ? 'Ernakulam' : (user?.district || 'Uttarakhand')}.
          </p>
        </div>

        {/* Readiness Counters */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div
            style={{
              padding: '8px 16px',
              borderRadius: '10px',
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              display: 'flex',
              alignItems: 'center',
              gap: '10px'
            }}
          >
            <span style={{ fontSize: '13px', color: '#94A3B8' }}>Deployed:</span>
            <span style={{ fontSize: '14px', fontWeight: 700, color: '#10B981' }}>
              {deployedCount}
            </span>
          </div>

          <div
            style={{
              padding: '8px 16px',
              borderRadius: '10px',
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              display: 'flex',
              alignItems: 'center',
              gap: '10px'
            }}
          >
            <span style={{ fontSize: '13px', color: '#94A3B8' }}>Available:</span>
            <span style={{ fontSize: '14px', fontWeight: 700, color: '#3B82F6' }}>
              {availableCount}
            </span>
          </div>
        </div>
      </div>

      {/* Filter Controls */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px', flexWrap: 'wrap' }}>
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
            minWidth: '240px'
          }}
        >
          <Search size={16} color="#64748B" />
          <input
            type="text"
            placeholder="Search team name, lead, staging or specialization..."
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
        </div>

        <div style={{ position: 'relative' }}>
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
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
            <option value="Deployed">Deployed</option>
            <option value="Available">Available</option>
            <option value="On site">On site</option>
          </select>
          <ChevronDown
            size={14}
            color="#64748B"
            style={{ position: 'absolute', right: '12px', top: '13px', pointerEvents: 'none' }}
          />
        </div>
      </div>

      {/* Teams Grid */}
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fill, minmax(340px, 1fr))',
          gap: '20px'
        }}
      >
        {filteredTeams.map((team) => {
          const isAvailable = team.status === 'Available';

          return (
            <div
              key={team.id}
              style={{
                backgroundColor: '#0D1527',
                border: '1px solid #16243E',
                borderRadius: '16px',
                padding: '22px',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
                gap: '18px',
                transition: 'all 0.15s ease'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = '#121F38';
                e.currentTarget.style.borderColor = isAvailable ? '#2563EB' : '#1D3560';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = '#0D1527';
                e.currentTarget.style.borderColor = '#16243E';
              }}
            >
              {/* Card Top */}
              <div>
                <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between' }}>
                  <div>
                    <h3 style={{ fontSize: '18px', fontWeight: 800, color: '#FFFFFF' }}>
                      {team.name}
                    </h3>
                    <div style={{ fontSize: '12.5px', color: '#38BDF8', marginTop: '2px', fontWeight: 500 }}>
                      {team.specialization}
                    </div>
                  </div>

                  <StatusBadge status={team.status} />
                </div>

                {/* Team Personnel & Staging */}
                <div
                  style={{
                    display: 'grid',
                    gridTemplateColumns: '1fr 1fr',
                    gap: '12px',
                    marginTop: '16px',
                    padding: '12px 14px',
                    backgroundColor: '#080E1C',
                    borderRadius: '10px',
                    border: '1px solid #142034'
                  }}
                >
                  <div>
                    <span style={{ fontSize: '11px', color: '#64748B' }}>Personnel</span>
                    <div style={{ fontSize: '13px', fontWeight: 600, color: '#FFFFFF', marginTop: '2px' }}>
                      {team.responders} responders
                    </div>
                  </div>
                  <div>
                    <span style={{ fontSize: '11px', color: '#64748B' }}>Team Lead</span>
                    <div style={{ fontSize: '13px', fontWeight: 600, color: '#CBD5E1', marginTop: '2px' }}>
                      {team.lead}
                    </div>
                  </div>
                </div>

                <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '12px', color: '#94A3B8', marginTop: '12px' }}>
                  <MapPin size={14} color="#64748B" />
                  <span>Staging: {team.staging}</span>
                </div>
              </div>

              {/* Status & Assignment Box */}
              <div>
                {isAvailable ? (
                  <div
                    style={{
                      padding: '14px',
                      backgroundColor: 'rgba(59, 130, 246, 0.08)',
                      border: '1px solid rgba(59, 130, 246, 0.25)',
                      borderRadius: '10px'
                    }}
                  >
                    <div style={{ fontSize: '13px', fontWeight: 600, color: '#60A5FA' }}>
                      {team.readiness || 'Ready for deployment'}
                    </div>
                    <div style={{ fontSize: '11.5px', color: '#94A3B8', marginTop: '3px' }}>
                      {team.equipment || 'Standard rescue gear & comms'}
                    </div>

                    <button
                      onClick={() => setAssignModalTeam(team)}
                      style={{
                        marginTop: '12px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '6px',
                        width: '100%',
                        padding: '10px',
                        borderRadius: '8px',
                        backgroundColor: '#2563EB',
                        color: '#FFFFFF',
                        fontSize: '13px',
                        fontWeight: 600
                      }}
                      onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#3B82F6')}
                      onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = '#2563EB')}
                    >
                      <span>Assign to incident</span>
                      <ArrowRight size={14} />
                    </button>
                  </div>
                ) : (
                  <div
                    style={{
                      padding: '14px',
                      backgroundColor: '#080E1C',
                      border: '1px solid #16243E',
                      borderRadius: '10px'
                    }}
                  >
                    <div style={{ fontSize: '11px', color: '#64748B', fontWeight: 600, textTransform: 'uppercase' }}>
                      Active Assignment
                    </div>
                    <div style={{ fontSize: '13.5px', fontWeight: 600, color: '#FFFFFF', marginTop: '4px' }}>
                      {team.task}
                    </div>
                    <div style={{ fontSize: '12px', color: '#10B981', fontWeight: 600, marginTop: '4px' }}>
                      {team.eta || team.note || 'On site responding'}
                    </div>
                  </div>
                )}

                {/* Radio Status indicator */}
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: '14px',
                    fontSize: '11px',
                    color: '#64748B'
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#10B981' }} />
                    <span style={{ color: '#10B981', fontWeight: 500 }}>Radio Online</span>
                  </div>
                  <span>{team.lastUpdate}</span>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Team Assignment Modal */}
      <AssignTeamModal />
    </div>
  );
};
