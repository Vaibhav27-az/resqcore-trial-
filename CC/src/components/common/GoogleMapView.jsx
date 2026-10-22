import React, { useEffect, useRef, useState } from 'react';
import { setOptions, importLibrary } from '@googlemaps/js-api-loader';
import {
  TACTICAL_DARK_MAP_STYLE,
  DEFAULT_COMMAND_CENTER_LOCATION,
  getDistrictCenter,
  parseCoord,
  createTacticalMarkerIcon,
  createTeamMarkerIcon
} from '../../utils/googleMapsConfig';
import {
  Plus,
  Minus,
  Crosshair,
  Car,
  Layers,
  Activity,
  AlertTriangle,
  CheckCircle2,
  Key,
  X,
  ExternalLink
} from 'lucide-react';

export const GoogleMapView = ({
  apiKey,
  incidents = [],
  teams = [],
  district = 'Dehradun, Uttarakhand',
  selectedIncidentId,
  onSelectIncident,
  showHeatmap = false,
  showFullControls = true,
  onOpenKeyModal
}) => {
  const mapContainerRef = useRef(null);
  const mapInstanceRef = useRef(null);
  const trafficLayerRef = useRef(null);
  const markersRef = useRef([]);
  const infoWindowRef = useRef(null);

  const [mapLoaded, setMapLoaded] = useState(false);
  const [loadError, setLoadError] = useState(null);
  const [mapType, setMapType] = useState('roadmap'); // 'roadmap' | 'satellite' | 'hybrid'
  const [showTraffic, setShowTraffic] = useState(false);
  const [showLiveQuakes, setShowLiveQuakes] = useState(false);
  const [liveQuakesCount, setLiveQuakesCount] = useState(0);

  // Initialize Google Maps
  useEffect(() => {
    if (!apiKey || !mapContainerRef.current) return;

    let isMounted = true;
    try {
      setOptions({
        key: apiKey,
        v: 'weekly'
      });

      Promise.all([
        importLibrary('maps'),
        importLibrary('marker')
      ])
        .then(([mapsLib]) => {
          if (!isMounted || !mapContainerRef.current) return;

          const { Map, InfoWindow, TrafficLayer } = mapsLib;

          const centerCoords = getDistrictCenter(district);
          const map = new Map(mapContainerRef.current, {
            center: {
              lat: centerCoords.lat,
              lng: centerCoords.lng
            },
            zoom: centerCoords.zoom,
            styles: mapType === 'roadmap' ? TACTICAL_DARK_MAP_STYLE : undefined,
            mapTypeId: mapType,
            disableDefaultUI: true,
            zoomControl: false,
            gestureHandling: 'greedy',
            backgroundColor: '#091122'
          });

          mapInstanceRef.current = map;
          trafficLayerRef.current = new TrafficLayer();
          infoWindowRef.current = new InfoWindow();

          setMapLoaded(true);
          setLoadError(null);
        })
        .catch((err) => {
          console.error('Google Maps Load Error:', err);
          if (isMounted) {
            setLoadError(err.message || 'Failed to load Google Maps. Check your API key.');
          }
        });
    } catch (err) {
      console.error('setOptions Error:', err);
      if (isMounted) {
        setLoadError(err.message || 'Failed to load Google Maps.');
      }
    }

    return () => {
      isMounted = false;
      markersRef.current.forEach(m => m.setMap(null));
      markersRef.current = [];
    };
  }, [apiKey]);

  // Handle Map Type Change
  useEffect(() => {
    if (!mapInstanceRef.current || !window.google) return;
    mapInstanceRef.current.setMapTypeId(mapType);
    if (mapType === 'roadmap') {
      mapInstanceRef.current.setOptions({ styles: TACTICAL_DARK_MAP_STYLE });
    } else {
      mapInstanceRef.current.setOptions({ styles: [] });
    }
  }, [mapType]);

  // Handle Traffic Layer
  useEffect(() => {
    if (!mapInstanceRef.current || !trafficLayerRef.current) return;
    if (showTraffic) {
      trafficLayerRef.current.setMap(mapInstanceRef.current);
    } else {
      trafficLayerRef.current.setMap(null);
    }
  }, [showTraffic]);

  // Update Markers when incidents or selectedIncidentId change
  useEffect(() => {
    if (!mapInstanceRef.current || !window.google || !mapLoaded) return;

    // Clear previous markers
    markersRef.current.forEach(m => m.setMap(null));
    markersRef.current = [];

    // Add Incident Markers
    incidents.forEach((incident) => {
      if (!incident.coordinates) return;
      const lat = parseCoord(incident.coordinates.lat);
      const lng = parseCoord(incident.coordinates.lng);
      if (!lat || !lng) return;

      const isSelected = selectedIncidentId === incident.id;
      const isVerified = incident.status === 'Verified';

      const marker = new window.google.maps.Marker({
        position: { lat, lng },
        map: mapInstanceRef.current,
        title: `${incident.id}: ${incident.title}`,
        icon: {
          url: createTacticalMarkerIcon(incident.severity, isVerified, isSelected),
          scaledSize: new window.google.maps.Size(isSelected ? 36 : 28, isSelected ? 36 : 28),
          anchor: new window.google.maps.Point(isSelected ? 18 : 14, isSelected ? 18 : 14)
        },
        zIndex: isSelected ? 99 : 10
      });

      marker.addListener('click', () => {
        if (onSelectIncident) onSelectIncident(incident.id);

        const content = `
          <div style="background-color: #0F172A; color: #FFFFFF; padding: 10px 14px; border-radius: 8px; font-family: sans-serif; min-width: 220px; border: 1px solid #1E293B;">
            <div style="display: flex; align-items: center; justify-content: space-between; gap: 8px;">
              <span style="font-weight: 700; font-size: 13px; color: ${isVerified ? '#10B981' : incident.severity === 'High' ? '#EF4444' : '#F59E0B'}">${incident.id}</span>
              <span style="font-size: 11px; background: rgba(255,255,255,0.1); padding: 2px 6px; border-radius: 4px; color: #94A3B8;">${incident.severity}</span>
            </div>
            <div style="font-size: 13px; font-weight: 600; margin-top: 4px; color: #F8FAFC;">${incident.title}</div>
            <div style="font-size: 11px; color: #94A3B8; margin-top: 2px;">${incident.location || incident.shortLocation}</div>
            <div style="font-size: 11px; color: #38BDF8; margin-top: 4px;">👥 ${incident.affected || 0} affected · Status: ${incident.status}</div>
          </div>
        `;

        infoWindowRef.current.setContent(content);
        infoWindowRef.current.open(mapInstanceRef.current, marker);
      });

      markersRef.current.push(marker);
    });

    // Add Deployed Rescue Teams
    teams.forEach((team) => {
      if (team.status !== 'Deployed') return;
      // approximate deployment coordinates
      let pos = { lat: 9.9920, lng: 76.2300 }; // default Vypin
      if (team.id === 'bravo-02') pos = { lat: 9.9658, lng: 76.2421 }; // Fort Kochi
      if (team.id === 'echo-05') pos = { lat: 9.9350, lng: 76.2980 }; // Thevara

      const teamMarker = new window.google.maps.Marker({
        position: pos,
        map: mapInstanceRef.current,
        title: `${team.name} (${team.specialization || 'Response'})`,
        icon: {
          url: createTeamMarkerIcon(),
          scaledSize: new window.google.maps.Size(26, 26),
          anchor: new window.google.maps.Point(13, 13)
        },
        zIndex: 5
      });

      teamMarker.addListener('click', () => {
        const content = `
          <div style="background-color: #0F172A; color: #FFFFFF; padding: 10px 14px; border-radius: 8px; font-family: sans-serif; min-width: 200px; border: 1px solid #10B981;">
            <div style="font-weight: 700; font-size: 13px; color: #10B981;">🛡️ ${team.name}</div>
            <div style="font-size: 11px; color: #94A3B8; margin-top: 2px;">${team.specialization}</div>
            <div style="font-size: 11px; color: #E2E8F0; margin-top: 4px;">Status: ${team.status} · ${team.responders || 6} responders</div>
          </div>
        `;
        infoWindowRef.current.setContent(content);
        infoWindowRef.current.open(mapInstanceRef.current, teamMarker);
      });

      markersRef.current.push(teamMarker);
    });

    // If an incident is actively selected, center smoothly
    const selected = incidents.find(i => i.id === selectedIncidentId);
    if (selected && selected.coordinates) {
      const lat = parseCoord(selected.coordinates.lat);
      const lng = parseCoord(selected.coordinates.lng);
      if (lat && lng) {
        mapInstanceRef.current.panTo({ lat, lng });
      }
    }
  }, [incidents, teams, selectedIncidentId, mapLoaded]);

  // Real-Time USGS Earthquakes live layer
  useEffect(() => {
    if (!mapInstanceRef.current || !window.google || !mapLoaded || !showLiveQuakes) return;

    let quakeMarkers = [];
    fetch('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson')
      .then(res => res.json())
      .then(data => {
        if (!data || !data.features) return;
        setLiveQuakesCount(data.features.length);

        data.features.forEach((feature) => {
          const [lng, lat, depth] = feature.geometry.coordinates;
          const mag = feature.properties.mag || 1;
          const place = feature.properties.place;

          const circle = new window.google.maps.Circle({
            strokeColor: '#EF4444',
            strokeOpacity: 0.8,
            strokeWeight: 1,
            fillColor: '#EF4444',
            fillOpacity: 0.35,
            map: mapInstanceRef.current,
            center: { lat, lng },
            radius: Math.max(mag * 25000, 10000)
          });

          circle.addListener('click', () => {
            const content = `
              <div style="background-color: #0F172A; color: #FFFFFF; padding: 10px 14px; border-radius: 8px; font-family: sans-serif; min-width: 200px; border: 1px solid #EF4444;">
                <div style="font-weight: 700; font-size: 13px; color: #EF4444;">⚠️ USGS Earthquake: M${mag.toFixed(1)}</div>
                <div style="font-size: 11px; color: #CBD5E1; margin-top: 2px;">${place}</div>
                <div style="font-size: 11px; color: #94A3B8; margin-top: 4px;">Depth: ${depth} km · Live USGS Feed</div>
              </div>
            `;
            infoWindowRef.current.setContent(content);
            infoWindowRef.current.setPosition({ lat, lng });
            infoWindowRef.current.open(mapInstanceRef.current);
          });

          quakeMarkers.push(circle);
        });
      })
      .catch(err => console.warn('USGS feed fetch error:', err));

    return () => {
      quakeMarkers.forEach(c => c.setMap(null));
      quakeMarkers = [];
    };
  }, [showLiveQuakes, mapLoaded]);

  // Pan to selected district when changed
  useEffect(() => {
    if (!mapInstanceRef.current || !mapLoaded) return;
    const centerCoords = getDistrictCenter(district);
    mapInstanceRef.current.panTo({
      lat: centerCoords.lat,
      lng: centerCoords.lng
    });
    mapInstanceRef.current.setZoom(centerCoords.zoom);
  }, [district, mapLoaded]);

  // Recenter Map
  const handleRecenter = () => {
    if (!mapInstanceRef.current) return;
    const centerCoords = getDistrictCenter(district);
    mapInstanceRef.current.setCenter({
      lat: centerCoords.lat,
      lng: centerCoords.lng
    });
    mapInstanceRef.current.setZoom(centerCoords.zoom);
  };

  const handleZoom = (delta) => {
    if (!mapInstanceRef.current) return;
    const current = mapInstanceRef.current.getZoom() || 12;
    mapInstanceRef.current.setZoom(current + delta);
  };

  if (loadError) {
    return (
      <div
        style={{
          width: '100%',
          height: '100%',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          backgroundColor: '#050A14',
          color: '#EF4444',
          padding: '24px',
          textAlign: 'center'
        }}
      >
        <AlertTriangle size={36} color="#EF4444" style={{ marginBottom: '12px' }} />
        <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>Google Maps Load Error</h3>
        <p style={{ fontSize: '13px', color: '#94A3B8', maxWidth: '420px', marginTop: '6px' }}>
          {loadError}
        </p>
        <button
          onClick={onOpenKeyModal}
          style={{
            marginTop: '16px',
            padding: '8px 16px',
            backgroundColor: '#1E3A8A',
            color: '#FFFFFF',
            borderRadius: '8px',
            fontSize: '12px',
            fontWeight: 600,
            display: 'flex',
            alignItems: 'center',
            gap: '8px'
          }}
        >
          <Key size={14} /> Update Google Maps API Key
        </button>
      </div>
    );
  }

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%' }}>
      {/* Google Maps Render Canvas */}
      <div ref={mapContainerRef} style={{ width: '100%', height: '100%', backgroundColor: '#050A14' }} />

      {/* Top Left: Map Mode & Traffic Toggle */}
      {showFullControls && (
        <div
          style={{
            position: 'absolute',
            top: '16px',
            left: '16px',
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            zIndex: 10,
            flexWrap: 'wrap'
          }}
        >
          {/* Layer Selector */}
          <div
            style={{
              display: 'flex',
              backgroundColor: '#0B1322',
              border: '1px solid #1E2E4B',
              borderRadius: '8px',
              padding: '3px',
              boxShadow: '0 4px 12px rgba(0,0,0,0.5)'
            }}
          >
            <button
              onClick={() => setMapType('roadmap')}
              style={{
                padding: '5px 12px',
                fontSize: '12px',
                fontWeight: 600,
                borderRadius: '6px',
                backgroundColor: mapType === 'roadmap' ? '#1E3A8A' : 'transparent',
                color: mapType === 'roadmap' ? '#FFFFFF' : '#94A3B8'
              }}
            >
              Dark Map
            </button>
            <button
              onClick={() => setMapType('satellite')}
              style={{
                padding: '5px 12px',
                fontSize: '12px',
                fontWeight: 600,
                borderRadius: '6px',
                backgroundColor: mapType === 'satellite' ? '#1E3A8A' : 'transparent',
                color: mapType === 'satellite' ? '#FFFFFF' : '#94A3B8'
              }}
            >
              Satellite
            </button>
            <button
              onClick={() => setMapType('hybrid')}
              style={{
                padding: '5px 12px',
                fontSize: '12px',
                fontWeight: 600,
                borderRadius: '6px',
                backgroundColor: mapType === 'hybrid' ? '#1E3A8A' : 'transparent',
                color: mapType === 'hybrid' ? '#FFFFFF' : '#94A3B8'
              }}
            >
              Hybrid
            </button>
          </div>

          {/* Real-Time Traffic Toggle */}
          <button
            onClick={() => setShowTraffic(!showTraffic)}
            title="Toggle Live Traffic Layer"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '6px 12px',
              borderRadius: '8px',
              backgroundColor: showTraffic ? 'rgba(239, 68, 68, 0.2)' : '#0B1322',
              border: showTraffic ? '1px solid #EF4444' : '1px solid #1E2E4B',
              color: showTraffic ? '#EF4444' : '#94A3B8',
              fontSize: '12px',
              fontWeight: 600,
              boxShadow: '0 4px 12px rgba(0,0,0,0.5)',
              cursor: 'pointer'
            }}
          >
            <Car size={14} />
            Live Traffic
          </button>

          {/* Real-Time USGS Earthquakes Toggle */}
          <button
            onClick={() => setShowLiveQuakes(!showLiveQuakes)}
            title="Toggle Real-time USGS Earthquakes feed"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '6px 12px',
              borderRadius: '8px',
              backgroundColor: showLiveQuakes ? 'rgba(245, 158, 11, 0.2)' : '#0B1322',
              border: showLiveQuakes ? '1px solid #F59E0B' : '1px solid #1E2E4B',
              color: showLiveQuakes ? '#F59E0B' : '#94A3B8',
              fontSize: '12px',
              fontWeight: 600,
              boxShadow: '0 4px 12px rgba(0,0,0,0.5)',
              cursor: 'pointer'
            }}
          >
            <Activity size={14} />
            {showLiveQuakes ? `USGS Quakes (${liveQuakesCount})` : 'Live Quakes'}
          </button>
        </div>
      )}

      {/* Top Right: Google Maps API Key Config Icon */}
      {showFullControls && (
        <div style={{ position: 'absolute', top: '16px', right: '16px', zIndex: 10 }}>
          <button
            onClick={onOpenKeyModal}
            title="Configure Google Maps API Key"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '6px 10px',
              borderRadius: '8px',
              backgroundColor: '#0B1322',
              border: '1px solid #1E2E4B',
              color: '#38BDF8',
              fontSize: '11.5px',
              fontWeight: 600,
              boxShadow: '0 4px 12px rgba(0,0,0,0.5)'
            }}
          >
            <Key size={13} />
            Google API Key
          </button>
        </div>
      )}

      {/* Right Zoom & Recenter Controls */}
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
              onClick={() => handleZoom(1)}
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
              onClick={() => handleZoom(-1)}
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
            onClick={handleRecenter}
            title="Recenter to Command Center"
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

      {/* Bottom Severity Legend */}
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
          Deployed Team
        </div>
      </div>
    </div>
  );
};
