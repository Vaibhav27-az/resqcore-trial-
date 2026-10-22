import React from 'react';
import {
  LayoutDashboard,
  Map as MapIcon,
  AlertTriangle,
  Users,
  BarChart3,
  Radio,
  Settings,
  ShieldAlert,
  Activity,
  Cpu
} from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const Sidebar = () => {
  const { activeTab, setActiveTab, incidents } = useApp();

  const navItems = [
    { id: 'command-center', label: 'Command Center', icon: LayoutDashboard },
    { id: 'live-map', label: 'Live Map', icon: MapIcon },
    { id: 'incidents', label: 'Incidents', icon: AlertTriangle, badge: incidents.length.toString() },
    { id: 'teams', label: 'Teams', icon: Users },
    { id: 'reports', label: 'Reports', icon: BarChart3 },
    { id: 'communication', label: 'Communication', icon: Radio },
    { id: 'settings', label: 'Settings', icon: Settings },
    { id: 'os-monitor', label: 'OS Monitor', icon: Cpu }
  ];

  return (
    <aside
      style={{
        width: '260px',
        minWidth: '260px',
        height: '100vh',
        backgroundColor: '#060A13',
        borderRight: '1px solid #162238',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        padding: '24px 16px',
        position: 'sticky',
        top: 0,
        zIndex: 50,
        userSelect: 'none'
      }}
    >
      <div>
        {/* Brand Header */}
        <div
          onClick={() => setActiveTab('command-center')}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            cursor: 'pointer',
            padding: '4px 8px 24px 8px'
          }}
        >
          <div
            style={{
              width: '40px',
              height: '40px',
              borderRadius: '10px',
              backgroundColor: '#2563EB',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              boxShadow: '0 4px 16px rgba(37, 99, 235, 0.4)'
            }}
          >
            <ShieldAlert size={22} color="#FFFFFF" />
          </div>
          <div>
            <h1
              style={{
                fontSize: '18px',
                fontWeight: 700,
                color: '#FFFFFF',
                letterSpacing: '-0.3px',
                lineHeight: 1.1
              }}
            >
              ResQCore
            </h1>
            <span
              style={{
                fontSize: '9px',
                fontWeight: 600,
                color: '#64748B',
                letterSpacing: '1px',
                textTransform: 'uppercase'
              }}
            >
              Disaster Response Platform
            </span>
          </div>
        </div>

        {/* Section Heading */}
        <div
          style={{
            padding: '8px 12px',
            fontSize: '10px',
            fontWeight: 700,
            color: '#475569',
            letterSpacing: '0.8px',
            textTransform: 'uppercase'
          }}
        >
          OPERATIONS
        </div>

        {/* Nav Items */}
        <nav style={{ display: 'flex', flexDirection: 'column', gap: '4px', marginTop: '4px' }}>
          {navItems.map((item) => {
            const isActive = activeTab === item.id;
            const Icon = item.icon;

            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  width: '100%',
                  padding: '10px 14px',
                  borderRadius: '10px',
                  backgroundColor: isActive ? '#142340' : 'transparent',
                  color: isActive ? '#FFFFFF' : '#94A3B8',
                  border: isActive ? '1px solid #1D3560' : '1px solid transparent',
                  fontWeight: isActive ? 600 : 500,
                  fontSize: '13.5px',
                  textAlign: 'left',
                  transition: 'all 0.15s ease'
                }}
                onMouseEnter={(e) => {
                  if (!isActive) {
                    e.currentTarget.style.backgroundColor = 'rgba(255, 255, 255, 0.04)';
                    e.currentTarget.style.color = '#F1F5F9';
                  }
                }}
                onMouseLeave={(e) => {
                  if (!isActive) {
                    e.currentTarget.style.backgroundColor = 'transparent';
                    e.currentTarget.style.color = '#94A3B8';
                  }
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                  <Icon
                    size={18}
                    color={isActive ? '#3B82F6' : '#64748B'}
                    strokeWidth={isActive ? 2.2 : 1.8}
                  />
                  <span>{item.label}</span>
                </div>

                {item.badge && (
                  <span
                    style={{
                      padding: '2px 8px',
                      borderRadius: '9999px',
                      backgroundColor: isActive ? 'rgba(37, 99, 235, 0.3)' : '#162238',
                      color: isActive ? '#60A5FA' : '#94A3B8',
                      fontSize: '11px',
                      fontWeight: 600
                    }}
                  >
                    {item.badge}
                  </span>
                )}
              </button>
            );
          })}
        </nav>
      </div>

      {/* Bottom Status Cards */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
        {/* Active Response Pill */}
        <div
          style={{
            padding: '12px 14px',
            borderRadius: '12px',
            backgroundColor: '#091122',
            border: '1px solid #16243E'
          }}
        >
          <div
            style={{
              fontSize: '10px',
              fontWeight: 700,
              color: '#64748B',
              textTransform: 'uppercase',
              letterSpacing: '0.6px'
            }}
          >
            ACTIVE RESPONSE
          </div>
          <div
            style={{
              fontSize: '13px',
              fontWeight: 600,
              color: '#FFFFFF',
              marginTop: '4px'
            }}
          >
            Kerala monsoon 2026
          </div>
          <div
            style={{
              fontSize: '11px',
              color: '#94A3B8',
              marginTop: '2px'
            }}
          >
            09 Oct · Operational period 04
          </div>
        </div>

        {/* System Online Badge */}
        <div
          style={{
            padding: '12px 14px',
            borderRadius: '12px',
            backgroundColor: 'rgba(16, 185, 129, 0.06)',
            border: '1px solid rgba(16, 185, 129, 0.25)',
            display: 'flex',
            alignItems: 'flex-start',
            gap: '10px'
          }}
        >
          <span
            style={{
              width: '8px',
              height: '8px',
              borderRadius: '50%',
              backgroundColor: '#10B981',
              boxShadow: '0 0 10px #10B981',
              marginTop: '4px',
              flexShrink: 0
            }}
          />
          <div>
            <div
              style={{
                fontSize: '12px',
                fontWeight: 600,
                color: '#10B981'
              }}
            >
              System Online
            </div>
            <div
              style={{
                fontSize: '11px',
                color: '#64748B',
                marginTop: '1px'
              }}
            >
              All channels operational · 28 ms
            </div>
          </div>
        </div>
      </div>
    </aside>
  );
};
