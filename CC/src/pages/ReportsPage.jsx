import React from 'react';
import {
  BarChart3,
  TrendingDown,
  TrendingUp,
  Download,
  Calendar,
  Layers,
  Clock,
  ShieldCheck,
  Users
} from 'lucide-react';
import { MapView } from '../components/common/MapView';
import { useApp } from '../context/AppContext';

export const ReportsPage = () => {
  const { isDemoMode } = useApp();

  const resolvedIncidents = isDemoMode ? '18' : '0';
  const resolvedPct = isDemoMode ? '+32% vs Period 03' : '0% vs Period 03';
  const avgResponseTime = isDemoMode ? '14.2 min' : '0.0 min';
  const responseTimeImprovement = isDemoMode ? '-4.1 min improvement' : 'No change';
  const citizensEvacuated = isDemoMode ? '2,840' : '0';
  const shelters = isDemoMode ? 'Across 14 operational shelters' : '0 operational shelters';
  const rescueCapacity = isDemoMode ? '75%' : '0%';
  const responseUnits = isDemoMode ? '12 of 16 response units deployed' : '0 response units deployed';

  const zoneResponseTimes = isDemoMode ? [
    { zone: 'Fort Kochi', time: '11 min', pct: 45, color: '#10B981' },
    { zone: 'Vypin Coast', time: '14 min', pct: 60, color: '#10B981' },
    { zone: 'Edappally / Bypass', time: '16 min', pct: 68, color: '#3B82F6' },
    { zone: 'Mattancherry Bridge', time: '22 min', pct: 90, color: '#F59E0B' }
  ] : [];

  const resourceInventory = isDemoMode ? [
    { name: 'Rescue Boats (Motorized)', used: '14 / 16 active', pct: 88, color: '#EF4444' },
    { name: 'Medical Emergency Kits', used: '92 / 120 issued', pct: 76, color: '#3B82F6' },
    { name: 'Potable Drinking Water Tanks', used: '38 / 50 placed', pct: 76, color: '#10B981' },
    { name: 'Shelter Capacities', used: '1,840 / 2,200', pct: 83, color: '#F59E0B' }
  ] : [
    { name: 'Rescue Boats (Motorized)', used: '0 / 0 active', pct: 0, color: '#3B82F6' },
    { name: 'Medical Emergency Kits', used: '0 / 0 issued', pct: 0, color: '#3B82F6' },
    { name: 'Potable Drinking Water Tanks', used: '0 / 0 placed', pct: 0, color: '#3B82F6' },
    { name: 'Shelter Capacities', used: '0 / 0', pct: 0, color: '#3B82F6' }
  ];
  return (
    <div style={{ padding: '28px 32px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
      {/* Header */}
      <div
        style={{
          display: 'flex',
          alignItems: 'flex-start',
          justifyContent: 'space-between',
          flexWrap: 'wrap',
          gap: '14px'
        }}
      >
        <div>
          <h1 style={{ fontSize: '26px', fontWeight: 800, color: '#FFFFFF', letterSpacing: '-0.4px' }}>
            Disaster intelligence & reporting
          </h1>
          <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '4px' }}>
            Operational analytics, incident concentration heatmaps and response telemetry.
          </p>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div
            style={{
              padding: '8px 14px',
              borderRadius: '8px',
              backgroundColor: '#0D1527',
              border: '1px solid #1A263D',
              color: '#CBD5E1',
              fontSize: '13px',
              fontWeight: 500,
              display: 'flex',
              alignItems: 'center',
              gap: '8px'
            }}
          >
            <Calendar size={15} color="#3B82F6" />
            <span>Operational Period 04 · Kerala 2026</span>
          </div>

          <button
            onClick={() => alert('Compiling Operational Period Report PDF...')}
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
            <Download size={16} />
            <span>Export Report PDF</span>
          </button>
        </div>
      </div>

      {/* 4 Metric Cards */}
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
          gap: '16px'
        }}
      >
        <div
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px'
          }}
        >
          <div style={{ fontSize: '12.5px', color: '#94A3B8', fontWeight: 500 }}>
            Resolved Incidents
          </div>
          <div style={{ fontSize: '32px', fontWeight: 800, color: '#FFFFFF', marginTop: '8px' }}>
            {resolvedIncidents}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', color: '#10B981', marginTop: '6px' }}>
            <TrendingUp size={14} />
            <span>{resolvedPct}</span>
          </div>
        </div>

        <div
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px'
          }}
        >
          <div style={{ fontSize: '12.5px', color: '#94A3B8', fontWeight: 500 }}>
            Average Response Time
          </div>
          <div style={{ fontSize: '32px', fontWeight: 800, color: '#FFFFFF', marginTop: '8px' }}>
            {avgResponseTime}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', color: '#10B981', marginTop: '6px' }}>
            <TrendingDown size={14} />
            <span>{responseTimeImprovement}</span>
          </div>
        </div>

        <div
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px'
          }}
        >
          <div style={{ fontSize: '12.5px', color: '#94A3B8', fontWeight: 500 }}>
            Citizens Evacuated / Sheltered
          </div>
          <div style={{ fontSize: '32px', fontWeight: 800, color: '#FFFFFF', marginTop: '8px' }}>
            {citizensEvacuated}
          </div>
          <div style={{ fontSize: '12px', color: '#64748B', marginTop: '6px' }}>
            {shelters}
          </div>
        </div>

        <div
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px'
          }}
        >
          <div style={{ fontSize: '12.5px', color: '#94A3B8', fontWeight: 500 }}>
            Rescue Capacity Engaged
          </div>
          <div style={{ fontSize: '32px', fontWeight: 800, color: '#FFFFFF', marginTop: '8px' }}>
            {rescueCapacity}
          </div>
          <div style={{ fontSize: '12px', color: '#64748B', marginTop: '6px' }}>
            {responseUnits}
          </div>
        </div>
      </div>

      {/* Main Grid: Concentration Heatmap vs Charts */}
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1.4fr 1fr',
          gap: '20px',
          alignItems: 'start'
        }}
      >
        {/* Incident Concentration Heatmap */}
        <div
          style={{
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '16px',
            padding: '22px',
            display: 'flex',
            flexDirection: 'column',
            gap: '14px'
          }}
        >
          <div>
            <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
              Incident Concentration Heatmap
            </h3>
            <p style={{ fontSize: '12px', color: '#64748B', marginTop: '2px' }}>
              Density analysis of flash flooding & structural failure calls
            </p>
          </div>

          <div style={{ height: '420px', borderRadius: '12px', overflow: 'hidden' }}>
            <MapView height="100%" showHeatmap={true} showFullControls={false} />
          </div>

          {/* Heatmap Legend */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              fontSize: '11.5px',
              color: '#94A3B8'
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
              <span style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#EF4444' }} />
                High Density (Fort Kochi · Mattancherry)
              </span>
              <span style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#F59E0B' }} />
                Moderate Surge (Vypin · Thevara)
              </span>
            </div>
            <span style={{ color: '#64748B' }}>Telemetry refreshed 14:30 IST</span>
          </div>
        </div>

        {/* Analytics Breakdown Column */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
          {/* Response Time by Zone Card */}
          <div
            style={{
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              borderRadius: '16px',
              padding: '22px'
            }}
          >
            <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF', marginBottom: '16px' }}>
              Response Time by Zone
            </h3>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
              {zoneResponseTimes.length > 0 ? zoneResponseTimes.map((item) => (
                <div key={item.zone}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12.5px', marginBottom: '6px' }}>
                    <span style={{ color: '#CBD5E1', fontWeight: 500 }}>{item.zone}</span>
                    <span style={{ color: '#FFFFFF', fontWeight: 600 }}>{item.time}</span>
                  </div>
                  <div style={{ width: '100%', height: '7px', borderRadius: '4px', backgroundColor: '#080E1C', overflow: 'hidden' }}>
                    <div style={{ width: `${item.pct}%`, height: '100%', backgroundColor: item.color, borderRadius: '4px' }} />
                  </div>
                </div>
              )) : (
                <div style={{ color: '#64748B', fontSize: '13px', padding: '20px 0', textAlign: 'center' }}>
                  No active incidents recorded
                </div>
              )}
            </div>
          </div>

          {/* Critical Resource Utilization */}
          <div
            style={{
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              borderRadius: '16px',
              padding: '22px'
            }}
          >
            <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF', marginBottom: '16px' }}>
              Resource Inventory
            </h3>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
              {resourceInventory.map((res) => (
                <div key={res.name}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12.5px', marginBottom: '6px' }}>
                    <span style={{ color: '#CBD5E1', fontWeight: 500 }}>{res.name}</span>
                    <span style={{ color: '#94A3B8', fontSize: '12px' }}>{res.used}</span>
                  </div>
                  <div style={{ width: '100%', height: '7px', borderRadius: '4px', backgroundColor: '#080E1C', overflow: 'hidden' }}>
                    <div style={{ width: `${res.pct}%`, height: '100%', backgroundColor: res.color, borderRadius: '4px' }} />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
