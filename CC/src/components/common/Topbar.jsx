import React, { useState, useEffect } from 'react';
import {
  MapPin,
  ChevronDown,
  CloudRain,
  Sun,
  Cloud,
  CloudLightning,
  CloudDrizzle,
  CloudFog,
  CloudSnow,
  User,
  LogOut,
  RefreshCw,
  Check,
  ShieldCheck,
  Radio
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { fetchDistrictWeather } from '../../utils/weatherService';

export const Topbar = ({ title, breadcrumb }) => {
  const { user, setUser, setIsAuthenticated, isLoadingSync, setIsLoadingSync, isDemoMode, setIsDemoMode } = useApp();
  const [isDistrictMenuOpen, setIsDistrictMenuOpen] = useState(false);
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);

  const uttarakhandDistricts = [
    'Dehradun, Uttarakhand',
    'Chamoli, Uttarakhand',
    'Rudraprayag, Uttarakhand',
    'Uttarkashi, Uttarakhand',
    'Nainital, Uttarakhand',
    'Haridwar, Uttarakhand',
    'Pithoragarh, Uttarakhand',
    'Tehri Garhwal, Uttarakhand'
  ];

  const keralaDistricts = [
    'Ernakulam, Kerala',
    'Wayanad, Kerala',
    'Idukki, Kerala',
    'Alappuzha, Kerala',
    'Kozhikode, Kerala',
    'Thrissur, Kerala'
  ];

  const districts = isDemoMode ? keralaDistricts : uttarakhandDistricts;

  const roles = [
    'Command Operator',
    'Field Responder',
    'District Administrator'
  ];

  const [liveWeather, setLiveWeather] = useState(null);

  useEffect(() => {
    if (isDemoMode) {
      setLiveWeather(null);
      return;
    }
    let isMounted = true;
    fetchDistrictWeather(user?.district || 'Dehradun, Uttarakhand')
      .then(res => {
        if (isMounted) setLiveWeather(res.current);
      })
      .catch(err => console.warn('Topbar weather fetch error:', err));

    return () => { isMounted = false; };
  }, [user?.district, isDemoMode]);

  return (
    <header
      style={{
        height: '68px',
        padding: '0 28px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: '#070C16',
        borderBottom: '1px solid #162238',
        position: 'sticky',
        top: 0,
        zIndex: 40
      }}
    >
      {/* Title & Breadcrumbs */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
        <h2
          style={{
            fontSize: '18px',
            fontWeight: 700,
            color: '#FFFFFF',
            letterSpacing: '-0.2px'
          }}
        >
          {title}
        </h2>

        {breadcrumb && (
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span style={{ color: '#334155' }}>|</span>
            <span
              style={{
                fontSize: '11px',
                fontWeight: 600,
                color: '#64748B',
                letterSpacing: '0.8px',
                textTransform: 'uppercase'
              }}
            >
              {breadcrumb}
            </span>
          </div>
        )}
      </div>

      {/* Right widgets */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        {isDemoMode && (
          <button
            onClick={() => setIsDemoMode(!isDemoMode)}
            title="Toggle Real-Time Demo Mode"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '6px 12px',
              borderRadius: '9999px',
              backgroundColor: 'rgba(239, 68, 68, 0.1)',
              border: '1px solid rgba(239, 68, 68, 0.4)',
              color: '#EF4444',
              fontSize: '12px',
              fontWeight: 500,
              cursor: 'pointer',
              transition: 'all 0.2s'
            }}
          >
            <div style={{
              width: '8px',
              height: '8px',
              borderRadius: '50%',
              backgroundColor: '#EF4444',
              animation: 'pulseGlow 1s infinite'
            }} />
            Demo Mode: ON
          </button>
        )}


        {/* Live sync simulator button */}
        <button
          onClick={() => {
            setIsLoadingSync(true);
            setTimeout(() => setIsLoadingSync(false), 1400);
          }}
          title="Click to simulate live satellite intelligence sync"
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            padding: '6px 12px',
            borderRadius: '9999px',
            backgroundColor: isLoadingSync ? 'rgba(59, 130, 246, 0.15)' : 'rgba(16, 185, 129, 0.1)',
            border: `1px solid ${isLoadingSync ? 'rgba(59, 130, 246, 0.3)' : 'rgba(16, 185, 129, 0.25)'}`,
            color: isLoadingSync ? '#60A5FA' : '#10B981',
            fontSize: '12px',
            fontWeight: 500
          }}
        >
          <span
            style={{
              width: '6px',
              height: '6px',
              borderRadius: '50%',
              backgroundColor: isLoadingSync ? '#60A5FA' : '#10B981',
              animation: 'pulseGlow 1.5s infinite ease-in-out'
            }}
          />
          {isLoadingSync ? 'Syncing live data' : 'Live'}
        </button>

        {/* Location selector */}
        <div style={{ position: 'relative' }}>
          <button
            onClick={() => setIsDistrictMenuOpen(!isDistrictMenuOpen)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '7px 12px',
              borderRadius: '8px',
              backgroundColor: '#0D1527',
              border: '1px solid #1A263D',
              color: '#F1F5F9',
              fontSize: '13px',
              fontWeight: 500
            }}
          >
            <MapPin size={15} color="#3B82F6" />
            <span>{user.district}</span>
            <ChevronDown size={14} color="#64748B" />
          </button>

          {isDistrictMenuOpen && (
            <div
              className="animate-slide-up"
              style={{
                position: 'absolute',
                top: 'calc(100% + 8px)',
                right: 0,
                width: '190px',
                backgroundColor: '#0E172A',
                border: '1px solid #1E293B',
                borderRadius: '10px',
                boxShadow: '0 12px 30px rgba(0, 0, 0, 0.7)',
                padding: '6px',
                zIndex: 100
              }}
            >
              {districts.map((d) => (
                <button
                  key={d}
                  onClick={() => {
                    setUser({ ...user, district: d });
                    setIsDistrictMenuOpen(false);
                  }}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    width: '100%',
                    padding: '8px 10px',
                    borderRadius: '6px',
                    backgroundColor: user.district === d ? '#1E293B' : 'transparent',
                    color: user.district === d ? '#FFFFFF' : '#94A3B8',
                    fontSize: '12.5px',
                    textAlign: 'left'
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#1E293B')}
                  onMouseLeave={(e) => {
                    if (user.district !== d) e.currentTarget.style.backgroundColor = 'transparent';
                  }}
                >
                  <span>{d}</span>
                  {user.district === d && <Check size={14} color="#3B82F6" />}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Weather widget */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            padding: '7px 12px',
            borderRadius: '8px',
            backgroundColor: '#0D1527',
            border: '1px solid #1A263D',
            color: '#CBD5E1',
            fontSize: '13px',
            fontWeight: 500
          }}
          title={isDemoMode ? 'Simulated Weather' : `Live Open-Meteo Weather for ${user.district}`}
        >
          <CloudRain size={16} color="#38BDF8" />
          <span>
            {isDemoMode || !liveWeather
              ? '27°C · Heavy rain'
              : `${liveWeather.temperature}°C · ${liveWeather.conditionLabel}`}
          </span>
        </div>

        {/* User profile dropdown */}
        <div style={{ position: 'relative' }}>
          <button
            onClick={() => setIsUserMenuOpen(!isUserMenuOpen)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
              padding: '4px 6px',
              borderRadius: '8px',
              backgroundColor: 'transparent',
              textAlign: 'left'
            }}
          >
            <div
              style={{
                width: '36px',
                height: '36px',
                borderRadius: '50%',
                backgroundColor: '#1E3A8A',
                border: '1px solid #2563EB',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#FFFFFF',
                fontWeight: 600,
                fontSize: '13px'
              }}
            >
              AK
            </div>
            <div style={{ display: 'flex', flexDirection: 'column' }}>
              <span style={{ fontSize: '13px', fontWeight: 600, color: '#FFFFFF' }}>
                {user.name}
              </span>
              <span style={{ fontSize: '11px', color: '#64748B' }}>
                {user.role}
              </span>
            </div>
          </button>

          {isUserMenuOpen && (
            <div
              className="animate-slide-up"
              style={{
                position: 'absolute',
                top: 'calc(100% + 8px)',
                right: 0,
                width: '230px',
                backgroundColor: '#0E172A',
                border: '1px solid #1E293B',
                borderRadius: '12px',
                boxShadow: '0 12px 30px rgba(0, 0, 0, 0.7)',
                padding: '8px',
                zIndex: 100
              }}
            >
              <div style={{ padding: '8px 10px', borderBottom: '1px solid #1E293B' }}>
                <div style={{ fontSize: '13px', fontWeight: 600, color: '#FFFFFF' }}>
                  {user.name}
                </div>
                <div style={{ fontSize: '11px', color: '#64748B' }}>
                  {user.email}
                </div>
              </div>

              <div style={{ padding: '6px 0' }}>
                <div
                  style={{
                    padding: '6px 10px',
                    fontSize: '10px',
                    fontWeight: 700,
                    color: '#475569',
                    textTransform: 'uppercase'
                  }}
                >
                  Switch Operational Role
                </div>
                {roles.map((r) => (
                  <button
                    key={r}
                    onClick={() => {
                      setUser({ ...user, role: r });
                      setIsUserMenuOpen(false);
                    }}
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      width: '100%',
                      padding: '8px 10px',
                      borderRadius: '6px',
                      backgroundColor: user.role === r ? '#1E293B' : 'transparent',
                      color: user.role === r ? '#FFFFFF' : '#94A3B8',
                      fontSize: '12.5px',
                      textAlign: 'left'
                    }}
                    onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#1E293B')}
                    onMouseLeave={(e) => {
                      if (user.role !== r) e.currentTarget.style.backgroundColor = 'transparent';
                    }}
                  >
                    <span>{r}</span>
                    {user.role === r && <Check size={14} color="#3B82F6" />}
                  </button>
                ))}
              </div>

              <div style={{ borderTop: '1px solid #1E293B', paddingTop: '6px' }}>
                <button
                  onClick={() => setIsAuthenticated(false)}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '8px',
                    width: '100%',
                    padding: '8px 10px',
                    borderRadius: '6px',
                    color: '#EF4444',
                    fontSize: '12.5px',
                    backgroundColor: 'transparent'
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = 'rgba(239, 68, 68, 0.1)')}
                  onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = 'transparent')}
                >
                  <LogOut size={14} />
                  <span>Sign out</span>
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};
