import React from 'react';

export const SeverityBadge = ({ severity }) => {
  const map = {
    High: {
      color: '#EF4444',
      bg: 'rgba(239, 68, 68, 0.12)',
      border: 'rgba(239, 68, 68, 0.28)',
      label: 'High'
    },
    Medium: {
      color: '#F59E0B',
      bg: 'rgba(245, 158, 11, 0.12)',
      border: 'rgba(245, 158, 11, 0.28)',
      label: 'Medium'
    },
    Info: {
      color: '#38BDF8',
      bg: 'rgba(56, 189, 248, 0.12)',
      border: 'rgba(56, 189, 248, 0.28)',
      label: 'Info'
    }
  };

  const current = map[severity] || map.Info;

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '6px',
        padding: '3px 10px',
        borderRadius: '9999px',
        fontSize: '12px',
        fontWeight: 500,
        color: current.color,
        backgroundColor: current.bg,
        border: `1px solid ${current.border}`,
        whiteSpace: 'nowrap'
      }}
    >
      <span
        style={{
          width: '6px',
          height: '6px',
          borderRadius: '50%',
          backgroundColor: current.color
        }}
      />
      {current.label}
    </span>
  );
};

export const StatusBadge = ({ status }) => {
  const map = {
    Deployed: { color: '#10B981', bg: 'rgba(16, 185, 129, 0.12)', border: 'rgba(16, 185, 129, 0.28)', label: 'Deployed' },
    Available: { color: '#3B82F6', bg: 'rgba(59, 130, 246, 0.12)', border: 'rgba(59, 130, 246, 0.28)', label: 'Available' },
    Escalated: { color: '#F59E0B', bg: 'rgba(245, 158, 11, 0.12)', border: 'rgba(245, 158, 11, 0.28)', label: 'Escalated' },
    Unverified: { color: '#F59E0B', bg: 'rgba(245, 158, 11, 0.12)', border: 'rgba(245, 158, 11, 0.28)', label: 'Unverified' },
    Verified: { color: '#10B981', bg: 'rgba(16, 185, 129, 0.12)', border: 'rgba(16, 185, 129, 0.28)', label: 'Verified' },
    Responding: { color: '#10B981', bg: 'rgba(16, 185, 129, 0.12)', border: 'rgba(16, 185, 129, 0.28)', label: 'Responding' },
    'On site': { color: '#10B981', bg: 'rgba(16, 185, 129, 0.12)', border: 'rgba(16, 185, 129, 0.28)', label: 'On site' },
    Monitoring: { color: '#38BDF8', bg: 'rgba(56, 189, 248, 0.12)', border: 'rgba(56, 189, 248, 0.28)', label: 'Monitoring' }
  };

  const current = map[status] || { color: '#94A3B8', bg: 'rgba(148, 163, 184, 0.12)', border: 'rgba(148, 163, 184, 0.28)', label: status };

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '6px',
        padding: '3px 10px',
        borderRadius: '9999px',
        fontSize: '12px',
        fontWeight: 500,
        color: current.color,
        backgroundColor: current.bg,
        border: `1px solid ${current.border}`,
        whiteSpace: 'nowrap'
      }}
    >
      <span
        style={{
          width: '6px',
          height: '6px',
          borderRadius: '50%',
          backgroundColor: current.color
        }}
      />
      {current.label}
    </span>
  );
};
