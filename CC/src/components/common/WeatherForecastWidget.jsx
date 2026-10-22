import React, { useEffect, useState } from 'react';
import {
  CloudRain,
  Wind,
  Droplets,
  Thermometer,
  RefreshCw,
  AlertTriangle,
  Clock,
  Sun,
  Cloud,
  CloudLightning,
  CloudDrizzle,
  CloudFog,
  CloudSnow,
  Navigation
} from 'lucide-react';
import { fetchDistrictWeather } from '../../utils/weatherService';

const ICON_MAP = {
  Sun: Sun,
  Cloud: Cloud,
  CloudSun: Cloud,
  CloudRain: CloudRain,
  CloudLightning: CloudLightning,
  CloudDrizzle: CloudDrizzle,
  CloudFog: CloudFog,
  CloudSnow: CloudSnow
};

export const WeatherForecastWidget = ({ district = 'Dehradun, Uttarakhand' }) => {
  const [weatherData, setWeatherData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [lastRefreshed, setLastRefreshed] = useState(null);

  const loadWeather = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchDistrictWeather(district);
      setWeatherData(data);
      setLastRefreshed(new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));
    } catch (err) {
      console.error('Weather load error:', err);
      setError('Live weather sync unavailable');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadWeather();
  }, [district]);

  if (loading && !weatherData) {
    return (
      <div
        style={{
          padding: '20px 24px',
          backgroundColor: '#0D1527',
          border: '1px solid #16243E',
          borderRadius: '16px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '10px',
          color: '#94A3B8',
          fontSize: '13px'
        }}
      >
        <RefreshCw size={16} className="animate-spin" color="#38BDF8" />
        <span>Loading live weather forecast for {district}...</span>
      </div>
    );
  }

  if (error && !weatherData) {
    return (
      <div
        style={{
          padding: '16px 20px',
          backgroundColor: '#0D1527',
          border: '1px solid #16243E',
          borderRadius: '16px',
          color: '#94A3B8',
          fontSize: '13px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between'
        }}
      >
        <span>{error}</span>
        <button
          onClick={loadWeather}
          style={{
            padding: '4px 10px',
            backgroundColor: '#1E293B',
            border: 'none',
            borderRadius: '6px',
            color: '#38BDF8',
            fontSize: '12px',
            cursor: 'pointer'
          }}
        >
          Retry
        </button>
      </div>
    );
  }

  const current = weatherData?.current;
  const ConditionIcon = ICON_MAP[current?.conditionIcon] || Cloud;
  const isHighRain = (current?.precipitation || 0) > 2.0;

  return (
    <div
      style={{
        backgroundColor: '#0D1527',
        border: '1px solid #16243E',
        borderRadius: '16px',
        padding: '22px 24px',
        display: 'flex',
        flexDirection: 'column',
        gap: '18px',
        boxShadow: '0 8px 24px rgba(0,0,0,0.3)'
      }}
    >
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
          <div
            style={{
              width: '36px',
              height: '36px',
              borderRadius: '10px',
              backgroundColor: 'rgba(56, 189, 248, 0.12)',
              border: '1px solid rgba(56, 189, 248, 0.25)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#38BDF8'
            }}
          >
            <ConditionIcon size={20} />
          </div>
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF' }}>
                Real-Time Weather Intelligence
              </h3>
              <span
                style={{
                  fontSize: '10px',
                  fontWeight: 700,
                  padding: '2px 8px',
                  borderRadius: '9999px',
                  backgroundColor: 'rgba(16, 185, 129, 0.15)',
                  border: '1px solid rgba(16, 185, 129, 0.3)',
                  color: '#10B981',
                  letterSpacing: '0.5px'
                }}
              >
                LIVE METEO
              </span>
            </div>
            <p style={{ fontSize: '12px', color: '#94A3B8', marginTop: '2px' }}>
              {district} · Elevation: {weatherData?.elevation || 0}m · Last sync: {lastRefreshed}
            </p>
          </div>
        </div>

        <button
          onClick={loadWeather}
          disabled={loading}
          title="Refresh forecast"
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            padding: '6px 12px',
            borderRadius: '8px',
            backgroundColor: '#162238',
            border: '1px solid #1E2E4B',
            color: '#94A3B8',
            fontSize: '12px',
            cursor: 'pointer'
          }}
        >
          <RefreshCw size={13} className={loading ? 'animate-spin' : ''} />
          <span>Refresh</span>
        </button>
      </div>

      {/* Main Stats Grid */}
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(130px, 1fr))',
          gap: '12px'
        }}
      >
        {/* Temperature */}
        <div
          style={{
            padding: '14px 16px',
            backgroundColor: '#080E1C',
            border: '1px solid #142036',
            borderRadius: '12px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#94A3B8', fontSize: '11.5px' }}>
            <Thermometer size={14} color="#F59E0B" />
            <span>Temperature</span>
          </div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#FFFFFF', marginTop: '6px' }}>
            {current?.temperature !== undefined ? `${current.temperature}°C` : '--'}
          </div>
          <span style={{ fontSize: '11px', color: '#38BDF8', fontWeight: 600 }}>
            {current?.conditionLabel}
          </span>
        </div>

        {/* Precipitation */}
        <div
          style={{
            padding: '14px 16px',
            backgroundColor: '#080E1C',
            border: `1px solid ${isHighRain ? 'rgba(239, 68, 68, 0.4)' : '#142036'}`,
            borderRadius: '12px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#94A3B8', fontSize: '11.5px' }}>
            <CloudRain size={14} color="#38BDF8" />
            <span>Precipitation</span>
          </div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: isHighRain ? '#EF4444' : '#FFFFFF', marginTop: '6px' }}>
            {current?.precipitation !== undefined ? `${current.precipitation} mm` : '--'}
          </div>
          <span style={{ fontSize: '11px', color: isHighRain ? '#EF4444' : '#64748B' }}>
            {isHighRain ? '⚠️ Flood risk rate' : 'Normal rainfall'}
          </span>
        </div>

        {/* Wind Speed & Gusts */}
        <div
          style={{
            padding: '14px 16px',
            backgroundColor: '#080E1C',
            border: '1px solid #142036',
            borderRadius: '12px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#94A3B8', fontSize: '11.5px' }}>
            <Wind size={14} color="#10B981" />
            <span>Wind / Gusts</span>
          </div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#FFFFFF', marginTop: '6px' }}>
            {current?.windSpeed !== undefined ? `${current.windSpeed} km/h` : '--'}
          </div>
          <span style={{ fontSize: '11px', color: '#64748B' }}>
            Gusts: {current?.windGusts !== undefined ? `${current.windGusts} km/h` : '--'}
          </span>
        </div>

        {/* Humidity */}
        <div
          style={{
            padding: '14px 16px',
            backgroundColor: '#080E1C',
            border: '1px solid #142036',
            borderRadius: '12px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#94A3B8', fontSize: '11.5px' }}>
            <Droplets size={14} color="#38BDF8" />
            <span>Humidity</span>
          </div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#FFFFFF', marginTop: '6px' }}>
            {current?.humidity !== undefined ? `${current.humidity}%` : '--'}
          </div>
          <span style={{ fontSize: '11px', color: '#64748B' }}>
            Atmospheric moisture
          </span>
        </div>
      </div>

      {/* Hourly Timeline Forecasting Carousel */}
      {weatherData?.hourlyTimeline && weatherData.hourlyTimeline.length > 0 && (
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '12px', fontWeight: 600, color: '#94A3B8', marginBottom: '10px' }}>
            <Clock size={13} color="#38BDF8" />
            <span>Upcoming Hourly Forecast Timeline ({district})</span>
          </div>

          <div
            style={{
              display: 'flex',
              gap: '10px',
              overflowX: 'auto',
              paddingBottom: '6px'
            }}
          >
            {weatherData.hourlyTimeline.map((item, idx) => {
              const ItemIcon = ICON_MAP[item.condition?.icon] || Cloud;
              return (
                <div
                  key={idx}
                  style={{
                    minWidth: '100px',
                    padding: '10px 12px',
                    backgroundColor: '#080E1C',
                    border: '1px solid #142036',
                    borderRadius: '10px',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    gap: '4px',
                    flexShrink: 0
                  }}
                >
                  <span style={{ fontSize: '11px', color: '#64748B', fontWeight: 600 }}>{item.time}</span>
                  <ItemIcon size={18} color="#38BDF8" style={{ margin: '3px 0' }} />
                  <span style={{ fontSize: '13px', fontWeight: 700, color: '#FFFFFF' }}>{item.temp}°C</span>
                  <span style={{ fontSize: '10px', color: item.precipitation > 0 ? '#38BDF8' : '#475569' }}>
                    💧 {item.precipitation}mm
                  </span>
                  <span style={{ fontSize: '9.5px', color: '#64748B' }}>
                    💨 {item.windSpeed}kph
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
};
