import React, { useState } from 'react';
import {
  AlertTriangle,
  Users,
  Shield,
  Package,
  ExternalLink,
  ChevronRight,
  Radio,
  Eye,
  X,
  RefreshCw
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { MapView } from '../components/common/MapView';
import { WeatherForecastWidget } from '../components/common/WeatherForecastWidget';

export const CommandCenter = () => {
  const {
    incidents,
    teams,
    cameras,
    alerts,
    setActiveTab,
    inspectIncident,
    isLoadingSync,
    isDemoMode,
    user
  } = useApp();

  const [activeCameraModal, setActiveCameraModal] = useState(null);

  const activeIncidentsCount = incidents.length;
  const highCount = incidents.filter(i => i.severity === 'High').length;
  const medCount = incidents.filter(i => i.severity === 'Medium').length;
  const infoCount = incidents.filter(i => i.severity === 'Info').length;

  const peopleAffected = isDemoMode ? '1,284' : '0';
  const zonesAffected = isDemoMode ? 'Across 8 response zones' : '0 response zones';
  const teamsDeployed = isDemoMode ? '12 / 16' : '0 / 0';
  const teamsAvailable = isDemoMode ? '4 teams available for response' : '0 teams available';
  const reliefSupplies = isDemoMode ? '8,450' : '0';
  const reliefDetails = isDemoMode ? 'Units ready · 6 distribution hubs' : 'No active operations';

  return (
    <div style={{ padding: '28px 32px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
      {/* Page Header */}
      <div
        style={{
          display: 'flex',
          alignItems: 'flex-start',
          justifyContent: 'space-between',
          flexWrap: 'wrap',
          gap: '12px'
        }}
      >
        <div>
          <h1
            style={{
              fontSize: '26px',
              fontWeight: 800,
              color: '#FFFFFF',
              letterSpacing: '-0.4px'
            }}
          >
            Operational overview
          </h1>
          <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '4px' }}>
            {isDemoMode ? 'Ernakulam district, Kerala' : (user?.district || 'Dehradun, Uttarakhand')} · Friday, 09 October 2026
          </p>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '6px 12px',
              borderRadius: '9999px',
              backgroundColor: 'rgba(16, 185, 129, 0.1)',
              border: '1px solid rgba(16, 185, 129, 0.25)',
              color: '#10B981',
              fontSize: '12px',
              fontWeight: 600
            }}
          >
            <span
              style={{
                width: '6px',
                height: '6px',
                borderRadius: '50%',
                backgroundColor: '#10B981'
              }}
            />
            Live
          </div>

          <span style={{ fontSize: '12.5px', color: '#64748B' }}>
            Last synced 14:32 IST
          </span>
        </div>
      </div>

      {/* 4 KPI Metrics Grid */}
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
          gap: '16px'
        }}
      >
        {/* Metric 1: Active Incidents */}
        <div
          onClick={() => setActiveTab('incidents')}
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px',
            cursor: 'pointer',
            transition: 'all 0.15s ease'
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.backgroundColor = '#121E36';
            e.currentTarget.style.borderColor = '#2563EB';
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.backgroundColor = '#0D1527';
            e.currentTarget.style.borderColor = '#16243E';
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontSize: '13px', color: '#94A3B8', fontWeight: 500 }}>
              Active Incidents
            </span>
            <div
              style={{
                width: '32px',
                height: '32px',
                borderRadius: '8px',
                backgroundColor: 'rgba(239, 68, 68, 0.12)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#EF4444'
              }}
            >
              <AlertTriangle size={18} />
            </div>
          </div>

          <div
            style={{
              fontSize: '32px',
              fontWeight: 800,
              color: '#FFFFFF',
              marginTop: '12px',
              letterSpacing: '-0.5px'
            }}
          >
            {activeIncidentsCount}
          </div>

          <div style={{ fontSize: '12px', color: '#64748B', marginTop: '6px' }}>
            {highCount} High · {medCount} Medium · {infoCount} Info
          </div>
        </div>

        {/* Metric 2: People Affected */}
        <div
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontSize: '13px', color: '#94A3B8', fontWeight: 500 }}>
              People Affected
            </span>
            <div
              style={{
                width: '32px',
                height: '32px',
                borderRadius: '8px',
                backgroundColor: 'rgba(59, 130, 246, 0.12)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#3B82F6'
              }}
            >
              <Users size={18} />
            </div>
          </div>

          <div
            style={{
              fontSize: '32px',
              fontWeight: 800,
              color: '#FFFFFF',
              marginTop: '12px',
              letterSpacing: '-0.5px'
            }}
          >
            {peopleAffected}
          </div>

          <div style={{ fontSize: '12px', color: '#64748B', marginTop: '6px' }}>
            {zonesAffected}
          </div>
        </div>

        {/* Metric 3: Rescue Teams Deployed */}
        <div
          onClick={() => setActiveTab('teams')}
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px',
            cursor: 'pointer',
            transition: 'all 0.15s ease'
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.backgroundColor = '#121E36';
            e.currentTarget.style.borderColor = '#10B981';
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.backgroundColor = '#0D1527';
            e.currentTarget.style.borderColor = '#16243E';
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontSize: '13px', color: '#94A3B8', fontWeight: 500 }}>
              Rescue Teams Deployed
            </span>
            <div
              style={{
                width: '32px',
                height: '32px',
                borderRadius: '8px',
                backgroundColor: 'rgba(16, 185, 129, 0.12)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#10B981'
              }}
            >
              <Shield size={18} />
            </div>
          </div>

          <div
            style={{
              fontSize: '32px',
              fontWeight: 800,
              color: '#FFFFFF',
              marginTop: '12px',
              letterSpacing: '-0.5px'
            }}
          >
            {teamsDeployed}
          </div>

          <div style={{ fontSize: '12px', color: '#64748B', marginTop: '6px' }}>
            {teamsAvailable}
          </div>
        </div>

        {/* Metric 4: Relief Supplies */}
        <div
          style={{
            padding: '20px 22px',
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '14px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontSize: '13px', color: '#94A3B8', fontWeight: 500 }}>
              Relief Supplies
            </span>
            <div
              style={{
                width: '32px',
                height: '32px',
                borderRadius: '8px',
                backgroundColor: 'rgba(245, 158, 11, 0.12)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#F59E0B'
              }}
            >
              <Package size={18} />
            </div>
          </div>

          <div
            style={{
              fontSize: '32px',
              fontWeight: 800,
              color: '#FFFFFF',
              marginTop: '12px',
              letterSpacing: '-0.5px'
            }}
          >
            {reliefSupplies}
          </div>

          <div style={{ fontSize: '12px', color: '#64748B', marginTop: '6px' }}>
            {reliefDetails}
          </div>
        </div>
      </div>

      {/* Real-Time Weather Forecasting Intelligence (Only in Real Command Center, NOT in demo mode) */}
      {!isDemoMode && (
        <WeatherForecastWidget district={user?.district || 'Dehradun, Uttarakhand'} />
      )}

      {/* Main Content Grid: Map vs Side Panels */}
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1.9fr 1fr',
          gap: '20px',
          alignItems: 'start'
        }}
      >
        {/* Left Column: Area Intelligence Map */}
        <div
          style={{
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '16px',
            padding: '20px',
            display: 'flex',
            flexDirection: 'column',
            gap: '14px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
                Area intelligence
              </h3>
              <p style={{ fontSize: '12px', color: '#64748B', marginTop: '2px' }}>
                {isDemoMode ? 'Satellite overview · Ernakulam response zone' : `Tactical overview · ${user?.district || 'Uttarakhand response zone'}`}
              </p>
            </div>

            <button
              onClick={() => setActiveTab('live-map')}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '6px',
                backgroundColor: 'transparent',
                color: '#3B82F6',
                fontSize: '13px',
                fontWeight: 600
              }}
            >
              <span>Open Live Map</span>
              <ExternalLink size={14} />
            </button>
          </div>

          {/* SKELETON LOADING STATE (matches Loading state · Command Center.png) */}
          {isLoadingSync ? (
            <div
              style={{
                height: '450px',
                borderRadius: '14px',
                backgroundColor: '#070C16',
                border: '1px solid #1A263D',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                padding: '40px',
                textAlign: 'center'
              }}
            >
              <div
                style={{
                  width: '44px',
                  height: '44px',
                  borderRadius: '50%',
                  border: '3px solid #1E2E4B',
                  borderTopColor: '#3B82F6',
                  animation: 'spin 1s linear infinite',
                  marginBottom: '18px'
                }}
              />
              <style>{`@keyframes spin { 100% { transform: rotate(360deg); } }`}</style>

              <h4 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
                Loading satellite intelligence
              </h4>
              <p style={{ fontSize: '13px', color: '#64748B', marginTop: '6px' }}>
                Retrieving map layers and live incident reports.
              </p>

              {/* Progress bar */}
              <div
                style={{
                  width: '260px',
                  height: '4px',
                  borderRadius: '2px',
                  backgroundColor: '#1E2E4B',
                  marginTop: '20px',
                  overflow: 'hidden'
                }}
              >
                <div
                  style={{
                    width: '60%',
                    height: '100%',
                    backgroundColor: '#3B82F6',
                    borderRadius: '2px',
                    animation: 'pulseGlow 1s ease-in-out infinite'
                  }}
                />
              </div>

              <span style={{ fontSize: '11px', color: '#475569', marginTop: '12px' }}>
                Secure connection established · Sync in progress
              </span>
            </div>
          ) : (
            <div style={{ height: '450px' }}>
              <MapView height="100%" showDetailsOnClick={true} />
            </div>
          )}

          {/* Footer note */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              fontSize: '11px',
              color: '#64748B',
              paddingTop: '4px'
            }}
          >
            <span>Satellite layer · Updated 14:30 IST</span>
            <span>6 of 24 incidents in view</span>
          </div>
        </div>

        {/* Right Column: Recent Alerts & Live Cameras */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
          {/* Recent Alerts Card */}
          <div
            style={{
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              borderRadius: '16px',
              padding: '20px'
            }}
          >
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                marginBottom: '16px'
              }}
            >
              <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF' }}>
                Recent Alerts
              </h3>
              <button
                onClick={() => setActiveTab('incidents')}
                style={{
                  backgroundColor: 'transparent',
                  color: '#3B82F6',
                  fontSize: '12px',
                  fontWeight: 600
                }}
              >
                View all
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {alerts.slice(0, 3).map((alert) => (
                <div
                  key={alert.id}
                  onClick={() => inspectIncident(alert.code, 'live-map')}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '12px',
                    padding: '12px',
                    backgroundColor: '#080E1C',
                    borderRadius: '10px',
                    border: '1px solid #162238',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease'
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#111C34')}
                  onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = '#080E1C')}
                >
                  <div
                    style={{
                      width: '28px',
                      height: '28px',
                      borderRadius: '6px',
                      backgroundColor: 'rgba(239, 68, 68, 0.15)',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      color: '#EF4444',
                      flexShrink: 0
                    }}
                  >
                    <AlertTriangle size={15} />
                  </div>

                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <span
                        className="truncate"
                        style={{ fontSize: '13px', fontWeight: 600, color: '#FFFFFF' }}
                      >
                        {alert.title}
                      </span>
                      <span style={{ fontSize: '11px', color: '#64748B' }}>
                        {alert.timeAgo}
                      </span>
                    </div>
                    <div style={{ fontSize: '11.5px', color: '#94A3B8', marginTop: '2px' }}>
                      {alert.subtitle}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Live Camera Feeds Card */}
          <div
            style={{
              backgroundColor: '#0D1527',
              border: '1px solid #16243E',
              borderRadius: '16px',
              padding: '20px'
            }}
          >
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                marginBottom: '16px'
              }}
            >
              <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF' }}>
                Live Camera Feeds
              </h3>
              <span style={{ fontSize: '12px', color: '#10B981', fontWeight: 600 }}>
                3 / 3 online
              </span>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {cameras.map((cam) => (
                <div
                  key={cam.id}
                  onClick={() => setActiveCameraModal(cam)}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px',
                    padding: '8px 10px',
                    backgroundColor: '#080E1C',
                    borderRadius: '10px',
                    border: '1px solid #162238',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease'
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#111C34')}
                  onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = '#080E1C')}
                >
                  {/* Video Thumbnail */}
                  <div
                    style={{
                      width: '72px',
                      height: '46px',
                      borderRadius: '6px',
                      overflow: 'hidden',
                      position: 'relative',
                      backgroundColor: '#000000',
                      flexShrink: 0
                    }}
                  >
                    <img
                      src={cam.image}
                      alt={cam.name}
                      style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                    />
                    <div
                      style={{
                        position: 'absolute',
                        top: '3px',
                        left: '4px',
                        padding: '1px 4px',
                        borderRadius: '3px',
                        backgroundColor: '#EF4444',
                        color: '#FFFFFF',
                        fontSize: '8px',
                        fontWeight: 700
                      }}
                    >
                      LIVE
                    </div>
                  </div>

                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: '13px', fontWeight: 600, color: '#FFFFFF' }}>
                      {cam.name}
                    </div>
                    <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '2px' }}>
                      {cam.subtitle}
                    </div>
                    <div style={{ fontSize: '10px', color: '#64748B', marginTop: '1px' }}>
                      {cam.tag}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* CCTV Camera Modal */}
      {activeCameraModal && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(2, 6, 17, 0.85)',
            backdropFilter: 'blur(8px)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 1000,
            padding: '24px'
          }}
        >
          <div
            className="animate-slide-up"
            style={{
              width: '100%',
              maxWidth: '680px',
              backgroundColor: '#0D1527',
              border: '1px solid #1E2E4B',
              borderRadius: '16px',
              overflow: 'hidden'
            }}
          >
            <div
              style={{
                padding: '16px 20px',
                borderBottom: '1px solid #16243E',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between'
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#EF4444' }} />
                <span style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF' }}>
                  {activeCameraModal.name} · {activeCameraModal.tag}
                </span>
              </div>
              <button
                onClick={() => setActiveCameraModal(null)}
                style={{ background: 'transparent', color: '#64748B', padding: '4px' }}
              >
                <X size={18} />
              </button>
            </div>

            <div style={{ position: 'relative', height: '360px', backgroundColor: '#000000' }}>
              <img
                src={activeCameraModal.image}
                alt={activeCameraModal.name}
                style={{ width: '100%', height: '100%', objectFit: 'cover' }}
              />
              <div
                style={{
                  position: 'absolute',
                  top: '12px',
                  left: '12px',
                  backgroundColor: 'rgba(0,0,0,0.7)',
                  color: '#EF4444',
                  padding: '4px 8px',
                  borderRadius: '4px',
                  fontSize: '11px',
                  fontWeight: 700
                }}
              >
                ● LIVE STREAM · 1080P · 30 FPS
              </div>
              <div
                style={{
                  position: 'absolute',
                  bottom: '12px',
                  left: '12px',
                  backgroundColor: 'rgba(0,0,0,0.7)',
                  color: '#CBD5E1',
                  padding: '4px 8px',
                  borderRadius: '4px',
                  fontSize: '11px',
                  fontFamily: 'monospace'
                }}
              >
                {activeCameraModal.subtitle}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
