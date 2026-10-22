const QUEUE_CAPACITY = 10;
const AGING_INTERVAL_MS = 5 * 60 * 1000;
const RESOURCE_NAMES = ['ambulances', 'boats', 'medicalKits', 'foodPacks'];
const RESOURCE_LABELS = {
  ambulances: 'Ambulances',
  boats: 'Boats',
  medicalKits: 'Medical kits',
  foodPacks: 'Food packs'
};
const PRIORITY_SCORES = {
  critical: 100,
  high: 75,
  medium: 50,
  low: 25,
  minor: 25,
  info: 20
};
const CATEGORY_BONUS = {
  fire: 10,
  medical: 8,
  rescue: 8,
  flood: 5
};

function resourceVector(values = {}) {
  if (!values || typeof values !== 'object' || Array.isArray(values)) {
    throw new Error('Resource vectors must be objects.');
  }
  return Object.fromEntries(RESOURCE_NAMES.map(name => {
    const value = Number(values[name] ?? 0);
    if (!Number.isSafeInteger(value) || value < 0) {
      throw new Error(`Resource ${name} must be a non-negative whole number.`);
    }
    return [name, value];
  }));
}

function addVectors(left, right) {
  return resourceVector(Object.fromEntries(
    RESOURCE_NAMES.map(name => [name, left[name] + right[name]])
  ));
}

function subtractVectors(left, right) {
  return resourceVector(Object.fromEntries(
    RESOURCE_NAMES.map(name => [name, left[name] - right[name]])
  ));
}

function vectorFits(request, available) {
  return RESOURCE_NAMES.every(name => request[name] <= available[name]);
}

function getNeed(process) {
  return subtractVectors(process.maximum, process.allocation);
}

function getBasePriority(incident) {
  const severity = String(incident.severity || 'low').toLowerCase();
  const severityScore = PRIORITY_SCORES[severity] ?? PRIORITY_SCORES.low;
  const category = String(incident.category || '').toLowerCase();
  const people = Math.max(0, Number(incident.affected || incident.affectedCount || 0));
  const peopleScore = Math.min(15, Math.floor(people / 10));
  return Math.min(100, severityScore + (CATEGORY_BONUS[category] || 0) + peopleScore);
}

function tierForScore(score) {
  if (score >= 80) return 'Immediate';
  if (score >= 50) return 'Delayed';
  return 'Minor';
}

function priorityFor(process, now = Date.now()) {
  const waitingMs = Math.max(0, now - process.arrivalTime);
  const agingBoost = Math.floor(waitingMs / AGING_INTERVAL_MS) * 20;
  const score = Math.min(100, process.basePriority + agingBoost);
  return {
    score,
    tier: tierForScore(score),
    waitTimeSeconds: Math.floor(waitingMs / 1000)
  };
}

function createProcess(incident, { arrivalTime = Date.now(), pid } = {}) {
  const id = pid || incident.id || `DEMO-${Date.now()}`;
  const basePriority = getBasePriority(incident);
  return {
    pid: id,
    title: incident.title || 'Demo emergency',
    category: incident.category || 'other',
    severity: incident.severity || 'Low',
    affected: Number(incident.affected || incident.affectedCount || 1),
    state: 'READY',
    basePriority,
    priorityScore: basePriority,
    effectiveScore: basePriority,
    priorityTier: tierForScore(basePriority),
    observedTier: tierForScore(basePriority),
    arrivalTime,
    waitTimeSeconds: 0,
    maximum: resourceVector(incident.maximum),
    allocation: resourceVector(),
    request: resourceVector(incident.request)
  };
}

function createSeedProcesses(now = Date.now()) {
  return [
    createProcess({
      id: 'DEMO-1001',
      title: 'Residential fire rescue',
      category: 'fire',
      severity: 'High',
      affected: 20,
      maximum: { ambulances: 1, boats: 0, medicalKits: 3, foodPacks: 0 },
      request: { ambulances: 1, medicalKits: 2 }
    }, { arrivalTime: now - 2 * 60 * 1000 }),
    createProcess({
      id: 'DEMO-1002',
      title: 'Bridge access collapse',
      category: 'rescue',
      severity: 'Medium',
      affected: 12,
      maximum: { ambulances: 1, boats: 1, medicalKits: 2, foodPacks: 0 },
      request: { boats: 1, medicalKits: 1 }
    }, { arrivalTime: now - 4 * 60 * 1000 }),
    createProcess({
      id: 'DEMO-1003',
      title: 'Flooded shelter medical aid',
      category: 'medical',
      severity: 'Medium',
      affected: 8,
      maximum: { ambulances: 1, boats: 0, medicalKits: 4, foodPacks: 2 },
      request: { ambulances: 1, medicalKits: 2 }
    }, { arrivalTime: now - 7 * 60 * 1000 }),
    createProcess({
      id: 'DEMO-1004',
      title: 'Minor supply check',
      category: 'other',
      severity: 'Low',
      affected: 2,
      maximum: { ambulances: 0, boats: 0, medicalKits: 1, foodPacks: 4 },
      request: { foodPacks: 1 }
    }, { arrivalTime: now - 12 * 60 * 1000 })
  ];
}

function createBankerView() {
  const total = resourceVector({
    ambulances: 3,
    boats: 2,
    medicalKits: 10,
    foodPacks: 24
  });
  return {
    total,
    available: { ...total },
    processes: [
      { pid: 'DEMO-1001', maximum: resourceVector({ ambulances: 1, medicalKits: 3 }), allocation: resourceVector() },
      { pid: 'DEMO-1002', maximum: resourceVector({ ambulances: 1, boats: 1, medicalKits: 2 }), allocation: resourceVector() },
      { pid: 'DEMO-1003', maximum: resourceVector({ ambulances: 1, medicalKits: 4, foodPacks: 2 }), allocation: resourceVector() },
      { pid: 'DEMO-1004', maximum: resourceVector({ medicalKits: 1, foodPacks: 4 }), allocation: resourceVector() }
    ],
    safeSequence: [],
    lastRequest: null
  };
}

function createUnsafeBankerView() {
  const total = resourceVector({
    ambulances: 10,
    boats: 5,
    medicalKits: 7,
    foodPacks: 6
  });
  const processes = [
    {
      pid: 'DEMO-OS-P0',
      maximum: resourceVector({ ambulances: 7, boats: 5, medicalKits: 3, foodPacks: 3 }),
      allocation: resourceVector({ boats: 1 })
    },
    {
      pid: 'DEMO-OS-P1',
      maximum: resourceVector({ ambulances: 3, boats: 2, medicalKits: 2, foodPacks: 3 }),
      allocation: resourceVector({ ambulances: 2, foodPacks: 1 })
    },
    {
      pid: 'DEMO-OS-P2',
      maximum: resourceVector({ ambulances: 9, medicalKits: 2, foodPacks: 4 }),
      allocation: resourceVector({ ambulances: 3, medicalKits: 2 })
    }
  ];
  const allocated = processes.reduce((sum, process) => addVectors(sum, process.allocation), resourceVector());
  return {
    total,
    available: subtractVectors(total, allocated),
    processes,
    safeSequence: [],
    lastRequest: null
  };
}

function findSafeSequence(processes, available) {
  let work = { ...available };
  const unfinished = new Set(processes.map((process, index) => index));
  const sequence = [];

  while (unfinished.size) {
    let found = false;
    for (const index of unfinished) {
      const process = processes[index];
      const need = getNeed(process);
      if (!vectorFits(need, work)) continue;
      work = addVectors(work, process.allocation);
      unfinished.delete(index);
      sequence.push(process.pid);
      found = true;
      break;
    }
    if (!found) return { safe: false, sequence, blocked: [...unfinished].map(i => processes[i].pid) };
  }

  return { safe: true, sequence, blocked: [] };
}

function requestIsSafe(view, pid, request) {
  const process = view.processes.find(item => item.pid === pid);
  if (!process) return { granted: false, reason: `Process ${pid} is not in the resource table.` };

  const normalizedRequest = resourceVector(request);
  const need = getNeed(process);
  if (!vectorFits(normalizedRequest, need)) {
    return { granted: false, reason: 'Request exceeds this process maximum need.' };
  }
  if (!vectorFits(normalizedRequest, view.available)) {
    const unavailable = RESOURCE_NAMES
      .filter(name => normalizedRequest[name] > view.available[name])
      .map(name => `${RESOURCE_LABELS[name]}: requested ${normalizedRequest[name]}, available ${view.available[name]}`);
    return { granted: false, reason: `Insufficient available resources (${unavailable.join('; ')}).` };
  }

  const candidateProcesses = view.processes.map(item => ({
    ...item,
    allocation: { ...item.allocation },
    maximum: { ...item.maximum }
  }));
  const candidateProcess = candidateProcesses.find(item => item.pid === pid);
  candidateProcess.allocation = addVectors(candidateProcess.allocation, normalizedRequest);
  const candidateAvailable = subtractVectors(view.available, normalizedRequest);
  const safety = findSafeSequence(candidateProcesses, candidateAvailable);
  if (!safety.safe) {
    return {
      granted: false,
      reason: `Request denied: the tentative allocation leaves no safe sequence; blocked: ${safety.blocked.join(', ')}.`,
      safeSequence: safety.sequence
    };
  }

  process.allocation = addVectors(process.allocation, normalizedRequest);
  view.available = candidateAvailable;
  return { granted: true, reason: 'Safe state preserved.', safeSequence: safety.sequence };
}

function makeEvent(state, type, message, pid) {
  state.events.unshift({
    id: `OS-${++state.eventCounter}`,
    type,
    message,
    pid: pid || null,
    timestamp: new Date().toISOString()
  });
  state.events = state.events.slice(0, 50);
}

function sortReadyQueue(state, now = Date.now()) {
  return state.processes
    .filter(process => process.state === 'READY')
    .map(process => ({ process, priority: priorityFor(process, now) }))
    .sort((left, right) =>
      right.priority.score - left.priority.score ||
      left.process.arrivalTime - right.process.arrivalTime
    )
    .map(item => item.process);
}

function refreshAging(state, now = Date.now()) {
  for (const process of state.processes) {
    if (process.state !== 'READY') continue;
    const priority = priorityFor(process, now);
    process.effectiveScore = priority.score;
    process.priorityScore = process.basePriority;
    process.priorityTier = priority.tier;
    process.waitTimeSeconds = priority.waitTimeSeconds;
    const rank = ['Minor', 'Delayed', 'Immediate'];
    if (rank.indexOf(priority.tier) > rank.indexOf(process.observedTier)) {
      makeEvent(state, 'AGED', `${process.pid} aged from ${process.observedTier} to ${priority.tier}.`, process.pid);
      process.observedTier = priority.tier;
    }
  }
}

function nextReviewPid(state) {
  if (state.runningPid) return null;
  return sortReadyQueue(state)[0]?.pid || null;
}

function createState(now = Date.now()) {
  const state = {
    demoOnly: true,
    queueCapacity: QUEUE_CAPACITY,
    processes: createSeedProcesses(now),
    runningPid: null,
    reviewingPid: null,
    teams: [
      { id: 'DEMO-TEAM-1', name: 'Demo Rescue 01', status: 'Available', assignedPid: null },
      { id: 'DEMO-TEAM-2', name: 'Demo Rescue 02', status: 'Available', assignedPid: null }
    ],
    teamLocks: new Set(),
    banker: createBankerView(),
    events: [],
    eventCounter: 0,
    comparison: null,
    message: null,
    scenario: 'seeded'
  };
  refreshAging(state, now);
  state.reviewingPid = nextReviewPid(state);
  state.banker.safeSequence = findSafeSequence(state.banker.processes, state.banker.available).sequence;
  makeEvent(state, 'SYSTEM', 'Seeded OS monitor started. Live incidents are not connected.', null);
  return state;
}

function compareSchedulers(processes) {
  function averageWait(order) {
    let elapsed = 0;
    let waitTotal = 0;
    for (const process of order) {
      const start = elapsed;
      waitTotal += start;
      const tier = priorityFor(process).tier;
      const serviceMinutes = tier === 'Immediate' ? 1 : tier === 'Delayed' ? 2 : 5;
      elapsed = start + serviceMinutes;
    }
    return Number((waitTotal / Math.max(order.length, 1)).toFixed(1));
  }
  const byArrival = [...processes].sort((a, b) => a.arrivalTime - b.arrivalTime);
  const byPriority = [...processes].sort((a, b) =>
    priorityFor(b).score - priorityFor(a).score || a.arrivalTime - b.arrivalTime
  );
  return {
    fcfsAverageWait: averageWait(byArrival),
    priorityAverageWait: averageWait(byPriority)
  };
}

function createIncidentFromInput(input, id, arrivalTime = Date.now()) {
  if (!input || typeof input !== 'object') {
    throw new Error('An incident payload is required.');
  }
  const severity = String(input.severity || '').trim();
  if (!Object.hasOwn(PRIORITY_SCORES, severity.toLowerCase())) {
    throw new Error('Severity must be Critical, High, Medium, Low, Minor, or Info.');
  }
  const maximum = resourceVector(input.maximum);
  const request = resourceVector(input.request);
  if (RESOURCE_NAMES.some(name => request[name] > maximum[name])) {
    throw new Error('Resource request must be non-negative and no greater than the declared maximum.');
  }
  const affected = Number(input.affected ?? input.affectedCount ?? 1);
  if (!Number.isSafeInteger(affected) || affected < 1) {
    throw new Error('Affected people must be a positive whole number.');
  }
  return createProcess({
    id,
    title: String(input.title || 'Demo SOS').slice(0, 120),
    category: String(input.category || 'other').slice(0, 40),
    severity,
    affected,
    maximum,
    request
  }, { arrivalTime });
}

function enqueue(state, process, now = Date.now()) {
  refreshAging(state, now);
  const ready = sortReadyQueue(state, now);
  if (ready.length >= state.queueCapacity) {
    const lowest = ready[ready.length - 1];
    const incomingPriority = priorityFor(process, now);
    const lowestPriority = priorityFor(lowest, now);
    if (process.severity.toLowerCase() === 'critical' && incomingPriority.score > lowestPriority.score) {
      state.processes = state.processes.filter(item => item.pid !== lowest.pid);
      state.banker.processes = state.banker.processes.filter(item => item.pid !== lowest.pid);
      makeEvent(state, 'QUEUE_REPLACED', `${process.pid} replaced ${lowest.pid}, the lowest-priority queued SOS.`, process.pid);
    } else {
      state.message = `${process.pid} rejected: intake queue full; retry later.`;
      makeEvent(state, 'QUEUE_FULL', state.message, process.pid);
      return { accepted: false, replacedPid: null };
    }
  }

  const currentReview = state.reviewingPid && state.processes.find(item => item.pid === state.reviewingPid);
  state.processes.push(process);
  if (!state.banker.processes.some(item => item.pid === process.pid)) {
    state.banker.processes.push({
      pid: process.pid,
      maximum: { ...process.maximum },
      allocation: { ...process.allocation }
    });
  }
  const top = sortReadyQueue(state, now)[0];
  if (currentReview && top.pid !== currentReview.pid && priorityFor(top, now).score > priorityFor(currentReview, now).score) {
    makeEvent(state, 'PREEMPTED', `${currentReview.pid} review paused; ${top.pid} is more urgent.`, currentReview.pid);
    state.reviewingPid = top.pid;
  } else if (!state.reviewingPid) {
    state.reviewingPid = top?.pid || null;
  }

  state.message = `${process.pid} entered the demo intake queue.`;
  makeEvent(state, 'SOS_ARRIVED', `${process.pid} entered the bounded intake queue (${Math.min(sortReadyQueue(state, now).length, state.queueCapacity)}/${state.queueCapacity}).`, process.pid);
  return { accepted: true, replacedPid: null };
}

function getSnapshot(state, now = Date.now()) {
  refreshAging(state, now);
  if (!state.runningPid) state.reviewingPid = nextReviewPid(state);
  const readyQueue = sortReadyQueue(state, now);
  const safe = findSafeSequence(state.banker.processes, state.banker.available);
  state.banker.safeSequence = safe.safe ? safe.sequence : [];
  state.banker.processes = state.banker.processes.map(process => ({
    pid: process.pid,
    maximum: process.maximum,
    allocation: process.allocation,
    need: getNeed(process)
  }));
  const visibleProcesses = state.processes.map(process => {
    const priority = process.state === 'READY'
      ? priorityFor(process, now)
      : {
          score: process.effectiveScore,
          tier: process.priorityTier,
          waitTimeSeconds: process.waitTimeSeconds
        };
    const bankerProcess = state.banker.processes.find(item => item.pid === process.pid);
    return {
      ...process,
      effectiveScore: priority.score,
      priorityTier: priority.tier,
      waitTimeSeconds: priority.waitTimeSeconds,
      need: bankerProcess ? bankerProcess.need : getNeed(process)
    };
  });

  return {
    demoOnly: true,
    queueCapacity: state.queueCapacity,
    queueCount: readyQueue.length,
    readyQueue: readyQueue.map(process => process.pid),
    processes: visibleProcesses,
    runningPid: state.runningPid,
    reviewingPid: state.reviewingPid,
    teams: state.teams.map(team => ({ ...team, locked: state.teamLocks.has(team.id) })),
    banker: {
      total: state.banker.total,
      available: state.banker.available,
      resourceNames: RESOURCE_LABELS,
      processes: state.banker.processes,
      safeSequence: state.banker.safeSequence,
      lastRequest: state.banker.lastRequest
    },
    events: state.events,
    comparison: state.comparison || compareSchedulers(state.processes),
    message: state.message,
    scenario: state.scenario
  };
}

function runScenario(state, scenario, now = Date.now()) {
  state.message = null;
  if (scenario === 'reset') {
    return createState(now);
  }
  if (scenario === 'surge') {
    const fresh = createState(now);
    fresh.processes = [];
    fresh.reviewingPid = null;
    fresh.banker = createBankerView();
    fresh.banker.processes = [];
    fresh.banker.available = { ...fresh.banker.total };
    fresh.scenario = 'surge';
    const severityCycle = ['Low', 'Medium', 'Low', 'High', 'Minor', 'Medium', 'Low', 'Medium', 'Low', 'High', 'Minor', 'Critical', 'Low', 'Medium', 'Low'];
    for (let index = 0; index < 15; index += 1) {
      const severity = severityCycle[index];
      const process = createIncidentFromInput({
        title: `Surge SOS ${String(index + 1).padStart(2, '0')}`,
        category: ['flood', 'medical', 'rescue'][index % 3],
        severity,
        affected: [4, 18, 2, 30, 3][index % 5],
        maximum: { ambulances: 1, boats: 1, medicalKits: 2, foodPacks: 4 },
        request: { ambulances: 1, medicalKits: 1 }
      }, `DEMO-SURGE-${String(index + 1).padStart(2, '0')}`, now + index);
      enqueue(fresh, process, now + index);
    }
    fresh.comparison = compareSchedulers(fresh.processes);
    fresh.message = `Surge complete: 15 demo SOS processed; ${fresh.processes.length} remain in the bounded queue.`;
    makeEvent(fresh, 'SURGE_COMPLETE', fresh.message, null);
    return fresh;
  }
  if (scenario === 'critical') {
    state = createState(now);
    state.scenario = 'critical';
    state.reviewingPid = nextReviewPid(state);
    const process = createIncidentFromInput({
      title: 'Critical flash-flood SOS',
      category: 'flood',
      severity: 'Critical',
      affected: 120,
      maximum: { ambulances: 1, boats: 1, medicalKits: 4, foodPacks: 8 },
      request: { ambulances: 1, boats: 1, medicalKits: 2 }
    }, `DEMO-CRITICAL-${Date.now()}`, now);
    enqueue(state, process, now);
    state.comparison = compareSchedulers(state.processes);
    return state;
  }
  if (scenario === 'unsafe') {
    state.scenario = 'unsafe request';
    state.banker = createUnsafeBankerView();
    const originalSafe = findSafeSequence(state.banker.processes, state.banker.available);
    const attempt = requestIsSafe(state.banker, 'DEMO-OS-P0', { ambulances: 5 });
    state.banker.lastRequest = {
      pid: 'DEMO-OS-P0',
      request: resourceVector({ ambulances: 5 }),
      granted: attempt.granted,
      reason: attempt.reason,
      attemptedSafeSequence: attempt.safeSequence || [],
      safeSequence: originalSafe.sequence
    };
    state.message = attempt.granted ? 'Banker granted the demo request.' : attempt.reason;
    makeEvent(state, 'ALLOCATION_DENIED', attempt.reason, 'DEMO-OS-P0');
    return state;
  }
  throw new Error(`Unknown OS monitor scenario: ${scenario}`);
}

function dispatch(state, pid, teamId) {
  if (state.scenario === 'unsafe request') {
    return { success: false, status: 409, message: 'Reset the demo before dispatching; the unsafe-request scenario is isolated.' };
  }
  if (state.runningPid) {
    return { success: false, status: 409, message: `${state.runningPid} is already using the command desk.` };
  }
  const process = state.processes.find(item => item.pid === pid && item.state === 'READY');
  if (!process) return { success: false, status: 404, message: 'Ready process not found.' };
  if (state.reviewingPid !== pid) {
    return { success: false, status: 409, message: `${pid} is not the process currently selected by the scheduler.` };
  }
  const team = state.teams.find(item => item.id === teamId);
  if (!team) return { success: false, status: 404, message: 'Demo team not found.' };
  if (state.teamLocks.has(teamId) || team.status !== 'Available') {
    const message = `${team.name} is team locked and cannot be assigned right now.`;
    makeEvent(state, 'LOCK_DENIED', message, pid);
    return { success: false, status: 409, message };
  }

  state.teamLocks.add(teamId);
  try {
    const request = requestIsSafe(state.banker, pid, process.request);
    state.banker.lastRequest = { pid, request: process.request, ...request };
    if (!request.granted) {
      const message = `Allocation denied for ${pid}: ${request.reason}`;
      state.message = message;
      makeEvent(state, 'ALLOCATION_DENIED', message, pid);
      return { success: false, status: 409, message };
    }
    const resourceProcess = state.banker.processes.find(item => item.pid === pid);
    process.allocation = { ...resourceProcess.allocation };
    process.state = 'RUNNING';
    state.runningPid = pid;
    state.reviewingPid = null;
    team.status = 'Deployed';
    team.assignedPid = pid;
    state.message = `${pid} verified; ${team.name} dispatched.`;
    makeEvent(state, 'DISPATCHED', state.message, pid);
    return { success: true, message: state.message };
  } finally {
    state.teamLocks.delete(teamId);
  }
}

function complete(state, pid) {
  if (state.runningPid !== pid) {
    return { success: false, status: 409, message: `${pid} is not the process running at the command desk.` };
  }
  const process = state.processes.find(item => item.pid === pid);
  process.state = 'TERMINATED';
  const resourceProcess = state.banker.processes.find(item => item.pid === pid);
  const allocation = resourceProcess?.allocation || process.allocation;
  state.banker.available = addVectors(state.banker.available, allocation);
  if (resourceProcess) resourceProcess.allocation = resourceVector();
  process.allocation = resourceVector();
  const team = state.teams.find(item => item.assignedPid === pid);
  if (team) {
    team.status = 'Available';
    team.assignedPid = null;
  }
  state.runningPid = null;
  state.message = `${pid} completed; allocated resources released.`;
  makeEvent(state, 'COMPLETED', state.message, pid);
  state.reviewingPid = nextReviewPid(state);
  return { success: true, message: state.message };
}

function createMonitor() {
  let state = createState();
  let nextIncidentId = 1;
  return {
    getState: () => getSnapshot(state),
    reset: () => {
      state = runScenario(state, 'reset');
      nextIncidentId = 1;
      return getSnapshot(state);
    },
    runScenario: scenario => {
      state = runScenario(state, scenario);
      return getSnapshot(state);
    },
    enqueue: input => {
      const process = createIncidentFromInput(input, `DEMO-MANUAL-${nextIncidentId++}`);
      const result = enqueue(state, process);
      return { ...result, state: getSnapshot(state) };
    },
    dispatch: (pid, teamId) => {
      const result = dispatch(state, pid, teamId);
      return { ...result, state: getSnapshot(state) };
    },
    complete: pid => {
      const result = complete(state, pid);
      return { ...result, state: getSnapshot(state) };
    }
  };
}

module.exports = {
  AGING_INTERVAL_MS,
  QUEUE_CAPACITY,
  RESOURCE_NAMES,
  compareSchedulers,
  createMonitor,
  createProcess,
  createState,
  dispatch,
  enqueue,
  findSafeSequence,
  getBasePriority,
  getNeed,
  getSnapshot,
  priorityFor,
  requestIsSafe,
  runScenario
};
