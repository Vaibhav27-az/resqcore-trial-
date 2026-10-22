import React, { useCallback, useEffect, useMemo, useState } from 'react';
import {
  Activity,
  AlertTriangle,
  CheckCircle2,
  CircleDot,
  Clock3,
  Cpu,
  LockKeyhole,
  Play,
  RotateCcw,
  ShieldCheck,
  Siren,
  Truck
} from 'lucide-react';
import { api } from '../services/api';
import './OSMonitor.css';

const resourceLabels = {
  ambulances: 'Amb',
  boats: 'Boat',
  medicalKits: 'Kits',
  foodPacks: 'Food'
};

const tierClass = {
  Immediate: 'os-tier-immediate',
  Delayed: 'os-tier-delayed',
  Minor: 'os-tier-minor'
};

const eventIcons = {
  PREEMPTED: <Siren size={15} />,
  AGED: <Clock3 size={15} />,
  LOCK_DENIED: <LockKeyhole size={15} />,
  ALLOCATION_DENIED: <ShieldCheck size={15} />,
  COMPLETED: <CheckCircle2 size={15} />,
  DISPATCHED: <Truck size={15} />
};

function compactResources(resources = {}) {
  const parts = Object.entries(resourceLabels)
    .filter(([key]) => resources[key] > 0)
    .map(([key, label]) => `${label} ${resources[key]}`);
  return parts.length ? parts.join(' · ') : '—';
}

function formatWait(seconds = 0) {
  const minutes = Math.floor(seconds / 60);
  const remainder = seconds % 60;
  return `${minutes}:${String(remainder).padStart(2, '0')}`;
}

function timeLabel(timestamp) {
  return new Date(timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
}

export const OSMonitor = () => {
  const [monitor, setMonitor] = useState(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');

  const refresh = useCallback(async () => {
    const data = await api.getOsMonitor();
    setMonitor(data);
    setError('');
  }, []);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      try {
        const data = await api.getOsMonitor();
        if (mounted) {
          setMonitor(data);
          setError('');
        }
      } catch (loadError) {
        if (mounted) setError(loadError.message);
      }
    };
    load();
    const interval = window.setInterval(load, 2500);
    return () => {
      mounted = false;
      window.clearInterval(interval);
    };
  }, []);

  const runAction = async action => {
    setBusy(true);
    setError('');
    try {
      setMonitor(await action());
    } catch (actionError) {
      setError(actionError.message);
      try {
        await refresh();
      } catch (refreshError) {
        setError(`${actionError.message} · ${refreshError.message}`);
      }
    } finally {
      setBusy(false);
    }
  };

  const processByPid = useMemo(
    () => new Map((monitor?.processes || []).map(process => [process.pid, process])),
    [monitor?.processes]
  );
  const reviewing = processByPid.get(monitor?.reviewingPid);
  const running = processByPid.get(monitor?.runningPid);
  const availableTeam = monitor?.teams?.find(team => team.status === 'Available');
  const fill = monitor ? Math.min(100, (monitor.queueCount / monitor.queueCapacity) * 100) : 0;

  if (!monitor) {
    return (
      <section className="os-monitor-page">
        <div className="os-panel os-loading">
          {error ? <><AlertTriangle size={18} /> {error}</> : 'Connecting to seeded OS simulator…'}
        </div>
      </section>
    );
  }

  return (
    <section className="os-monitor-page">
      <header className="os-page-header">
        <div>
          <div className="os-eyebrow"><Cpu size={14} /> ResQCore · OS SIMULATION</div>
          <h1>Operating system monitor</h1>
          <p>One command desk, one active process. This seeded demo is isolated from real incidents.</p>
        </div>
        <div className="os-demo-stamp"><CircleDot size={14} /> DEMO DATA ONLY</div>
      </header>

      <div className="os-demo-toolbar">
        <div className="os-demo-buttons">
          <button disabled={busy} onClick={() => runAction(() => api.runOsScenario('surge'))}>
            <Activity size={15} /> Surge · 15 SOS
          </button>
          <button disabled={busy} onClick={() => runAction(() => api.runOsScenario('critical'))}>
            <Siren size={15} /> Critical arrives
          </button>
          <button className="os-unsafe-button" disabled={busy} onClick={() => runAction(() => api.runOsScenario('unsafe'))}>
            <ShieldCheck size={15} /> Unsafe request
          </button>
        </div>
        <button className="os-reset-button" disabled={busy} onClick={() => runAction(() => api.resetOsMonitor())}>
          <RotateCcw size={15} /> Reset demo
        </button>
      </div>
      {error && <div className="os-error" role="alert"><AlertTriangle size={16} /> {error}</div>}

      {monitor.message && <div className="os-message" role="status">{monitor.message}</div>}

      <div className="os-metrics-grid">
        <article className="os-metric-card">
          <div className="os-metric-label">Bounded intake</div>
          <div className="os-metric-value">{monitor.queueCount}<span> / {monitor.queueCapacity}</span></div>
          <div className="os-progress-track"><div className="os-progress-value" style={{ width: `${fill}%` }} /></div>
          <div className="os-metric-foot">{monitor.queueCount >= monitor.queueCapacity ? 'Queue full' : `${monitor.queueCapacity - monitor.queueCount} queue slots available`}</div>
        </article>
        <article className="os-metric-card">
          <div className="os-metric-label">Command desk · CPU</div>
          <div className={`os-metric-value ${running ? 'os-running-text' : ''}`}>{running ? 'RUNNING' : 'IDLE'}</div>
          <div className="os-metric-foot">{running ? `${running.pid} · ${running.title}` : 'No process dispatched'}</div>
        </article>
        <article className="os-metric-card">
          <div className="os-metric-label">Avg. wait · FCFS</div>
          <div className="os-metric-value">{monitor.comparison.fcfsAverageWait}<span> min</span></div>
          <div className="os-metric-foot">Arrival order · same demo burst</div>
        </article>
        <article className="os-metric-card">
          <div className="os-metric-label">Avg. wait · Priority</div>
          <div className="os-metric-value os-priority-text">{monitor.comparison.priorityAverageWait}<span> min</span></div>
          <div className="os-metric-foot">Urgency order · tier-based service time</div>
        </article>
      </div>

      <div className="os-main-grid">
        <article className="os-panel os-scheduler-panel">
          <div className="os-panel-heading">
            <div><span className="os-panel-kicker">01 · SCHEDULER</span><h2>Ready queue</h2></div>
            <span className="os-panel-count">{monitor.readyQueue.length} READY</span>
          </div>
          {reviewing && !running && (
            <div className="os-review-card">
              <div className="os-review-head">
                <span className="os-review-label"><Play size={13} /> Selected for operator review</span>
                <span className={`os-tier ${tierClass[reviewing.priorityTier]}`}>{reviewing.priorityTier}</span>
              </div>
              <strong>{reviewing.title}</strong>
              <span className="os-mono">{reviewing.pid} · score {reviewing.effectiveScore}</span>
              <div className="os-review-footer">
                <span>{reviewing.affected} people · waited {formatWait(reviewing.waitTimeSeconds)}</span>
                <button
                  disabled={busy || !availableTeam}
                  onClick={() => runAction(() => api.dispatchOsProcess(reviewing.pid, availableTeam.id))}
                >
                  <Truck size={14} /> Verify &amp; dispatch
                </button>
              </div>
              {!availableTeam && <span className="os-inline-warning">Team locked: no demo team is available.</span>}
            </div>
          )}
          {running && (
            <div className="os-running-card">
              <div className="os-running-label"><span className="os-pulse-dot" /> PROCESS RUNNING</div>
              <strong>{running.title}</strong>
              <span className="os-mono">{running.pid} · resources reserved</span>
              <button disabled={busy} onClick={() => runAction(() => api.completeOsProcess(running.pid))}>
                <CheckCircle2 size={15} /> Mark done &amp; release resources
              </button>
            </div>
          )}
          <div className="os-queue-list">
            {monitor.readyQueue.map((pid, index) => {
              const process = processByPid.get(pid);
              if (!process) return null;
              return (
                <div className={`os-queue-row ${pid === monitor.reviewingPid && !running ? 'is-selected' : ''}`} key={pid}>
                  <span className="os-queue-position">{String(index + 1).padStart(2, '0')}</span>
                  <span className="os-queue-copy">
                    <strong>{process.title}</strong>
                    <span className="os-mono">{process.pid} · {process.severity} · {process.affected} affected</span>
                  </span>
                  <span className={`os-tier ${tierClass[process.priorityTier]}`}>{process.priorityTier}</span>
                  <span className="os-queue-wait">{formatWait(process.waitTimeSeconds)}</span>
                </div>
              );
            })}
            {!monitor.readyQueue.length && <div className="os-empty-state">No processes waiting in the ready queue.</div>}
          </div>
        </article>

        <article className="os-panel os-process-panel">
          <div className="os-panel-heading">
            <div><span className="os-panel-kicker">02 · PROCESS TABLE</span><h2>Process control blocks</h2></div>
            <span className="os-panel-count">{monitor.processes.length} PCBS</span>
          </div>
          <div className="os-table-scroll">
            <table className="os-table">
              <thead><tr><th>PID / Incident</th><th>State</th><th>Priority</th><th>Arrival</th><th>Wait</th><th>Max need</th><th>Need</th></tr></thead>
              <tbody>
                {monitor.processes.map(process => (
                  <tr key={process.pid}>
                    <td><strong>{process.title}</strong><span className="os-mono">{process.pid}</span></td>
                    <td><span className={`os-state os-state-${process.state.toLowerCase()}`}>{process.state}</span></td>
                    <td><span className={`os-tier ${tierClass[process.priorityTier]}`}>{process.priorityTier}</span><small>{process.effectiveScore}</small></td>
                    <td className="os-mono">{timeLabel(process.arrivalTime)}</td>
                    <td className="os-mono">{formatWait(process.waitTimeSeconds)}</td>
                    <td>{compactResources(process.maximum)}</td>
                    <td>{compactResources(process.need)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </article>
      </div>

      <div className="os-bottom-grid">
        <article className="os-panel">
          <div className="os-panel-heading">
            <div><span className="os-panel-kicker">03 · RESOURCE ALLOCATION</span><h2>Banker’s safety check</h2></div>
            {monitor.banker.lastRequest && (
              <span className={`os-safe-badge ${monitor.banker.lastRequest.granted ? 'is-safe' : 'is-denied'}`}>
                {monitor.banker.lastRequest.granted ? 'GRANTED' : 'DENIED'}
              </span>
            )}
          </div>
          <div className="os-resource-cards">
            {Object.entries(monitor.banker.total).map(([key, total]) => (
              <div className="os-resource-card" key={key}>
                <span>{monitor.banker.resourceNames[key]}</span>
                <strong>{monitor.banker.available[key]}<small> / {total}</small></strong>
                <span>available / total</span>
              </div>
            ))}
          </div>
          <div className="os-table-scroll">
            <table className="os-table os-banker-table">
              <thead><tr><th>Process</th><th>Maximum</th><th>Allocation</th><th>Need</th></tr></thead>
              <tbody>
                {monitor.banker.processes.map(process => (
                  <tr key={process.pid}>
                    <td className="os-mono">{process.pid}</td>
                    <td>{compactResources(process.maximum)}</td>
                    <td>{compactResources(process.allocation)}</td>
                    <td>{compactResources(process.need)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="os-safe-sequence">
            <span>Safe sequence</span>
            <strong>{monitor.banker.safeSequence.length ? monitor.banker.safeSequence.join(' → ') : 'No safe sequence'}</strong>
          </div>
          {monitor.banker.lastRequest && (
            <div className={`os-request-result ${monitor.banker.lastRequest.granted ? 'is-safe' : 'is-denied'}`}>
              <ShieldCheck size={16} />
              <div><strong>{monitor.banker.lastRequest.pid} · {compactResources(monitor.banker.lastRequest.request)}</strong><span>{monitor.banker.lastRequest.reason}</span></div>
            </div>
          )}
        </article>

        <article className="os-panel os-events-panel">
          <div className="os-panel-heading">
            <div><span className="os-panel-kicker">04 · IPC / AUDIT</span><h2>OS event log</h2></div>
            <span className="os-panel-count">{monitor.events.length} EVENTS</span>
          </div>
          <div className="os-event-list">
            {monitor.events.map(event => (
              <div className={`os-event os-event-${event.type.toLowerCase()}`} key={event.id}>
                <span className="os-event-icon">{eventIcons[event.type] || <CircleDot size={15} />}</span>
                <div><strong>{event.type.replaceAll('_', ' ')}</strong><p>{event.message}</p></div>
                <time>{timeLabel(event.timestamp)}</time>
              </div>
            ))}
          </div>
        </article>
      </div>
    </section>
  );
};

export default OSMonitor;
