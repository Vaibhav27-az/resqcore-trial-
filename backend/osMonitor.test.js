const test = require('node:test');
const assert = require('node:assert/strict');
const {
  QUEUE_CAPACITY,
  createMonitor,
  createProcess,
  createState,
  dispatch,
  enqueue,
  priorityFor,
  runScenario
} = require('./osMonitor');

test('aging promotes a waiting minor request into a higher priority tier', () => {
  const now = Date.now();
  const minor = createProcess({
    id: 'MINOR-AGING',
    severity: 'Low',
    category: 'other',
    affected: 1
  }, { arrivalTime: now });
  assert.equal(minor.priorityTier, 'Minor');
  assert.equal(priorityFor(minor, now + 10 * 60 * 1000).tier, 'Delayed');
});

test('bounded queue stays at capacity and admits a critical SOS by replacing the lowest priority', () => {
  const now = Date.now();
  const state = createState(now);
  state.processes = [];
  state.reviewingPid = null;
  for (let index = 0; index < QUEUE_CAPACITY; index += 1) {
    enqueue(state, {
      pid: `LOW-${index}`,
      title: 'Low priority',
      category: 'other',
      severity: 'Low',
      affected: 1,
      state: 'READY',
      arrivalTime: now + index,
      basePriority: 25,
      maximum: { ambulances: 0, boats: 0, medicalKits: 0, foodPacks: 0 },
      allocation: { ambulances: 0, boats: 0, medicalKits: 0, foodPacks: 0 },
      request: { ambulances: 0, boats: 0, medicalKits: 0, foodPacks: 0 }
    }, now + index);
  }
  const critical = {
    pid: 'CRITICAL-1',
    title: 'Critical',
    category: 'flood',
    severity: 'Critical',
    affected: 100,
    state: 'READY',
    arrivalTime: now + 20,
    basePriority: 100,
    maximum: { ambulances: 1, boats: 1, medicalKits: 1, foodPacks: 1 },
    allocation: { ambulances: 0, boats: 0, medicalKits: 0, foodPacks: 0 },
    request: { ambulances: 0, boats: 0, medicalKits: 0, foodPacks: 0 }
  };
  const result = enqueue(state, critical, now + 20);
  assert.equal(result.accepted, true);
  assert.equal(state.processes.length, QUEUE_CAPACITY);
  assert.ok(state.processes.some(process => process.pid === 'CRITICAL-1'));
  assert.equal(state.processes.filter(process => process.pid.startsWith('LOW-')).length, QUEUE_CAPACITY - 1);
});

test('a low-priority SOS receives a retry response when the queue is full', () => {
  const state = runScenario(createState(), 'surge');
  const before = state.processes.length;
  const low = createProcess({
    id: 'LOW-OVERFLOW',
    title: 'Low overflow',
    severity: 'Low',
    category: 'other',
    affected: 1
  });
  const rejected = enqueue(state, { ...low, pid: 'LOW-RETRY' });
  assert.equal(rejected.accepted, false);
  assert.match(state.message, /queue full; retry/i);
  assert.equal(before, QUEUE_CAPACITY);
  assert.equal(state.processes.length, QUEUE_CAPACITY);
});

test('safe-sequence algorithm rejects a request that makes every remaining process unsafe', () => {
  const monitor = createMonitor();
  const result = monitor.runScenario('unsafe');
  assert.equal(result.banker.lastRequest.granted, false);
  assert.match(result.banker.lastRequest.reason, /no safe sequence/i);
  assert.equal(result.banker.safeSequence.length, 3);
});

test('priority scheduling reduces average wait for the same seeded SOS burst', () => {
  const state = createMonitor().getState();
  assert.ok(state.comparison.priorityAverageWait < state.comparison.fcfsAverageWait);
});

test('surge scenario never exceeds queue capacity and contains only seeded demo IDs', () => {
  const state = runScenario(createState(), 'surge');
  assert.equal(state.processes.length, QUEUE_CAPACITY);
  assert.ok(state.processes.every(process => process.pid.startsWith('DEMO-SURGE-')));
  assert.ok(state.events.some(event => event.type === 'QUEUE_REPLACED'));
  assert.ok(state.events.some(event => event.type === 'QUEUE_FULL'));
});

test('critical SOS preempts the review candidate while preserving the ready PCB', () => {
  const state = runScenario(createState(), 'critical');
  assert.ok(state.events.some(event => event.type === 'PREEMPTED'));
  assert.equal(state.reviewingPid, state.processes.find(process => process.pid === state.reviewingPid)?.pid);
  assert.equal(state.processes.find(process => process.pid === 'DEMO-1001').state, 'READY');
});

test('dispatch and completion release allocated resources and team assignment', () => {
  const monitor = createMonitor();
  let state = monitor.getState();
  const pid = state.reviewingPid;
  const teamId = state.teams.find(team => team.status === 'Available').id;
  const before = { ...state.banker.available };
  const dispatched = monitor.dispatch(pid, teamId);
  assert.equal(dispatched.success, true);
  assert.equal(dispatched.state.runningPid, pid);
  assert.notDeepEqual(dispatched.state.banker.available, before);
  const waitingPid = dispatched.state.readyQueue[0];
  const busyDesk = monitor.dispatch(waitingPid, teamId);
  assert.equal(busyDesk.success, false);
  assert.match(busyDesk.message, /already using the command desk/i);
  const completed = monitor.complete(pid);
  assert.equal(completed.success, true);
  assert.equal(completed.state.runningPid, null);
  assert.deepEqual(completed.state.banker.available, before);
  assert.equal(completed.state.teams.find(team => team.id === teamId).status, 'Available');
});

test('a team lock rejects a second operator with an explicit locked message', () => {
  const state = createState();
  const pid = state.reviewingPid;
  state.teamLocks.add('DEMO-TEAM-1');
  const result = dispatch(state, pid, 'DEMO-TEAM-1');
  assert.equal(result.success, false);
  assert.match(result.message, /team locked/i);
  assert.ok(state.events.some(event => event.type === 'LOCK_DENIED'));
});
