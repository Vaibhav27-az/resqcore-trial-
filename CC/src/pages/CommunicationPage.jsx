import React, { useState } from 'react';
import {
  Radio,
  Send,
  Search,
  Hash,
  User,
  AlertTriangle,
  Bell,
  Megaphone,
  CheckCircle,
  Paperclip,
  Smile
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { initialChannels, initialDirectMessages } from '../data/initialData';

export const CommunicationPage = () => {
  const {
    messages,
    sendMessage,
    activeChannel,
    setActiveChannel,
    sendBroadcast,
    alerts,
    user
  } = useApp();

  const [inputText, setInputText] = useState('');
  const [broadcastTarget, setBroadcastTarget] = useState('All active units');
  const [broadcastSeverity, setBroadcastSeverity] = useState('Critical');
  const [broadcastText, setBroadcastText] = useState('');

  const currentMessages = messages[activeChannel] || [];

  const handleSend = (e) => {
    e.preventDefault();
    if (!inputText.trim()) return;
    sendMessage(activeChannel, inputText);
    setInputText('');
  };

  const handleDispatchBroadcast = (e) => {
    e.preventDefault();
    if (!broadcastText.trim()) return;
    sendBroadcast({
      recipients: broadcastTarget,
      message: broadcastText,
      severity: broadcastSeverity
    });
    setBroadcastText('');
  };

  return (
    <div style={{ display: 'flex', height: 'calc(100vh - 68px)', overflow: 'hidden' }}>
      {/* 1. Left Channel Sidebar */}
      <div
        style={{
          width: '260px',
          minWidth: '260px',
          backgroundColor: '#09101E',
          borderRight: '1px solid #16243E',
          display: 'flex',
          flexDirection: 'column',
          padding: '20px 14px'
        }}
      >
        <div style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF', marginBottom: '14px' }}>
          Channels & Units
        </div>

        {/* Section: Operational Channels */}
        <div
          style={{
            fontSize: '10px',
            fontWeight: 700,
            color: '#64748B',
            textTransform: 'uppercase',
            letterSpacing: '0.6px',
            marginBottom: '8px'
          }}
        >
          OPERATIONAL CHANNELS
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '3px', marginBottom: '20px' }}>
          {initialChannels.map((c) => {
            const isActive = activeChannel === c.id;
            return (
              <button
                key={c.id}
                onClick={() => setActiveChannel(c.id)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  padding: '8px 10px',
                  borderRadius: '8px',
                  backgroundColor: isActive ? '#142340' : 'transparent',
                  color: isActive ? '#FFFFFF' : '#94A3B8',
                  fontSize: '13px',
                  fontWeight: isActive ? 600 : 500,
                  textAlign: 'left'
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <Hash size={15} color={isActive ? '#3B82F6' : '#64748B'} />
                  <span className="truncate">{c.name}</span>
                </div>
                {c.unread > 0 && (
                  <span
                    style={{
                      padding: '1px 6px',
                      borderRadius: '9999px',
                      backgroundColor: '#2563EB',
                      color: '#FFFFFF',
                      fontSize: '11px',
                      fontWeight: 600
                    }}
                  >
                    {c.unread}
                  </span>
                )}
              </button>
            );
          })}
        </div>

        {/* Section: Direct Messages */}
        <div
          style={{
            fontSize: '10px',
            fontWeight: 700,
            color: '#64748B',
            textTransform: 'uppercase',
            letterSpacing: '0.6px',
            marginBottom: '8px'
          }}
        >
          DIRECT MESSAGES
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
          {initialDirectMessages.map((dm) => {
            const isActive = activeChannel === dm.id;
            return (
              <button
                key={dm.id}
                onClick={() => setActiveChannel(dm.id)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  padding: '8px 10px',
                  borderRadius: '8px',
                  backgroundColor: isActive ? '#142340' : 'transparent',
                  color: isActive ? '#FFFFFF' : '#94A3B8',
                  fontSize: '13px',
                  fontWeight: isActive ? 600 : 500,
                  textAlign: 'left'
                }}
              >
                <span
                  style={{
                    width: '7px',
                    height: '7px',
                    borderRadius: '50%',
                    backgroundColor: '#10B981',
                    flexShrink: 0
                  }}
                />
                <span className="truncate">{dm.name}</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* 2. Middle Chat Stream */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', backgroundColor: '#070C16' }}>
        {/* Chat Header */}
        <div
          style={{
            height: '64px',
            padding: '0 24px',
            borderBottom: '1px solid #16243E',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            backgroundColor: '#09101E'
          }}
        >
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              <Hash size={18} color="#3B82F6" />
              <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#FFFFFF' }}>
                {activeChannel.replace('-', ' ')}
              </h3>
            </div>
            <div style={{ fontSize: '11px', color: '#64748B', marginTop: '2px' }}>
              Ernakulam primary emergency response coordinating channel
            </div>
          </div>

          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              fontSize: '12px',
              color: '#10B981',
              backgroundColor: 'rgba(16, 185, 129, 0.1)',
              padding: '4px 10px',
              borderRadius: '9999px'
            }}
          >
            <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#10B981' }} />
            <span>Encrypted Radio Comms</span>
          </div>
        </div>

        {/* Message Feed */}
        <div
          style={{
            flex: 1,
            overflowY: 'auto',
            padding: '24px',
            display: 'flex',
            flexDirection: 'column',
            gap: '18px'
          }}
        >
          {currentMessages.map((msg) => {
            const isSelf = msg.isSelf;

            return (
              <div
                key={msg.id}
                style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '12px',
                  alignSelf: isSelf ? 'flex-end' : 'flex-start',
                  maxWidth: '75%'
                }}
              >
                {!isSelf && (
                  <div
                    style={{
                      width: '34px',
                      height: '34px',
                      borderRadius: '8px',
                      backgroundColor: '#1E2E4B',
                      color: '#93C5FD',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontSize: '12px',
                      fontWeight: 700,
                      flexShrink: 0
                    }}
                  >
                    {msg.initials}
                  </div>
                )}

                <div>
                  <div
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: '8px',
                      justifyContent: isSelf ? 'flex-end' : 'flex-start',
                      marginBottom: '4px'
                    }}
                  >
                    <span style={{ fontSize: '12.5px', fontWeight: 600, color: '#FFFFFF' }}>
                      {msg.sender}
                    </span>
                    <span style={{ fontSize: '11px', color: '#64748B' }}>{msg.time}</span>
                  </div>

                  <div
                    style={{
                      padding: '12px 16px',
                      borderRadius: '12px',
                      backgroundColor: isSelf ? '#173060' : '#0D1527',
                      border: `1px solid ${isSelf ? '#2563EB' : '#1A263D'}`,
                      color: '#F1F5F9',
                      fontSize: '13.5px',
                      lineHeight: '1.5',
                      boxShadow: '0 2px 8px rgba(0,0,0,0.3)'
                    }}
                  >
                    {msg.text}
                  </div>
                </div>

                {isSelf && (
                  <div
                    style={{
                      width: '34px',
                      height: '34px',
                      borderRadius: '8px',
                      backgroundColor: '#1E3A8A',
                      color: '#FFFFFF',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontSize: '12px',
                      fontWeight: 700,
                      flexShrink: 0
                    }}
                  >
                    {msg.initials}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* Message Input Bar */}
        <div
          style={{
            padding: '16px 24px',
            backgroundColor: '#09101E',
            borderTop: '1px solid #16243E'
          }}
        >
          <form
            onSubmit={handleSend}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              backgroundColor: '#0D1527',
              border: '1px solid #1E2E4B',
              borderRadius: '12px',
              padding: '6px 12px'
            }}
          >
            <input
              type="text"
              placeholder={`Message #${activeChannel}...`}
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              style={{
                flex: 1,
                background: 'transparent',
                border: 'none',
                color: '#FFFFFF',
                fontSize: '13.5px',
                padding: '8px 4px'
              }}
            />

            <button
              type="submit"
              style={{
                width: '36px',
                height: '36px',
                borderRadius: '8px',
                backgroundColor: inputText.trim() ? '#2563EB' : '#162238',
                color: inputText.trim() ? '#FFFFFF' : '#475569',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                cursor: inputText.trim() ? 'pointer' : 'default'
              }}
            >
              <Send size={16} />
            </button>
          </form>
        </div>
      </div>

      {/* 3. Right Pane: Operational Alerts & Broadcast Dispatcher */}
      <div
        style={{
          width: '340px',
          minWidth: '340px',
          backgroundColor: '#09101E',
          borderLeft: '1px solid #16243E',
          display: 'flex',
          flexDirection: 'column',
          padding: '20px',
          gap: '20px',
          overflowY: 'auto'
        }}
      >
        {/* Operational Alerts Section */}
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
            <Bell size={16} color="#3B82F6" />
            <h3 style={{ fontSize: '14px', fontWeight: 700, color: '#FFFFFF' }}>
              Operational Alerts
            </h3>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {alerts.map((alt) => (
              <div
                key={alt.id}
                style={{
                  padding: '10px 12px',
                  backgroundColor: '#0D1527',
                  border: '1px solid #16243E',
                  borderRadius: '10px'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <span style={{ fontSize: '12.5px', fontWeight: 600, color: '#FFFFFF' }}>
                    {alt.title}
                  </span>
                  <span style={{ fontSize: '10px', color: '#64748B' }}>{alt.timeAgo}</span>
                </div>
                <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '3px' }}>
                  {alt.subtitle}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Dispatch Emergency Broadcast Widget */}
        <div
          style={{
            backgroundColor: '#0D1527',
            border: '1px solid #1E2E4B',
            borderRadius: '14px',
            padding: '18px',
            display: 'flex',
            flexDirection: 'column',
            gap: '12px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Megaphone size={16} color="#EF4444" />
            <h4 style={{ fontSize: '14px', fontWeight: 700, color: '#FFFFFF' }}>
              Send Emergency Broadcast
            </h4>
          </div>

          <form onSubmit={handleDispatchBroadcast} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
            <div>
              <label style={{ fontSize: '11px', color: '#64748B', fontWeight: 600 }}>Recipients</label>
              <select
                value={broadcastTarget}
                onChange={(e) => setBroadcastTarget(e.target.value)}
                style={{
                  width: '100%',
                  marginTop: '4px',
                  padding: '7px 10px',
                  backgroundColor: '#070C16',
                  border: '1px solid #1A263D',
                  borderRadius: '6px',
                  color: '#CBD5E1',
                  fontSize: '12px'
                }}
              >
                <option value="All active units">All active units</option>
                <option value="District Control">District Control only</option>
                <option value="Medical & Water Rescue">Medical & Water Rescue</option>
              </select>
            </div>

            <div>
              <label style={{ fontSize: '11px', color: '#64748B', fontWeight: 600 }}>Severity</label>
              <select
                value={broadcastSeverity}
                onChange={(e) => setBroadcastSeverity(e.target.value)}
                style={{
                  width: '100%',
                  marginTop: '4px',
                  padding: '7px 10px',
                  backgroundColor: '#070C16',
                  border: '1px solid #1A263D',
                  borderRadius: '6px',
                  color: '#CBD5E1',
                  fontSize: '12px'
                }}
              >
                <option value="Critical">Critical (Immediate sirens)</option>
                <option value="Warning">Warning (Standard alert)</option>
                <option value="Info">Advisory</option>
              </select>
            </div>

            <div>
              <label style={{ fontSize: '11px', color: '#64748B', fontWeight: 600 }}>Broadcast Message</label>
              <textarea
                rows={3}
                placeholder="Compose immediate priority bulletin..."
                value={broadcastText}
                onChange={(e) => setBroadcastText(e.target.value)}
                style={{
                  width: '100%',
                  marginTop: '4px',
                  padding: '8px 10px',
                  backgroundColor: '#070C16',
                  border: '1px solid #1A263D',
                  borderRadius: '6px',
                  color: '#FFFFFF',
                  fontSize: '12.5px',
                  resize: 'none'
                }}
              />
            </div>

            <button
              type="submit"
              disabled={!broadcastText.trim()}
              style={{
                marginTop: '4px',
                padding: '9px',
                borderRadius: '8px',
                backgroundColor: broadcastText.trim() ? '#EF4444' : '#1F2937',
                color: '#FFFFFF',
                fontSize: '12.5px',
                fontWeight: 600,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '6px',
                cursor: broadcastText.trim() ? 'pointer' : 'not-allowed'
              }}
            >
              <Radio size={14} />
              <span>Dispatch Alert</span>
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};
