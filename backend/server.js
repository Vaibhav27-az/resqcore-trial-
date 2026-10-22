const express = require('express');
const cors = require('cors');
const http = require('http');
const { WebSocketServer, WebSocket } = require('ws');
const store = require('./store');
const osMonitor = require('./osMonitor');

const app = express();
const PORT = process.env.PORT || 5000;

// Enable CORS for all incoming requests (Vite web app on localhost:5173, mobile apps, emulators)
app.use(cors({ origin: '*' }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Create HTTP server
const server = http.createServer(app);

// WebSocket Server attached to the same HTTP server
const wss = new WebSocketServer({ server, path: '/ws' });

// Active WebSocket Clients Tracker
const clients = new Set();
const demoMonitor = osMonitor.createMonitor();
const teamLocks = new Set();

function acquireTeamLock(teamId) {
  if (teamLocks.has(teamId)) return false;
  teamLocks.add(teamId);
  return true;
}

wss.on('connection', (ws, req) => {
  clients.add(ws);
  const clientIp = req.socket.remoteAddress;
  console.log(`[WS] Client connected from ${clientIp} (Total active: ${clients.size})`);

  // Send initial welcome & stats
  ws.send(JSON.stringify({
    type: 'CONNECTED',
    message: 'Connected to ResQCore Disaster Unified Hub',
    stats: store.getStats(),
    timestamp: new Date().toISOString()
  }));

  ws.on('message', (message) => {
    try {
      const parsed = JSON.parse(message);
      console.log(`[WS-IN] Type: ${parsed.type}`);
      // Handle client-to-client or client-to-hub messages
      if (parsed.type === 'PING') {
        ws.send(JSON.stringify({ type: 'PONG', timestamp: Date.now() }));
      } else if (parsed.type === 'CHAT_MESSAGE') {
        broadcast(parsed);
      }
    } catch (e) {
      console.error('[WS] Error processing message:', e.message);
    }
  });

  ws.on('close', () => {
    clients.delete(ws);
    console.log(`[WS] Client disconnected (Remaining: ${clients.size})`);
  });

  ws.on('error', (err) => {
    console.error('[WS] Client error:', err.message);
  });
});

// Broadcast helper function to push real-time updates to all connected apps
function broadcast(payload) {
  const data = JSON.stringify(payload);
  for (const client of clients) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  }
}

// ==========================================
// REST API ROUTES
// ==========================================

// 1. Health check & System Info
app.get('/api/health', (req, res) => {
  res.json({
    status: 'online',
    system: 'ResQCore Unified Disaster Response Platform API',
    version: '2.0.0',
    clientsConnected: clients.size,
    uptimeSeconds: Math.floor(process.uptime()),
    timestamp: new Date().toISOString()
  });
});

// 2. Real-time Aggregated Statistics
app.get('/api/stats', (req, res) => {
  res.json(store.getStats());
});

// The OS monitor is a seeded simulator and never reads or mutates live incidents.
app.get('/api/os-monitor', (req, res) => {
  res.json({ success: true, data: demoMonitor.getState() });
});

app.post('/api/os-monitor/reset', (req, res) => {
  const data = demoMonitor.reset();
  broadcast({ type: 'OS_MONITOR_UPDATED', data });
  res.json({ success: true, data });
});

app.post('/api/os-monitor/scenarios/:scenario', (req, res) => {
  try {
    const data = demoMonitor.runScenario(req.params.scenario);
    broadcast({ type: 'OS_MONITOR_UPDATED', data });
    res.json({ success: true, data });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
});

app.post('/api/os-monitor/incidents', (req, res) => {
  try {
    const result = demoMonitor.enqueue(req.body);
    broadcast({ type: 'OS_MONITOR_UPDATED', data: result.state });
    res.status(result.accepted ? 201 : 429).json({
      success: result.accepted,
      message: result.state.message,
      data: result.state
    });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
});

app.post('/api/os-monitor/dispatch/:pid', (req, res) => {
  const result = demoMonitor.dispatch(req.params.pid, (req.body || {}).teamId);
  const status = result.success ? 200 : result.status;
  broadcast({ type: 'OS_MONITOR_UPDATED', data: result.state });
  res.status(status).json({
    success: result.success,
    message: result.message,
    data: result.state
  });
});

app.post('/api/os-monitor/complete/:pid', (req, res) => {
  const result = demoMonitor.complete(req.params.pid);
  const status = result.success ? 200 : result.status;
  broadcast({ type: 'OS_MONITOR_UPDATED', data: result.state });
  res.status(status).json({
    success: result.success,
    message: result.message,
    data: result.state
  });
});

// 3. Incidents / Emergency Requests
app.get('/api/incidents', (req, res) => {
  const { status, severity, category, audience } = req.query;
  let results = [...store.incidents];

  if (audience === 'field') {
    results = results.filter(i =>
      i.status !== 'Unverified' &&
      i.assignedTeam &&
      i.assignedTeam !== 'None'
    );
  }
  if (status) {
    results = results.filter(i => (i.status || '').toLowerCase() === status.toLowerCase());
  }
  if (severity) {
    results = results.filter(i => (i.severity || '').toLowerCase() === severity.toLowerCase());
  }
  if (category) {
    results = results.filter(i => (i.category || i.type || '').toLowerCase() === category.toLowerCase());
  }

  res.json({
    success: true,
    count: results.length,
    data: results
  });
});

app.get('/api/incidents/:id', (req, res) => {
  const incident = store.incidents.find(i => i.id === req.params.id);
  if (!incident) {
    return res.status(404).json({ success: false, message: 'Incident not found' });
  }
  res.json({ success: true, data: incident });
});

// Create new Emergency Request (Citizen App SOS or Report)
app.post('/api/incidents', async (req, res) => {
  const body = req.body || {};
  const timestampNow = new Date();
  const id = body.id || `INC-${Math.floor(1000 + Math.random() * 9000)}`;

  const newIncident = {
    id,
    title: body.title || `${(body.category || body.type || 'Emergency').toUpperCase()} Distress Alert`,
    category: body.category || body.type || 'flood',
    type: body.type || body.category || 'flood',
    location: body.location || body.address || 'Fort Kochi, Ernakulam, Kerala',
    shortLocation: body.shortLocation || (body.location ? body.location.split('·')[0].trim() : 'Ernakulam'),
    area: body.area || 'Ernakulam Metro Sector',
    fullAddress: body.fullAddress || body.address || 'Fort Kochi Municipal Area, Kerala',
    affected: body.affected || body.affectedCount || 4,
    affectedCount: body.affectedCount || body.affected || 4,
    time: body.time || `${timestampNow.getHours().toString().padStart(2, '0')}:${timestampNow.getMinutes().toString().padStart(2, '0')} IST`,
    timestamp: timestampNow.toLocaleString('en-US', { dateStyle: 'medium', timeStyle: 'short' }),
    timeLabel: 'Today · Just now',
    timeAgo: 'Now',
    severity: body.severity || 'High',
    status: 'Unverified',
    citizenStatus: 'pending',
    responseSummary: 'Awaiting verification',
    responseDetail: 'Verify to respond',
    dispatchUpdate: 'Awaiting review by the response desk',
    description: body.description || 'Emergency distress beacon activated by user. Immediate response requested.',
    contactNumber: body.contactNumber || body.contact || '+91 98470 21836',
    fieldReport: 'Distress Signal · Citizen GPS Confirmed',
    coordinates: body.coordinates || {
      lat: body.lat || 9.9658,
      lng: body.lng || 76.2421,
      latText: `${(body.lat || 9.9658).toFixed(4)}° N`,
      lngText: `${(body.lng || 76.2421).toFixed(4)}° E`,
      x: 35,
      y: 55
    },
    assignedTeam: null,
    teamAssigned: 'None',
    eta: 'Awaiting dispatch',
    photoCount: body.photoCount || (body.photos ? body.photos.length : 1),
    image: body.image || '/assets/flood.png',
    photoAssetPath: body.photoAssetPath || 'assets/images/scenarios/flood_river_boat.png'
  };

  // Prepend to incidents list
  store.incidents.unshift(newIncident);
  await store.save();

  // New citizen reports enter the command-center review queue first.
  broadcast({
    type: 'INCIDENT_CREATED',
    data: newIncident,
    stats: store.getStats()
  });

  console.log(`[INCIDENT CREATED] ${newIncident.id} · ${newIncident.title}`);
  res.status(201).json({ success: true, data: newIncident });
});

// Verify Incident (Command Center Action)
app.patch('/api/incidents/:id/verify', async (req, res) => {
  const index = store.incidents.findIndex(i => i.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Incident not found' });
  }

  const body = req.body || {};
  const assignedTeamName = body.assignedTeam;
  if (!assignedTeamName) {
    return res.status(400).json({ success: false, message: 'Select an available rescue team before verifying this incident' });
  }

  const teamIndex = store.teams.findIndex(t =>
    t.name.toLowerCase() === assignedTeamName.toLowerCase() ||
    t.id.toLowerCase() === assignedTeamName.toLowerCase()
  );
  if (teamIndex === -1) {
    return res.status(404).json({ success: false, message: 'Selected rescue team was not found' });
  }
  if (!acquireTeamLock(store.teams[teamIndex].id)) {
    return res.status(409).json({ success: false, message: `${store.teams[teamIndex].name} is team locked by another operator` });
  }

  try {
    if (store.incidents[index].status !== 'Unverified') {
      return res.status(409).json({ success: false, message: 'Incident is not awaiting verification' });
    }
    if (store.teams[teamIndex].status !== 'Available') {
      return res.status(409).json({ success: false, message: `${store.teams[teamIndex].name} is team locked by another operator` });
    }
    const etaText = body.eta || 'ETA 12 min';

    const updated = {
      ...store.incidents[index],
      status: 'Verified',
      citizenStatus: 'inProgress',
      responseSummary: assignedTeamName,
      responseDetail: etaText,
      assignedTeam: assignedTeamName,
      teamAssigned: assignedTeamName,
      eta: etaText,
      dispatchUpdate: `${assignedTeamName} is on the way · ${etaText}`,
      verifiedAt: new Date().toLocaleTimeString('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' }) + ' IST'
    };

    store.incidents[index] = updated;

    // Also update team status
    store.teams[teamIndex].status = 'Deployed';
    store.teams[teamIndex].task = `${updated.id} · ${updated.title}`;
    store.teams[teamIndex].eta = etaText;

    await store.save();

    broadcast({
      type: 'INCIDENT_VERIFIED',
      data: updated,
      assignedTeam: store.teams[teamIndex],
      stats: store.getStats()
    });

    console.log(`[INCIDENT VERIFIED] ${updated.id} verified with team ${assignedTeamName}`);
    res.json({ success: true, data: updated });
  } finally {
    teamLocks.delete(store.teams[teamIndex].id);
  }
});

// Assign Team to Incident
app.post('/api/incidents/:id/assign', async (req, res) => {
  const { teamId, teamName, eta } = req.body;
  const incidentIndex = store.incidents.findIndex(i => i.id === req.params.id);
  if (incidentIndex === -1) {
    return res.status(404).json({ success: false, message: 'Incident not found' });
  }
  if (store.incidents[incidentIndex].status === 'Unverified') {
    return res.status(409).json({ success: false, message: 'Incident must be verified before a team can be assigned' });
  }

  const teamIndex = store.teams.findIndex(t => t.id === teamId || t.name === teamName);
  if (teamIndex === -1) {
    return res.status(404).json({ success: false, message: 'Selected rescue team was not found' });
  }
  const selectedTeam = store.teams[teamIndex];
  if (!acquireTeamLock(selectedTeam.id)) {
    return res.status(409).json({ success: false, message: `${selectedTeam.name} is team locked by another operator` });
  }

  try {
    if (selectedTeam.status !== 'Available') {
      return res.status(409).json({ success: false, message: `${selectedTeam.name} is team locked by another operator` });
    }
    const resolvedTeamName = selectedTeam.name;
    const resolvedEta = eta || 'ETA 15 min';

    const updatedIncident = {
      ...store.incidents[incidentIndex],
      status: store.incidents[incidentIndex].status === 'Unverified' ? 'Verified' : store.incidents[incidentIndex].status,
      citizenStatus: 'inProgress',
      assignedTeam: resolvedTeamName,
      teamAssigned: resolvedTeamName,
      responseSummary: resolvedTeamName,
      responseDetail: resolvedEta,
      eta: resolvedEta,
      dispatchUpdate: `${resolvedTeamName} dispatched · ${resolvedEta}`
    };

    store.incidents[incidentIndex] = updatedIncident;
    selectedTeam.status = 'Deployed';
    selectedTeam.task = `${updatedIncident.id} · ${updatedIncident.title}`;
    selectedTeam.eta = resolvedEta;

    await store.save();

    broadcast({
      type: 'INCIDENT_ASSIGNED',
      data: updatedIncident,
      team: selectedTeam,
      stats: store.getStats()
    });

    console.log(`[TEAM ASSIGNED] ${resolvedTeamName} -> ${updatedIncident.id}`);
    res.json({ success: true, data: updatedIncident });
  } finally {
    teamLocks.delete(selectedTeam.id);
  }
});

// Update Incident Status (e.g. Field Team in RescueApp moves to 'On site' or 'Resolved')
app.patch('/api/incidents/:id/status', async (req, res) => {
  const { status, substatus, dispatchUpdate } = req.body;
  const index = store.incidents.findIndex(i => i.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Incident not found' });
  }

  const current = store.incidents[index];
  if (current.status === 'Unverified' && status && status !== 'Unverified') {
    return res.status(409).json({ success: false, message: 'Incident must be verified before field status updates' });
  }
  const updated = {
    ...current,
    status: status || current.status,
    citizenStatus: status === 'Resolved' ? 'resolved' : (status === 'On site' ? 'inProgress' : current.citizenStatus),
    substatus: substatus || current.substatus,
    dispatchUpdate: dispatchUpdate || (status === 'Resolved' ? 'Rescue operations completed · Evacuation verified' : current.dispatchUpdate)
  };

  store.incidents[index] = updated;
  await store.save();

  broadcast({
    type: 'INCIDENT_STATUS_UPDATED',
    data: updated,
    stats: store.getStats()
  });

  console.log(`[STATUS UPDATED] ${updated.id} -> ${updated.status}`);
  res.json({ success: true, data: updated });
});

// 4. Teams & Telemetry
app.get('/api/teams', (req, res) => {
  res.json({
    success: true,
    count: store.teams.length,
    data: store.teams
  });
});

app.patch('/api/teams/:id', async (req, res) => {
  const index = store.teams.findIndex(t => t.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Team not found' });
  }

  const updatedTeam = {
    ...store.teams[index],
    ...req.body,
    lastUpdate: 'Just now'
  };

  store.teams[index] = updatedTeam;
  await store.save();

  broadcast({
    type: 'TEAM_UPDATED',
    data: updatedTeam,
    stats: store.getStats()
  });

  res.json({ success: true, data: updatedTeam });
});

// 5. Alerts & Broadcasts
app.get('/api/alerts', (req, res) => {
  res.json({
    success: true,
    count: store.alerts.length,
    data: store.alerts
  });
});

app.post('/api/alerts', async (req, res) => {
  const { title, subtitle, severity, recipients, message, category, riskLevel, location } = req.body;
  const newAlert = {
    id: `a-${Date.now()}`,
    title: title || 'Operational Broadcast Alert',
    code: 'ALL-UNITS',
    subtitle: subtitle || (message ? message.slice(0, 50) + '...' : 'Command broadcast issued'),
    category: category || 'Weather',
    riskLevel: riskLevel || 'High risk',
    location: location || 'Ernakulam Metropolitan Zone',
    timeAgo: 'Just now',
    severity: severity || 'High',
    message: message || title,
    recipients: recipients || 'All responders & citizens',
    createdAt: new Date().toISOString()
  };

  store.alerts.unshift(newAlert);
  await store.save();

  broadcast({
    type: 'ALERT_BROADCAST',
    data: newAlert
  });

  console.log(`[ALERT BROADCAST] ${newAlert.title}`);
  res.status(201).json({ success: true, data: newAlert });
});

// 6. Communications & Chat
app.get('/api/messages/:channel', (req, res) => {
  const channel = req.params.channel;
  const list = store.messages[channel] || [];
  res.json({ success: true, channel, data: list });
});

app.post('/api/messages/:channel', async (req, res) => {
  const channel = req.params.channel;
  const { sender, initials, text, isSelf, isAlert, role } = req.body;
  if (!text || !text.trim()) {
    return res.status(400).json({ success: false, message: 'Text cannot be empty' });
  }

  const newMsg = {
    id: `m-${Date.now()}`,
    sender: sender || 'Field Operative',
    initials: initials || 'FO',
    role: role || 'First Responder',
    isSelf: Boolean(isSelf),
    isAlert: Boolean(isAlert),
    time: new Date().toLocaleTimeString('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' }),
    text: text.trim(),
    createdAt: new Date().toISOString()
  };

  if (!store.messages[channel]) {
    store.messages[channel] = [];
  }
  store.messages[channel].push(newMsg);
  await store.save();

  broadcast({
    type: 'MESSAGE_SENT',
    channel,
    data: newMsg
  });

  res.status(201).json({ success: true, data: newMsg });
});

// 7. Static serving of connected clients
const path = require('path');
const fs = require('fs');

const citizenWebPath = path.join(__dirname, '..', 'RescueCoreF', 'build', 'web');
const tacticalWebPath = path.join(__dirname, '..', 'RescueApp', 'build', 'web');
const commandWebPath = path.join(__dirname, '..', 'CC', 'dist');

// Dynamic handler for Flutter subpaths that rewrites <base href="/"> to <base href="/<subpath>/">
function registerFlutterSubpath(routePrefix, diskPath) {
  if (!fs.existsSync(diskPath)) return;

  const sendIndex = (req, res) => {
    const indexPath = path.join(diskPath, 'index.html');
    if (fs.existsSync(indexPath)) {
      let content = fs.readFileSync(indexPath, 'utf8');
      content = content.replace(/<base href="[^"]*">/, `<base href="${routePrefix}/">`);
      res.setHeader('Content-Type', 'text/html; charset=utf-8');
      return res.send(content);
    }
    res.status(404).send('Web build index.html not found');
  };

  app.get(routePrefix, sendIndex);
  app.get(`${routePrefix}/`, sendIndex);
  app.get(`${routePrefix}/index.html`, sendIndex);
  app.use(routePrefix, express.static(diskPath));
}

registerFlutterSubpath('/citizen', citizenWebPath);
registerFlutterSubpath('/tactical', tacticalWebPath);
if (fs.existsSync(commandWebPath)) {
  app.use('/command', express.static(commandWebPath));
}

// 8. Multi-Device Operations Control Portal (Root Dashboard)
app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ResQCore - Unified Disaster Response Multi-Device Simulator</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', -apple-system, sans-serif;
      background: #060B14;
      color: #E2E8F0;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    header {
      background: #0A101D;
      border-bottom: 1px solid #1E293B;
      padding: 14px 28px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 12px;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .brand-icon {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, #2563EB, #1D4ED8);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      box-shadow: 0 0 16px rgba(37,99,235,0.4);
    }
    .brand-title {
      font-size: 18px;
      font-weight: 800;
      letter-spacing: -0.5px;
      color: #FFFFFF;
    }
    .brand-subtitle {
      font-size: 12px;
      color: #64748B;
      font-family: 'JetBrains Mono', monospace;
    }
    .status-badges {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }
    .badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 11px;
      font-weight: 600;
      padding: 4px 10px;
      border-radius: 999px;
      background: #0F172A;
      border: 1px solid #1E293B;
      color: #94A3B8;
    }
    .badge-live {
      background: rgba(16, 185, 129, 0.12);
      border-color: rgba(16, 185, 129, 0.3);
      color: #34D399;
    }
    .dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: #10B981;
      box-shadow: 0 0 8px #10B981;
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.5; transform: scale(0.85); }
    }
    .actions-bar {
      background: #0B1323;
      border-bottom: 1px solid #1E293B;
      padding: 10px 28px;
      display: flex;
      align-items: center;
      gap: 12px;
      overflow-x: auto;
    }
    .action-btn {
      background: #1E293B;
      color: #F8FAFC;
      border: 1px solid #334155;
      font-size: 12px;
      font-weight: 600;
      padding: 7px 14px;
      border-radius: 6px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: all 0.15s ease;
      white-space: nowrap;
    }
    .action-btn:hover {
      background: #2563EB;
      border-color: #3B82F6;
      box-shadow: 0 0 12px rgba(37,99,235,0.4);
    }
    .action-btn.danger {
      background: rgba(239, 68, 68, 0.15);
      border-color: rgba(239, 68, 68, 0.4);
      color: #FCA5A5;
    }
    .action-btn.danger:hover {
      background: #DC2626;
      color: white;
    }
    .main-grid {
      display: grid;
      grid-template-columns: 380px 1fr 380px;
      gap: 16px;
      padding: 16px 24px;
      flex: 1;
      min-height: calc(100vh - 120px);
    }
    @media (max-width: 1400px) {
      .main-grid {
        grid-template-columns: 1fr;
      }
    }
    .panel-card {
      background: #0A101D;
      border: 1px solid #1E293B;
      border-radius: 12px;
      display: flex;
      flex-direction: column;
      overflow: hidden;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
    }
    .panel-header {
      padding: 12px 16px;
      background: #0F172A;
      border-bottom: 1px solid #1E293B;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .panel-title {
      font-size: 13px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .panel-link {
      font-size: 11px;
      color: #38BDF8;
      text-decoration: none;
      padding: 4px 8px;
      border-radius: 4px;
      background: rgba(56, 189, 248, 0.1);
      border: 1px solid rgba(56, 189, 248, 0.2);
    }
    .panel-link:hover {
      background: #38BDF8;
      color: #0F172A;
    }
    .panel-body {
      flex: 1;
      position: relative;
      background: #030712;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 580px;
    }
    iframe {
      width: 100%;
      height: 100%;
      border: none;
      min-height: 580px;
    }
    .live-log {
      position: fixed;
      bottom: 12px;
      right: 12px;
      width: 380px;
      max-height: 220px;
      background: rgba(10, 16, 29, 0.95);
      border: 1px solid #1E293B;
      border-radius: 8px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.6);
      backdrop-filter: blur(8px);
      z-index: 100;
      display: flex;
      flex-direction: column;
      overflow: hidden;
      font-family: 'JetBrains Mono', monospace;
      font-size: 11px;
    }
    .log-header {
      padding: 6px 12px;
      background: #0F172A;
      border-bottom: 1px solid #1E293B;
      display: flex;
      justify-content: space-between;
      font-weight: 600;
      color: #94A3B8;
    }
    .log-content {
      padding: 8px 12px;
      overflow-y: auto;
      max-height: 180px;
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .log-entry {
      color: #38BDF8;
      line-height: 1.4;
    }
    .log-entry.create { color: #F59E0B; }
    .log-entry.verify { color: #10B981; }
    .log-entry.alert { color: #EF4444; }
  </style>
</head>
<body>
  <header>
    <div class="brand">
      <div class="brand-icon">⚡</div>
      <div>
        <div class="brand-title">ResQCore Multi-Device Operational Control Hub</div>
        <div class="brand-subtitle">Kerala Disaster Operations · Live Simulation Center</div>
      </div>
    </div>
    <div class="status-badges">
      <div class="badge badge-live"><span class="dot"></span> Backend Engine (Port 5000)</div>
      <div class="badge badge-live"><span class="dot"></span> WebSockets (/ws)</div>
      <div class="badge"><span style="color:#38BDF8;">●</span> Command Center (Port 5173)</div>
      <div class="badge"><span style="color:#F59E0B;">●</span> Citizen App (APK 1)</div>
      <div class="badge"><span style="color:#10B981;">●</span> Tactical Ops (APK 2)</div>
    </div>
  </header>

  <div class="actions-bar">
    <span style="font-size:12px; font-weight:700; color:#64748B; text-transform:uppercase;">Live Trigger Actions:</span>
    <button class="action-btn danger" onclick="simulateSos()">🚨 1-Click Citizen SOS</button>
    <button class="action-btn" onclick="simulateVerify()">✅ Verify & Assign Bravo 02</button>
    <button class="action-btn" onclick="simulateOnSite()">📍 Field Unit "On Scene"</button>
    <button class="action-btn" onclick="simulateBroadcast()">📢 Send District Broadcast</button>
    <button class="action-btn" onclick="simulateResolved()">🏁 Resolve Incident</button>
  </div>

  <div class="main-grid">
    <!-- PANEL 1: CITIZEN MOBILE APP -->
    <div class="panel-card">
      <div class="panel-header">
        <div class="panel-title">📱 Citizen App (APK 1 · RescueCoreF)</div>
        <a class="panel-link" href="http://localhost:8081" target="_blank">Open :8081 ↗</a>
      </div>
      <div class="panel-body">
        <iframe src="/citizen/" title="Citizen Mobile App"></iframe>
      </div>
    </div>

    <!-- PANEL 2: COMMAND CENTER WEB APP -->
    <div class="panel-card">
      <div class="panel-header">
        <div class="panel-title">🖥️ Command Center Web App (CC · ResQCore)</div>
        <a class="panel-link" href="http://localhost:5173" target="_blank">Open :5173 ↗</a>
      </div>
      <div class="panel-body">
        <iframe src="http://localhost:5173" title="Command Center Web App"></iframe>
      </div>
    </div>

    <!-- PANEL 3: TACTICAL FIELD OPS APP -->
    <div class="panel-card">
      <div class="panel-header">
        <div class="panel-title">🛡️ Tactical Field Ops (APK 2 · RescueApp)</div>
        <a class="panel-link" href="http://localhost:8082" target="_blank">Open :8082 ↗</a>
      </div>
      <div class="panel-body">
        <iframe src="/tactical/" title="Tactical Field Ops"></iframe>
      </div>
    </div>
  </div>

  <!-- Real-time WebSocket Log Floating Window -->
  <div class="live-log">
    <div class="log-header">
      <span>⚡ LIVE WEBSOCKET TELEMETRY</span>
      <span id="ws-status" style="color:#10B981;">CONNECTED</span>
    </div>
    <div class="log-content" id="log-box">
      <div class="log-entry">Waiting for operational events...</div>
    </div>
  </div>

  <script>
    const logBox = document.getElementById('log-box');
    function addLog(text, type = '') {
      const entry = document.createElement('div');
      entry.className = 'log-entry ' + type;
      const time = new Date().toLocaleTimeString();
      entry.innerText = \`[\${time}] \${text}\`;
      logBox.appendChild(entry);
      logBox.scrollTop = logBox.scrollHeight;
    }

    // Connect to WebSocket
    const ws = new WebSocket(\`ws://\${location.host}/ws\`);
    ws.onopen = () => {
      document.getElementById('ws-status').innerText = 'CONNECTED';
      addLog('WebSocket link established with Backend Hub', 'verify');
    };
    ws.onmessage = (event) => {
      try {
        const payload = JSON.parse(event.data);
        if (payload.type === 'INCIDENT_CREATED') {
          addLog(\`🚨 INCIDENT CREATED: \${payload.data.id} - \${payload.data.title}\`, 'create');
        } else if (payload.type === 'INCIDENT_VERIFIED') {
          addLog(\`✅ INCIDENT VERIFIED: \${payload.data.id} -> Dispatched \${payload.data.assignedTeam}\`, 'verify');
        } else if (payload.type === 'INCIDENT_STATUS_UPDATED') {
          addLog(\`📍 STATUS UPDATE: \${payload.data.id} -> \${payload.data.status}\`, 'verify');
        } else if (payload.type === 'ALERT_BROADCAST') {
          addLog(\`📢 BROADCAST: \${payload.data.title}\`, 'alert');
        } else if (payload.type === 'MESSAGE_SENT') {
          addLog(\`💬 RADIO MSG [\${payload.channel}]: \${payload.data.sender}: \${payload.data.text}\`);
        }
      } catch(e) {}
    };

    // Live Actions
    async function simulateSos() {
      const id = 'SOS-' + Date.now().toString().slice(-4);
      addLog(\`Sending simulated 1-click SOS (\${id})...\`);
      await fetch('/api/incidents', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          id,
          title: '🚨 CRITICAL FLASH INUNDATION SOS',
          category: 'flood',
          address: 'KB Jacob Waterway, Fort Kochi',
          description: 'Water breached residence. 4 civilians trapped on first floor.',
          contactNumber: '+91 98470 21836',
          lat: 9.9658,
          lng: 76.2421
        })
      });
    }

    async function simulateVerify() {
      addLog('Command Center verifying latest unverified incident...');
      await fetch('/api/incidents/INC-2048/verify', {
        method: 'PATCH',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ assignedTeam: 'Bravo 02', eta: 'ETA 6 min' })
      });
    }

    async function simulateOnSite() {
      addLog('Field Team Bravo 02 updating status to "On site"...');
      await fetch('/api/incidents/INC-2048/status', {
        method: 'PATCH',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ status: 'On site', substatus: 'On site · Conducting boat evacuation' })
      });
    }

    async function simulateBroadcast() {
      addLog('Issuing district-wide emergency broadcast...');
      await fetch('/api/alerts', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          title: 'Flash Flood Evacuation Notice · Fort Kochi Zone',
          message: 'Water levels rising rapidly in low-lying canal basins. All residents move to Sector 4 shelter.',
          recipients: 'All Units & Citizens',
          severity: 'High'
        })
      });
    }

    async function simulateResolved() {
      addLog('Field Commander marking incident as Resolved...');
      await fetch('/api/incidents/INC-2048/status', {
        method: 'PATCH',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ status: 'Resolved', substatus: 'Resolved · All citizens safely relocated' })
      });
    }
  </script>
</body>
</html>`);
});

app.use((error, req, res, next) => {
  console.error(`[API ERROR] ${req.method} ${req.path}:`, error.message);
  if (res.headersSent) return next(error);

  if (error.code === '23505' && error.constraint === 'one_active_assignment_per_team') {
    return res.status(409).json({
      success: false,
      message: 'That rescue team was just assigned to another active incident. Refresh the team list and select an available team.'
    });
  }
  if (error.code === '23505' || error.code === '23503' || error.code === '23514') {
    return res.status(409).json({
      success: false,
      message: 'The requested change conflicts with database rules.'
    });
  }

  res.status(500).json({
    success: false,
    message: 'The request could not be saved. Check the backend log for details.'
  });
});

// Start Server on 0.0.0.0
store.initialize().then(() => {
  server.listen(PORT, '0.0.0.0', () => {
    console.log('===========================================================');
    console.log(`🚀 ResQCore Unified Emergency Hub running on port ${PORT}`);
    console.log(`📡 Multi-App Simulator: http://localhost:${PORT}`);
    console.log(`📱 Citizen App:         http://localhost:${PORT}/citizen/`);
    console.log(`🛡️ Tactical Field App:  http://localhost:${PORT}/tactical/`);
    console.log(`📱 Android Emulator:   http://10.0.2.2:${PORT}`);
    console.log(`⚡ WebSocket Stream:   ws://0.0.0.0:${PORT}/ws`);
    console.log('===========================================================');
  });
}).catch((error) => {
  console.error('[PostgreSQL] Backend startup failed:', error.message);
  process.exitCode = 1;
});

// Dedicated independent web servers for Citizen (8081) and Tactical (8082)
const CITIZEN_PORT = 8081;
const TACTICAL_PORT = 8082;

if (fs.existsSync(citizenWebPath)) {
  const citizenApp = express();
  citizenApp.use(cors({ origin: '*' }));
  citizenApp.use(express.static(citizenWebPath));
  citizenApp.use((req, res) => res.sendFile(path.join(citizenWebPath, 'index.html')));
  citizenApp.listen(CITIZEN_PORT, '0.0.0.0', () => {
    console.log(`📱 Citizen App dedicated server:  http://localhost:${CITIZEN_PORT}`);
  }).on('error', (err) => {
    if (err.code !== 'EADDRINUSE') console.warn('[Citizen Web]', err.message);
  });
}

if (fs.existsSync(tacticalWebPath)) {
  const tacticalApp = express();
  tacticalApp.use(cors({ origin: '*' }));
  tacticalApp.use(express.static(tacticalWebPath));
  tacticalApp.use((req, res) => res.sendFile(path.join(tacticalWebPath, 'index.html')));
  tacticalApp.listen(TACTICAL_PORT, '0.0.0.0', () => {
    console.log(`🛡️ Tactical App dedicated server: http://localhost:${TACTICAL_PORT}`);
  }).on('error', (err) => {
    if (err.code !== 'EADDRINUSE') console.warn('[Tactical Web]', err.message);
  });
}
