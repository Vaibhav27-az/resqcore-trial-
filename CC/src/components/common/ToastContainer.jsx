import React from 'react';
import { AlertTriangle, CheckCircle, X, Radio } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const ToastContainer = () => {
  const { toasts, removeToast, inspectIncident } = useApp();

  if (!toasts.length) return null;

  return (
    <div
      style={{
        position: 'fixed',
        bottom: '24px',
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: 9999,
        display: 'flex',
        flexDirection: 'column',
        gap: '12px',
        maxWidth: '520px',
        width: 'calc(100% - 32px)',
        pointerEvents: 'none'
      }}
    >
      {toasts.map(toast => {
        const isHigh = toast.type === 'high-incident';
        const isAssigned = toast.type === 'team-assigned';
        const isBroadcast = toast.type === 'broadcast-sent';

        const borderColor = isHigh
          ? 'rgba(239, 68, 68, 0.45)'
          : isAssigned
          ? 'rgba(16, 185, 129, 0.45)'
          : 'rgba(59, 130, 246, 0.45)';

        const bgGlow = isHigh
          ? 'rgba(239, 68, 68, 0.08)'
          : isAssigned
          ? 'rgba(16, 185, 129, 0.08)'
          : 'rgba(59, 130, 246, 0.08)';

        return (
          <div
            key={toast.id}
            onClick={() => {
              if (toast.incidentId) {
                inspectIncident(toast.incidentId, 'live-map');
              }
            }}
            className="animate-slide-up"
            style={{
              pointerEvents: 'auto',
              cursor: toast.incidentId ? 'pointer' : 'default',
              display: 'flex',
              alignItems: 'flex-start',
              gap: '14px',
              padding: '16px 18px',
              backgroundColor: '#0D1527',
              backgroundImage: `radial-gradient(circle at top left, ${bgGlow}, transparent 70%)`,
              border: `1px solid ${borderColor}`,
              borderRadius: '12px',
              boxShadow: '0 12px 32px rgba(0, 0, 0, 0.65)',
              position: 'relative'
            }}
          >
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                width: '32px',
                height: '32px',
                borderRadius: '8px',
                backgroundColor: isHigh
                  ? 'rgba(239, 68, 68, 0.15)'
                  : isAssigned
                  ? 'rgba(16, 185, 129, 0.15)'
                  : 'rgba(59, 130, 246, 0.15)',
                color: isHigh ? '#EF4444' : isAssigned ? '#10B981' : '#3B82F6',
                flexShrink: 0
              }}
            >
              {isHigh && <AlertTriangle size={18} />}
              {isAssigned && <CheckCircle size={18} />}
              {isBroadcast && <Radio size={18} />}
            </div>

            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span
                  style={{
                    fontSize: '14px',
                    fontWeight: 600,
                    color: '#FFFFFF'
                  }}
                >
                  {toast.title}
                </span>
              </div>
              <div
                style={{
                  fontSize: '13px',
                  color: '#CBD5E1',
                  marginTop: '2px',
                  fontWeight: 400
                }}
              >
                {toast.code}
              </div>
              <div
                style={{
                  fontSize: '12px',
                  marginTop: '4px',
                  fontWeight: 500,
                  color: isHigh ? '#F87171' : isAssigned ? '#34D399' : '#60A5FA'
                }}
              >
                {toast.detail}
              </div>
            </div>

            <button
              onClick={(e) => {
                e.stopPropagation();
                removeToast(toast.id);
              }}
              style={{
                background: 'transparent',
                border: 'none',
                color: '#64748B',
                padding: '4px',
                borderRadius: '6px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
              onMouseEnter={(e) => (e.currentTarget.style.color = '#FFFFFF')}
              onMouseLeave={(e) => (e.currentTarget.style.color = '#64748B')}
            >
              <X size={16} />
            </button>
          </div>
        );
      })}
    </div>
  );
};
