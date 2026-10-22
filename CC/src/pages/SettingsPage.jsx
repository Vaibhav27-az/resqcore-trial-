import React, { useState } from 'react';
import {
  Settings,
  Bell,
  Shield,
  Layers,
  PhoneCall,
  Save,
  Check
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export const SettingsPage = () => {
  const { user, setUser, addToast } = useApp();
  const [name, setName] = useState(user.name);
  const [district, setDistrict] = useState(user.district);
  const [role, setRole] = useState(user.role);
  const [soundAlerts, setSoundAlerts] = useState(true);
  const [autoSync, setAutoSync] = useState(true);

  const handleSave = (e) => {
    e.preventDefault();
    setUser(prev => ({ ...prev, name, district, role }));
    addToast({
      type: 'team-assigned',
      title: 'Preferences Saved',
      code: 'Operational settings updated',
      detail: 'Configuration persisted for active session.'
    });
  };

  return (
    <div style={{ padding: '28px 32px', maxWidth: '800px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
      <div>
        <h1 style={{ fontSize: '26px', fontWeight: 800, color: '#FFFFFF', letterSpacing: '-0.4px' }}>
          Platform Settings
        </h1>
        <p style={{ fontSize: '13px', color: '#94A3B8', marginTop: '4px' }}>
          Configure operational parameters, operator profile, and emergency radio feeds.
        </p>
      </div>

      <form onSubmit={handleSave} style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
        {/* Profile Card */}
        <div
          style={{
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '16px',
            padding: '24px',
            display: 'flex',
            flexDirection: 'column',
            gap: '16px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <Shield size={18} color="#3B82F6" />
            <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
              Operator Profile
            </h3>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
            <div>
              <label style={{ display: 'block', fontSize: '12px', color: '#94A3B8', marginBottom: '6px' }}>
                Full Name
              </label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                style={{
                  width: '100%',
                  padding: '10px 14px',
                  backgroundColor: '#070C16',
                  border: '1px solid #1A263D',
                  borderRadius: '8px',
                  color: '#FFFFFF',
                  fontSize: '13.5px'
                }}
              />
            </div>

            <div>
              <label style={{ display: 'block', fontSize: '12px', color: '#94A3B8', marginBottom: '6px' }}>
                Assigned Operational Role
              </label>
              <select
                value={role}
                onChange={(e) => setRole(e.target.value)}
                style={{
                  width: '100%',
                  padding: '10px 14px',
                  backgroundColor: '#070C16',
                  border: '1px solid #1A263D',
                  borderRadius: '8px',
                  color: '#FFFFFF',
                  fontSize: '13.5px'
                }}
              >
                <option value="Command Operator">Command Operator</option>
                <option value="Field Responder">Field Responder</option>
                <option value="District Administrator">District Administrator</option>
              </select>
            </div>
          </div>
        </div>

        {/* Telemetry & Audio Card */}
        <div
          style={{
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '16px',
            padding: '24px',
            display: 'flex',
            flexDirection: 'column',
            gap: '16px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <Bell size={18} color="#3B82F6" />
            <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
              Telemetry & Alerts
            </h3>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
            <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', cursor: 'pointer' }}>
              <div>
                <div style={{ fontSize: '13.5px', color: '#FFFFFF', fontWeight: 500 }}>
                  High Severity Siren Chimes
                </div>
                <div style={{ fontSize: '12px', color: '#64748B' }}>
                  Play audible warning for new unverified High priority incidents
                </div>
              </div>
              <input
                type="checkbox"
                checked={soundAlerts}
                onChange={(e) => setSoundAlerts(e.target.checked)}
                style={{ accentColor: '#2563EB', width: '18px', height: '18px' }}
              />
            </label>

            <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', cursor: 'pointer' }}>
              <div>
                <div style={{ fontSize: '13.5px', color: '#FFFFFF', fontWeight: 500 }}>
                  Continuous Satellite Refresh
                </div>
                <div style={{ fontSize: '12px', color: '#64748B' }}>
                  Auto-synchronize GIS overlay every 30 seconds
                </div>
              </div>
              <input
                type="checkbox"
                checked={autoSync}
                onChange={(e) => setAutoSync(e.target.checked)}
                style={{ accentColor: '#2563EB', width: '18px', height: '18px' }}
              />
            </label>
          </div>
        </div>

        {/* Emergency Hotline Directory */}
        <div
          style={{
            backgroundColor: '#0D1527',
            border: '1px solid #16243E',
            borderRadius: '16px',
            padding: '24px',
            display: 'flex',
            flexDirection: 'column',
            gap: '12px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <PhoneCall size={18} color="#EF4444" />
            <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#FFFFFF' }}>
              Kerala State Emergency Hotlines
            </h3>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '12px', marginTop: '6px' }}>
            <div style={{ padding: '12px', backgroundColor: '#070C16', borderRadius: '8px', border: '1px solid #162238' }}>
              <div style={{ fontSize: '11px', color: '#64748B' }}>Disaster Helpline</div>
              <div style={{ fontSize: '18px', fontWeight: 700, color: '#EF4444' }}>1077</div>
            </div>
            <div style={{ padding: '12px', backgroundColor: '#070C16', borderRadius: '8px', border: '1px solid #162238' }}>
              <div style={{ fontSize: '11px', color: '#64748B' }}>Emergency Response</div>
              <div style={{ fontSize: '18px', fontWeight: 700, color: '#38BDF8' }}>112</div>
            </div>
            <div style={{ padding: '12px', backgroundColor: '#070C16', borderRadius: '8px', border: '1px solid #162238' }}>
              <div style={{ fontSize: '11px', color: '#64748B' }}>Ambulance Dispatch</div>
              <div style={{ fontSize: '18px', fontWeight: 700, color: '#10B981' }}>108</div>
            </div>
          </div>
        </div>

        <button
          type="submit"
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
            padding: '12px 24px',
            borderRadius: '10px',
            backgroundColor: '#2563EB',
            color: '#FFFFFF',
            fontSize: '14px',
            fontWeight: 600,
            alignSelf: 'flex-start'
          }}
        >
          <Save size={16} />
          <span>Save Configuration</span>
        </button>
      </form>
    </div>
  );
};
