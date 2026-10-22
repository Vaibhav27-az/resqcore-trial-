import React, { useState, useEffect } from 'react';
import {
  Plus,
  Minus,
  Crosshair,
  Shield,
  AlertTriangle,
  Info,
  CheckCircle2,
  Key,
  Layers,
  MapPin,
  ExternalLink,
  X,
  Compass
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { GoogleMapView } from './GoogleMapView';

export const MapView = ({
  height = '100%',
  showDetailsOnClick = true,
  showHeatmap = false,
  showFullControls = true
}) => {
  const {
    incidents,
    selectedIncidentId,
    setSelectedIncidentId,
    inspectIncident,
    teams,
    isDemoMode,
    user
  } = useApp();

  // API Key management: check localStorage then env, fallback to provided key
  const DEFAULT_KEY = 'AIzaSyAMaBxMmCY1r2TmqoMZUm2-v8FfhE1n44g';

  const [googleApiKey, setGoogleApiKey] = useState(() => {
    return (
      localStorage.getItem('RESQCORE_GOOGLE_MAPS_API_KEY') ||
      import.meta.env.VITE_GOOGLE_MAPS_API_KEY ||
      DEFAULT_KEY
    );
  });

  const [useGoogleMaps, setUseGoogleMaps] = useState(true);

  const [showKeyModal, setShowKeyModal] = useState(false);
  const [inputKey, setInputKey] = useState(googleApiKey);

  // Simulated Map State
  const [mapMode, setMapMode] = useState('satellite'); // 'satellite' | 'map'
  const [zoomLevel, setZoomLevel] = useState(13);
  const [hoveredIncident, setHoveredIncident] = useState(null);

  const handleSaveKey = () => {
    const trimmed = inputKey.trim();
    if (trimmed) {
      localStorage.setItem('RESQCORE_GOOGLE_MAPS_API_KEY', trimmed);
      setGoogleApiKey(trimmed);
      setUseGoogleMaps(true);
    } else {
      localStorage.removeItem('RESQCORE_GOOGLE_MAPS_API_KEY');
      setGoogleApiKey('');
      setUseGoogleMaps(false);
    }
    setShowKeyModal(false);
  };

  // Strictly isolate Live Demo Mode: Demo mode keeps the original simulated Kerala map!
  // Google Maps API is ONLY loaded in the real Command Center (!isDemoMode).
  const shouldRenderGoogleMaps = !isDemoMode && useGoogleMaps && Boolean(googleApiKey);

  return (
    <div
      style={{
        position: 'relative',
        width: '100%',
        height: height,
        backgroundColor: '#050A14',
        borderRadius: '16px',
        overflow: 'hidden',
        border: '1px solid #16243E',
        userSelect: 'none'
      }}
    >
      {/* If real command center and Google Maps is enabled */}
      {shouldRenderGoogleMaps ? (
        <GoogleMapView
          apiKey={googleApiKey}
          incidents={incidents}
          teams={teams}
          district={user?.district || 'Dehradun, Uttarakhand'}
          selectedIncidentId={selectedIncidentId}
          onSelectIncident={(id) => {
            setSelectedIncidentId(id);
            if (showDetailsOnClick) inspectIncident(id);
          }}
          showHeatmap={showHeatmap}
          showFullControls={showFullControls}
          onOpenKeyModal={() => setShowKeyModal(true)}
        />
      ) : (
        /* Tactical Simulated Grid Map Fallback */
        <>
          {/* Satellite Imagery Background */}
          <div
            style={{
              position: 'absolute',
              inset: 0,
              backgroundImage: mapMode === 'satellite' ? `url('/assets/satellite.png')` : 'none',
              backgroundSize: `${100 + (zoomLevel - 13) * 20}%`,
              backgroundPosition: 'center',
              backgroundColor: mapMode === 'map' ? '#091322' : '#050A14',
              transition: 'background-size 0.25s ease-out',
              opacity: mapMode === 'satellite' ? 0.72 : 1
            }}
          />

          {/* Tactical Grid / Overlay */}
          <div
            style={{
              position: 'absolute',
              inset: 0,
              backgroundImage:
                mapMode === 'map'
                  ? 'radial-gradient(#1A2B49 1px, transparent 1px), linear-gradient(to right, rgba(22, 36, 62, 0.4) 1px, transparent 1px), linear-gradient(to bottom, rgba(22, 36, 62, 0.4) 1px, transparent 1px)'
                  : 'linear-gradient(to bottom, rgba(7, 12, 22, 0.3) 0%, rgba(7, 12, 22, 0.6) 100%)',
              backgroundSize: mapMode === 'map' ? '28px 28px, 112px 112px, 112px 112px' : 'auto',
              pointerEvents: 'none'
            }}
          />

          {/* Top Left: Map / Satellite Mode Toggle & Google Maps Prompt */}
          <div
            style={{
              position: 'absolute',
              top: '16px',
              left: '16px',
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              zIndex: 10
            }}
          >
            <div
              style={{
                display: 'flex',
                backgroundColor: '#0B1322',
                border: '1px solid #1E2E4B',
                borderRadius: '8px',
                padding: '3px'
              }}
            >
              <button
                onClick={() => setMapMode('map')}
                style={{
                  padding: '5px 12px',
                  fontSize: '12px',
                  fontWeight: 600,
                  borderRadius: '6px',
                  backgroundColor: mapMode === 'map' ? '#1E3A8A' : 'transparent',
                  color: mapMode === 'map' ? '#FFFFFF' : '#94A3B8'
                }}
              >
                Map
              </button>
              <button
                onClick={() => setMapMode('satellite')}
                style={{
                  padding: '5px 12px',
                  fontSize: '12px',
                  fontWeight: 600,
                  borderRadius: '6px',
                  backgroundColor: mapMode === 'satellite' ? '#1E3A8A' : 'transparent',
                  color: mapMode === 'satellite' ? '#FFFFFF' : '#94A3B8'
                }}
              >
                Satellite
              </button>
            </div>

            {!isDemoMode && (
              <button
                onClick={() => setShowKeyModal(true)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '8px',
                  backgroundColor: 'rgba(56, 189, 248, 0.1)',
                  border: '1px solid rgba(56, 189, 248, 0.3)',
                  color: '#38BDF8',
                  fontSize: '12px',
                  fontWeight: 600,
                  cursor: 'pointer'
                }}
              >
                <Compass size={14} /> Connect Google Maps
              </button>
            )}
          </div>

          {/* Heatmap Layer for Reports Screen */}
          {showHeatmap && (
            <div
              style={{
                position: 'absolute',
                inset: 0,
                pointerEvents: 'none',
                opacity: 0.75
              }}
            >
              <div
                style={{
                  position: 'absolute',
                  left: '32%',
                  top: '58%',
                  width: '140px',
                  height: '140px',
                  transform: 'translate(-50%, -50%)',
                  borderRadius: '50%',
                  background: 'radial-gradient(circle, rgba(239, 68, 68, 0.8) 0%, rgba(245, 158, 11, 0.4) 50%, transparent 75%)',
                  filter: 'blur(16px)'
                }}
              />
              <div
                style={{
                  position: 'absolute',
                  left: '42%',
                  top: '74%',
                  width: '120px',
                  height: '120px',
                  transform: 'translate(-50%, -50%)',
                  borderRadius: '50%',
                  background: 'radial-gradient(circle, rgba(239, 68, 68, 0.7) 0%, rgba(245, 158, 11, 0.35) 55%, transparent 75%)',
                  filter: 'blur(14px)'
                }}
              />
            </div>
          )}

          {/* Tactical Geographic Labels */}
          <div
            style={{
              position: 'absolute',
              left: '26%',
              top: '25%',
              fontSize: '11px',
              fontWeight: 700,
              color: 'rgba(255, 255, 255, 0.75)',
              letterSpacing: '1px',
              pointerEvents: 'none',
              textShadow: '0 2px 4px rgba(0,0,0,0.8)'
            }}
          >
            {isDemoMode ? 'VYPIN' : 'MUSSOORIE'}
          </div>
          <div
            style={{
              position: 'absolute',
              left: '24%',
              top: '54%',
              fontSize: '11px',
              fontWeight: 700,
              color: 'rgba(255, 255, 255, 0.75)',
              letterSpacing: '1px',
              pointerEvents: 'none',
              textShadow: '0 2px 4px rgba(0,0,0,0.8)'
            }}
          >
            {isDemoMode ? 'FORT KOCHI' : 'DEHRADUN'}
          </div>
          <div
            style={{
              position: 'absolute',
              left: '32%',
              top: '82%',
              fontSize: '11px',
              fontWeight: 700,
              color: 'rgba(255, 255, 255, 0.75)',
              letterSpacing: '1px',
              pointerEvents: 'none',
              textShadow: '0 2px 4px rgba(0,0,0,0.8)'
            }}
          >
            {isDemoMode ? 'MATTANCHERRY' : 'RISHIKESH'}
          </div>
          <div
            style={{
              position: 'absolute',
              left: '54%',
              top: '56%',
              fontSize: '11px',
              fontWeight: 700,
              color: 'rgba(255, 255, 255, 0.75)',
              letterSpacing: '1px',
              pointerEvents: 'none',
              textShadow: '0 2px 4px rgba(0,0,0,0.8)'
            }}
          >
            {isDemoMode ? 'ERNAKULAM' : 'HARIDWAR'}
          </div>

          {/* Tactical Incident Pins */}
          {!showHeatmap &&
            incidents.map((incident) => {
              if (!incident.coordinates) return null;
              const isSelected = selectedIncidentId === incident.id;
              const isHovered = hoveredIncident === incident.id;
              const isVerified = incident.status === 'Verified';

              const color = isVerified
                ? '#10B981'
                : incident.severity === 'High'
                ? '#EF4444'
                : incident.severity === 'Medium'
                ? '#F59E0B'
                : '#38BDF8';

              return (
                <div
                  key={incident.id}
                  onClick={() => {
                    setSelectedIncidentId(incident.id);
                    if (showDetailsOnClick) {
                      inspectIncident(incident.id);
                    }
                  }}
                  onMouseEnter={() => setHoveredIncident(incident.id)}
                  onMouseLeave={() => setHoveredIncident(null)}
                  style={{
                    position: 'absolute',
                    left: `${incident.coordinates.x}%`,
                    top: `${incident.coordinates.y}%`,
                    transform: 'translate(-50%, -50%)',
                    cursor: 'pointer',
                    zIndex: isSelected ? 30 : 20,
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center'
                  }}
                >
                  {incident.severity === 'High' && !isVerified && (
                    <div
                      style={{
                        position: 'absolute',
                        width: '38px',
                        height: '38px',
                        borderRadius: '50%',
                        backgroundColor: 'rgba(239, 68, 68, 0.25)',
                        animation: 'ping 2s cubic-bezier(0, 0, 0.2, 1) infinite',
                        pointerEvents: 'none'
                      }}
                    />
                  )}

                  <div
                    style={{
                      width: isSelected ? '34px' : '28px',
                      height: isSelected ? '34px' : '28px',
                      borderRadius: '50%',
                      backgroundColor: '#091122',
                      border: `2px solid ${color}`,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      boxShadow: isSelected
                        ? `0 0 16px ${color}`
                        : `0 2px 8px rgba(0,0,0,0.6)`,
                      transition: 'all 0.15s ease'
                    }}
                  >
                    {isVerified ? (
                      <CheckCircle2 size={isSelected ? 18 : 15} color="#10B981" />
                    ) : incident.severity === 'High' ? (
                      <AlertTriangle size={isSelected ? 17 : 14} color="#EF4444" />
                    ) : incident.severity === 'Medium' ? (
                      <AlertTriangle size={isSelected ? 16 : 13} color="#F59E0B" />
                    ) : (
                      <Info size={isSelected ? 16 : 13} color="#38BDF8" />
                    )}
                  </div>

                  {(isSelected || isHovered) && (
                    <div
                      style={{
                        position: 'absolute',
                        bottom: 'calc(100% + 8px)',
                        backgroundColor: '#0E172A',
                        border: '1px solid #1E2E4B',
                        borderRadius: '8px',
                        padding: '8px 12px',
                        boxShadow: '0 8px 24px rgba(0,0,0,0.8)',
                        whiteSpace: 'nowrap',
                        pointerEvents: 'none',
                        zIndex: 40
                      }}
                    >
                      <div style={{ fontSize: '12px', fontWeight: 600, color: '#FFFFFF' }}>
                        {incident.id} · {incident.title}
                      </div>
                      <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '2px' }}>
                        {incident.shortLocation} · {incident.affected} affected
                      </div>
                    </div>
                  )}
                </div>
              );
            })}

          {/* Deployed Teams */}
          {!showHeatmap && (
            <>
              <div
                title="Alpha 01 · Coastal rescue (Vypin)"
                style={{
                  position: 'absolute',
                  left: '34%',
                  top: '40%',
                  transform: 'translate(-50%, -50%)',
                  width: '26px',
                  height: '26px',
                  borderRadius: '6px',
                  backgroundColor: '#091122',
                  border: '2px solid #10B981',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: '0 2px 8px rgba(0,0,0,0.6)',
                  zIndex: 18
                }}
              >
                <Shield size={14} color="#10B981" />
              </div>
              <div
                title="Echo 05 · Thevara"
                style={{
                  position: 'absolute',
                  left: '55%',
                  top: '74%',
                  transform: 'translate(-50%, -50%)',
                  width: '26px',
                  height: '26px',
                  borderRadius: '6px',
                  backgroundColor: '#091122',
                  border: '2px solid #10B981',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: '0 2px 8px rgba(0,0,0,0.6)',
                  zIndex: 18
                }}
              >
                <Shield size={14} color="#10B981" />
              </div>
            </>
          )}

          {/* Zoom Controls */}
          {showFullControls && (
            <div
              style={{
                position: 'absolute',
                right: '16px',
                bottom: '44px',
                display: 'flex',
                flexDirection: 'column',
                gap: '6px',
                zIndex: 10
              }}
            >
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  backgroundColor: '#0B1322',
                  border: '1px solid #1E2E4B',
                  borderRadius: '8px',
                  overflow: 'hidden'
                }}
              >
                <button
                  onClick={() => setZoomLevel(prev => Math.min(prev + 1, 16))}
                  style={{
                    width: '32px',
                    height: '32px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    backgroundColor: 'transparent',
                    color: '#CBD5E1',
                    borderBottom: '1px solid #1E2E4B'
                  }}
                >
                  <Plus size={16} />
                </button>
                <button
                  onClick={() => setZoomLevel(prev => Math.max(prev - 1, 11))}
                  style={{
                    width: '32px',
                    height: '32px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    backgroundColor: 'transparent',
                    color: '#CBD5E1'
                  }}
                >
                  <Minus size={16} />
                </button>
              </div>

              <button
                onClick={() => setZoomLevel(13)}
                title="Recenter Map"
                style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '8px',
                  backgroundColor: '#0B1322',
                  border: '1px solid #1E2E4B',
                  color: '#3B82F6',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}
              >
                <Crosshair size={16} />
              </button>
            </div>
          )}

          {/* Severity Legend */}
          <div
            style={{
              position: 'absolute',
              bottom: '14px',
              left: '16px',
              display: 'flex',
              alignItems: 'center',
              gap: '14px',
              backgroundColor: 'rgba(7, 12, 22, 0.85)',
              backdropFilter: 'blur(8px)',
              border: '1px solid #16243E',
              borderRadius: '9999px',
              padding: '6px 14px',
              zIndex: 10
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11px', color: '#CBD5E1' }}>
              <span style={{ width: '7px', height: '7px', borderRadius: '50%', backgroundColor: '#EF4444' }} />
              High
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11px', color: '#CBD5E1' }}>
              <span style={{ width: '7px', height: '7px', borderRadius: '50%', backgroundColor: '#F59E0B' }} />
              Medium
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11px', color: '#CBD5E1' }}>
              <span style={{ width: '7px', height: '7px', borderRadius: '50%', backgroundColor: '#38BDF8' }} />
              Info
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11px', color: '#CBD5E1' }}>
              <span style={{ width: '7px', height: '7px', borderRadius: '50%', backgroundColor: '#10B981' }} />
              Deployed
            </div>
          </div>
        </>
      )}

      {/* Google Maps API Key Setup Modal */}
      {showKeyModal && (
        <div
          style={{
            position: 'absolute',
            inset: 0,
            backgroundColor: 'rgba(3, 7, 18, 0.85)',
            backdropFilter: 'blur(8px)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 100,
            padding: '20px'
          }}
        >
          <div
            style={{
              backgroundColor: '#0B1322',
              border: '1px solid #1E2E4B',
              borderRadius: '16px',
              padding: '24px',
              maxWidth: '480px',
              width: '100%',
              boxShadow: '0 20px 40px rgba(0,0,0,0.8)'
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <Key size={18} color="#38BDF8" />
                <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
                  Google Maps API Setup
                </h3>
              </div>
              <button
                onClick={() => setShowKeyModal(false)}
                style={{
                  background: 'none',
                  border: 'none',
                  color: '#64748B',
                  cursor: 'pointer'
                }}
              >
                <X size={18} />
              </button>
            </div>

            <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '12px', lineHeight: '1.5' }}>
              Enable live satellite view, real-time traffic overlays, and real GPS incident tracking by connecting a Google Cloud Maps API key.
            </p>

            <div style={{ marginTop: '16px' }}>
              <label style={{ fontSize: '12px', fontWeight: 600, color: '#CBD5E1', display: 'block', marginBottom: '6px' }}>
                Google Maps JavaScript API Key
              </label>
              <input
                type="text"
                placeholder="AIzaSy..."
                value={inputKey}
                onChange={(e) => setInputKey(e.target.value)}
                style={{
                  width: '100%',
                  padding: '10px 14px',
                  backgroundColor: '#050A14',
                  border: '1px solid #1E2E4B',
                  borderRadius: '8px',
                  color: '#FFFFFF',
                  fontSize: '13px',
                  outline: 'none'
                }}
              />
            </div>

            <div
              style={{
                marginTop: '12px',
                padding: '10px 14px',
                borderRadius: '8px',
                backgroundColor: 'rgba(56, 189, 248, 0.05)',
                border: '1px solid rgba(56, 189, 248, 0.15)',
                fontSize: '12px',
                color: '#94A3B8',
                display: 'flex',
                flexDirection: 'column',
                gap: '4px'
              }}
            >
              <span>Required Google Cloud APIs:</span>
              <span style={{ color: '#38BDF8', fontWeight: 600 }}>
                • Maps JavaScript API &nbsp;• Places API
              </span>
              <a
                href="https://console.cloud.google.com/google/maps-apis/overview"
                target="_blank"
                rel="noreferrer"
                style={{
                  color: '#60A5FA',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '4px',
                  marginTop: '4px',
                  textDecoration: 'underline'
                }}
              >
                Get Google Maps API Key <ExternalLink size={12} />
              </a>
            </div>

            <div style={{ display: 'flex', gap: '10px', marginTop: '20px', justifyContent: 'flex-end' }}>
              <button
                onClick={() => {
                  localStorage.removeItem('RESQCORE_GOOGLE_MAPS_API_KEY');
                  setGoogleApiKey('');
                  setUseGoogleMaps(false);
                  setShowKeyModal(false);
                }}
                style={{
                  padding: '8px 16px',
                  borderRadius: '8px',
                  backgroundColor: 'transparent',
                  border: '1px solid #1E2E4B',
                  color: '#94A3B8',
                  fontSize: '13px',
                  cursor: 'pointer'
                }}
              >
                Use Fallback Map
              </button>
              <button
                onClick={handleSaveKey}
                style={{
                  padding: '8px 18px',
                  borderRadius: '8px',
                  backgroundColor: '#1E3A8A',
                  border: 'none',
                  color: '#FFFFFF',
                  fontSize: '13px',
                  fontWeight: 600,
                  cursor: 'pointer'
                }}
              >
                Save & Load Google Maps
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
