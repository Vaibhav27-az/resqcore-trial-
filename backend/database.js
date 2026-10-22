require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
});

pool.on('error', (error) => {
  console.error('[PostgreSQL] Unexpected idle client error:', error.message);
});

async function ensureSchema() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS incidents (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      category TEXT,
      description TEXT,
      location TEXT,
      severity TEXT,
      status TEXT NOT NULL,
      latitude DOUBLE PRECISION,
      longitude DOUBLE PRECISION,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      data JSONB NOT NULL DEFAULT '{}'::jsonb
    );
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS title TEXT;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS category TEXT;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS description TEXT;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS location TEXT;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS severity TEXT;
    ALTER TABLE incidents ALTER COLUMN severity TYPE TEXT USING severity::text;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS status TEXT;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
    ALTER TABLE incidents ADD COLUMN IF NOT EXISTS data JSONB NOT NULL DEFAULT '{}'::jsonb;

    CREATE TABLE IF NOT EXISTS teams (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      status TEXT NOT NULL DEFAULT 'Available',
      latitude DOUBLE PRECISION,
      longitude DOUBLE PRECISION,
      responders INTEGER,
      task TEXT,
      data JSONB NOT NULL DEFAULT '{}'::jsonb
    );
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS name TEXT;
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'Available';
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION;
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS responders INTEGER;
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS task TEXT;
    ALTER TABLE teams ADD COLUMN IF NOT EXISTS data JSONB NOT NULL DEFAULT '{}'::jsonb;

    CREATE TABLE IF NOT EXISTS assignments (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      incident_id TEXT NOT NULL REFERENCES incidents(id),
      team_id TEXT NOT NULL REFERENCES teams(id),
      assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      eta TEXT,
      released_at TIMESTAMPTZ
    );
    ALTER TABLE assignments ADD COLUMN IF NOT EXISTS eta TEXT;
    ALTER TABLE assignments ADD COLUMN IF NOT EXISTS released_at TIMESTAMPTZ;
    CREATE UNIQUE INDEX IF NOT EXISTS one_active_assignment_per_team
      ON assignments (team_id) WHERE released_at IS NULL;

    CREATE TABLE IF NOT EXISTS incident_status_history (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      incident_id TEXT NOT NULL REFERENCES incidents(id),
      old_status TEXT,
      new_status TEXT NOT NULL,
      changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      changed_by TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS alerts (
      id TEXT PRIMARY KEY,
      data JSONB NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS messages (
      channel TEXT NOT NULL,
      id TEXT NOT NULL,
      data JSONB NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      PRIMARY KEY (channel, id)
    );

    CREATE INDEX IF NOT EXISTS incidents_status_severity_idx
      ON incidents (status, severity);
    CREATE INDEX IF NOT EXISTS incident_history_incident_time_idx
      ON incident_status_history (incident_id, changed_at);

    DO $migration$
    DECLARE
      status_constraint RECORD;
    BEGIN
      FOR status_constraint IN
        SELECT conname
        FROM pg_constraint
        WHERE conrelid = 'incidents'::regclass
          AND contype = 'c'
          AND pg_get_constraintdef(oid) ILIKE '%status%'
      LOOP
        EXECUTE format('ALTER TABLE incidents DROP CONSTRAINT %I', status_constraint.conname);
      END LOOP;

      ALTER TABLE incidents
        ADD CONSTRAINT incidents_status_allowed
        CHECK (status IN ('Unverified', 'Verified', 'Responding', 'Escalated', 'On site', 'Monitoring', 'Resolved'));
    END;
    $migration$;
  `);
}

function incidentColumns(incident) {
  const coordinates = incident.coordinates || {};
  return [
    incident.id,
    incident.title || 'Emergency',
    incident.category || incident.type || null,
    incident.description || null,
    incident.location || incident.fullAddress || null,
    incident.severity || null,
    incident.status || 'Unverified',
    coordinates.lat ?? null,
    coordinates.lng ?? null,
    incident.createdAt || incident.created_at || new Date().toISOString(),
    JSON.stringify(incident)
  ];
}

function teamColumns(team) {
  return [
    team.id,
    team.name || team.id,
    team.status || 'Available',
    team.latitude ?? null,
    team.longitude ?? null,
    team.responders ?? null,
    team.task || null,
    JSON.stringify(team)
  ];
}

async function upsertIncident(client, incident, seedOnly = false) {
  const columns = incidentColumns(incident);
  const conflict = seedOnly
    ? `DO NOTHING`
    : `DO UPDATE SET
        title = EXCLUDED.title,
        category = EXCLUDED.category,
        description = EXCLUDED.description,
        location = EXCLUDED.location,
        severity = EXCLUDED.severity,
        status = EXCLUDED.status,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        created_at = EXCLUDED.created_at,
        data = EXCLUDED.data`;
  await client.query(`
    INSERT INTO incidents
      (id, title, category, description, location, severity, status, latitude, longitude, created_at, data)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11::jsonb)
    ON CONFLICT (id) ${conflict}
  `, columns);
}

async function upsertTeam(client, team, seedOnly = false) {
  const columns = teamColumns(team);
  const conflict = seedOnly
    ? `DO NOTHING`
    : `DO UPDATE SET
        name = EXCLUDED.name,
        status = EXCLUDED.status,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        responders = EXCLUDED.responders,
        task = EXCLUDED.task,
        data = EXCLUDED.data`;
  await client.query(`
    INSERT INTO teams (id, name, status, latitude, longitude, responders, task, data)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8::jsonb)
    ON CONFLICT (id) ${conflict}
  `, columns);
}

async function seedSnapshot(snapshot) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    for (const team of snapshot.teams) {
      await upsertTeam(client, team, true);
    }
    for (const incident of snapshot.incidents) {
      await upsertIncident(client, incident, true);
    }
    for (const alert of snapshot.alerts) {
      await client.query(
        `INSERT INTO alerts (id, data, created_at)
         VALUES ($1, $2::jsonb, COALESCE($3::timestamptz, NOW()))
         ON CONFLICT (id) DO NOTHING`,
        [alert.id, JSON.stringify(alert), alert.createdAt || null]
      );
    }
    for (const [channel, channelMessages] of Object.entries(snapshot.messages)) {
      for (const message of channelMessages) {
        await client.query(
          `INSERT INTO messages (channel, id, data, created_at)
           VALUES ($1, $2, $3::jsonb, COALESCE($4::timestamptz, NOW()))
           ON CONFLICT (channel, id) DO NOTHING`,
          [channel, message.id, JSON.stringify(message), message.createdAt || null]
        );
      }
    }
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}

function withDatabaseFields(row, bootstrapItem, fields) {
  const payload = row.data && Object.keys(row.data).length ? row.data : (bootstrapItem || {});
  return { ...payload, ...fields(row) };
}

async function loadSnapshot(bootstrap) {
  const [incidentsResult, teamsResult, alertsResult, messagesResult] = await Promise.all([
    pool.query('SELECT id, title, category, description, location, severity, status, latitude, longitude, created_at, data FROM incidents ORDER BY created_at DESC'),
    pool.query(`
      SELECT t.id, t.name, t.status, t.latitude, t.longitude, t.responders, t.task, t.data,
             active.incident_id AS active_incident_id,
             active.incident_title AS active_incident_title,
             active.eta AS active_eta
      FROM teams t
      LEFT JOIN LATERAL (
        SELECT a.incident_id, i.data->>'title' AS incident_title, a.eta
        FROM assignments a
        JOIN incidents i ON i.id = a.incident_id
        WHERE a.team_id = t.id AND a.released_at IS NULL
        ORDER BY a.assigned_at DESC
        LIMIT 1
      ) active ON TRUE
      ORDER BY t.id
    `),
    pool.query('SELECT id, data FROM alerts ORDER BY created_at DESC'),
    pool.query('SELECT channel, id, data FROM messages ORDER BY created_at')
  ]);

  const bootstrapIncidents = new Map(bootstrap.incidents.map(item => [item.id, item]));
  const bootstrapTeams = new Map(bootstrap.teams.map(item => [item.id, item]));

  const incidents = incidentsResult.rows.map(row => withDatabaseFields(
    row,
    bootstrapIncidents.get(row.id),
    item => ({
      id: item.id,
      title: item.title,
      category: item.category,
      description: item.description,
      location: item.location,
      severity: item.severity,
      status: item.status,
      createdAt: item.created_at
    })
  ));
  const teams = teamsResult.rows.map(row => withDatabaseFields(
    row,
    bootstrapTeams.get(row.id),
    item => ({
      id: item.id,
      name: item.name,
      status: item.status,
      latitude: item.latitude,
      longitude: item.longitude,
      responders: item.responders,
      task: item.active_incident_id
        ? `${item.active_incident_id} · ${item.active_incident_title || 'Active response'}`
        : item.task,
      eta: item.active_eta || row.data?.eta,
      ...(item.active_incident_id ? { status: 'Deployed' } : {})
    })
  ));
  const messages = {};
  for (const row of messagesResult.rows) {
    if (!messages[row.channel]) messages[row.channel] = [];
    messages[row.channel].push(row.data);
  }

  return {
    incidents,
    teams,
    alerts: alertsResult.rows.map(row => row.data),
    messages
  };
}

async function persistSnapshotTransaction(snapshot, reconcileAssignments = true) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    for (const team of snapshot.teams) {
      await upsertTeam(client, team);
    }
    for (const incident of snapshot.incidents) {
      const previous = await client.query(
        'SELECT status, data FROM incidents WHERE id = $1 FOR UPDATE',
        [incident.id]
      );
      await upsertIncident(client, incident);

      const oldStatus = previous.rows[0]?.status;
      const oldAssignedTeam = previous.rows[0]?.data?.assignedTeam;
      if (oldStatus !== incident.status) {
        await client.query(
          `INSERT INTO incident_status_history (incident_id, old_status, new_status, changed_by)
           VALUES ($1, $2, $3, $4)`,
          [incident.id, oldStatus || null, incident.status || 'Unverified', 'ResQCore']
        );
      }

      const team = snapshot.teams.find(item =>
        item.name === incident.assignedTeam || item.id === incident.assignedTeam
      );
      const activeAssignment = await client.query(
        'SELECT id, team_id FROM assignments WHERE incident_id = $1 AND released_at IS NULL FOR UPDATE',
        [incident.id]
      );
      const assignmentChanged = oldStatus !== incident.status ||
        oldAssignedTeam !== incident.assignedTeam;

      if (!reconcileAssignments || !assignmentChanged) {
        continue;
      }

      if (!team || !incident.assignedTeam || incident.assignedTeam === 'None' || incident.status === 'Resolved') {
        if (activeAssignment.rowCount) {
          await client.query(
            'UPDATE assignments SET released_at = NOW() WHERE id = $1',
            [activeAssignment.rows[0].id]
          );
        }
      } else if (!activeAssignment.rowCount) {
        await client.query(
          'INSERT INTO assignments (incident_id, team_id, eta) VALUES ($1, $2, $3)',
          [incident.id, team.id, incident.eta || null]
        );
      } else if (activeAssignment.rows[0].team_id !== team.id) {
        await client.query(
          'UPDATE assignments SET released_at = NOW() WHERE id = $1',
          [activeAssignment.rows[0].id]
        );
        await client.query(
          'INSERT INTO assignments (incident_id, team_id, eta) VALUES ($1, $2, $3)',
          [incident.id, team.id, incident.eta || null]
        );
      }
    }

    for (const alert of snapshot.alerts) {
      await client.query(
        `INSERT INTO alerts (id, data, created_at)
         VALUES ($1, $2::jsonb, COALESCE($3::timestamptz, NOW()))
         ON CONFLICT (id) DO UPDATE SET data = EXCLUDED.data`,
        [alert.id, JSON.stringify(alert), alert.createdAt || null]
      );
    }
    for (const [channel, channelMessages] of Object.entries(snapshot.messages)) {
      for (const message of channelMessages) {
        await client.query(
          `INSERT INTO messages (channel, id, data, created_at)
           VALUES ($1, $2, $3::jsonb, COALESCE($4::timestamptz, NOW()))
           ON CONFLICT (channel, id) DO UPDATE SET data = EXCLUDED.data`,
          [channel, message.id, JSON.stringify(message), message.createdAt || null]
        );
      }
    }
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}

let saveQueue = Promise.resolve();

function persistSnapshot(snapshot, reconcileAssignments = true) {
  const operation = saveQueue.then(() =>
    persistSnapshotTransaction(snapshot, reconcileAssignments)
  );
  saveQueue = operation.catch(() => {});
  return operation;
}

async function initialize(store) {
  await ensureSchema();
  const bootstrap = {
    incidents: [...store.incidents],
    teams: [...store.teams],
    alerts: [...store.alerts],
    messages: JSON.parse(JSON.stringify(store.messages))
  };
  await seedSnapshot(bootstrap);
  const snapshot = await loadSnapshot(bootstrap);
  store.incidents = snapshot.incidents;
  store.teams = snapshot.teams;
  store.alerts = snapshot.alerts;
  store.messages = snapshot.messages;
  await persistSnapshot(snapshot, false);
  console.log('[PostgreSQL] Connected; ResQCore data loaded.');
}

async function close() {
  await pool.end();
}

module.exports = { initialize, persistSnapshot, close };
