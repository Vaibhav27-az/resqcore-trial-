# ResQCore Unified Emergency Response Platform Architecture

This unified ecosystem integrates and connects all 3 applications in **PBL PHASE 2**:
1. **Command Center Web Application** (`CC`) — React + Vite (Port `5173`)
2. **Citizen Emergency & SOS Mobile/Web App** (`RescueCoreF`) — Flutter (Port `8081` & Android APK)
3. **Tactical Operations Field Mobile/Web App** (`RescueApp`) — Flutter (Port `8082` & Android APK)
4. **Unified Emergency Backend Hub** (`backend`) — Node.js REST API + WebSockets (Port `5000`)

---

## 🚀 Running Applications Separately or Together (Alag Alag / Ek Saath)

You can run each application **completely separately** on its own dedicated local server, OR run **all of them together** with 1 click!

### 🌟 Option A: Run All 4 Applications Connected Together (1-Click)
Double-click:
```cmd
start_all.bat
```
This automatically launches all 4 servers in separate windows and opens all 4 tabs in your browser:
- **Command Center:** [http://localhost:5173](http://localhost:5173)
- **Citizen App:** [http://localhost:8081](http://localhost:8081)
- **Tactical Ops:** [http://localhost:8082](http://localhost:8082)
- **Backend Hub:** [http://localhost:5000](http://localhost:5000)

---

### 💻 Option B: Run Each Application Separately (Alag Alag Local Server)

| Application | Dedicated Port | 1-Click Batch File | Manual Terminal Command |
| :--- | :--- | :--- | :--- |
| **Backend Engine & Hub** | `http://localhost:5000` | `start_backend.bat` | `cd backend && node server.js` |
| **Command Center (Web)** | `http://localhost:5173` | `start_command_center.bat` | `cd CC && npm.cmd run dev` |
| **Citizen App (RescueCoreF)** | `http://localhost:8081` | `start_citizen_app.bat` | `cd RescueCoreF && node serve.js` |
| **Tactical Ops (RescueApp)** | `http://localhost:8082` | `start_tactical_app.bat` | `cd RescueApp && node serve.js` |

> [!TIP]
> **Flutter CLI Mode (Optional):**
> If you prefer running via Flutter debug mode in Chrome:
> - Citizen: `cd RescueCoreF && flutter run -d chrome --web-port 8081`
> - Tactical: `cd RescueApp && flutter run -d chrome --web-port 8082`
>
> If you want to run on Android phone / emulator:
> - Run `flutter run` inside `RescueCoreF` or `RescueApp` with your emulator/phone connected!

---

## 🏛️ System Architecture Overview

```
                      +---------------------------------------+
                      |   Command Center Web App (CC)        |
                      |   Port: 5173                         |
                      |   - Operator Triage & Dispatch        |
                      |   - Live Tactical Map & CCTV         |
                      |   - Broadcast Alerts & Verification  |
                      +-------------------+-------------------+
                                          |
                                          | REST API + WebSockets
                                          v
+---------------------------------------------------------------------------------+
|                    Unified Emergency Response Backend (Node.js)                |
|                    Host: 0.0.0.0:5000 | Path: /api | WS: /ws                    |
|                                                                                 |
|  - Real-Time Incident State Engine (Pending -> Verified -> On Scene -> Resolved)|
|  - Fleet Roster & GPS Telemetry Sync                                            |
|  - Emergency Broadcast Distribution                                            |
|  - Channel-based Tactical Radio Communications                                 |
|  - Dedicated Local Web Port for Citizen App (:8081)                             |
|  - Dedicated Local Web Port for Tactical Field Ops (:8082)                     |
|  - PostgreSQL persistence for incidents, teams, alerts, and messages           |
+---------------------------------------------------------------------------------+
          ^                                                             ^
          | REST API + Polling Sync                                     | REST API + Polling Sync
          |                                                             |
+---------+--------------------------+        +-------------------------+---------+
|   Citizen App (RescueCoreF)        |        | Tactical Field App (RescueApp)    |
|   Port: 8081                       |        | Port: 8082                        |
|   - 1-Click Instant SOS Beacon     |        | - Tactical Incident List          |
|   - Emergency Report Submission    |        | - Mission Dispatch Acceptance     |
|   - Live Request Status Timeline   |        | - Status Updates (On Scene/Done)  |
|   - Disaster Hazard Alerts         |        | - Tactical Radio / Field Chat     |
+------------------------------------+        +-----------------------------------+
```

---

## 📱 Mobile APK Locations
Pre-built release APKs for mobile devices:
- **Citizen SOS App:** `d:\RescueCoreF\build\app\outputs\flutter-apk\app-release.apk`
- **Tactical Ops App:** `d:\PBL PHASE 2\RescueApp\RescueTeam-TacticalOps-Release.apk`

---

## 📡 REST API Specifications

| Method | Endpoint | Description | Consuming Apps |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/health` | System status, version, uptime | All |
| `GET` | `/api/stats` | Active incidents, affected civilians, teams deployed | CC / Dashboard |
| `GET` | `/api/os-monitor` | Read the isolated seeded OS simulation | Command Center |
| `POST` | `/api/os-monitor/scenarios/:scenario` | Run `surge`, `critical`, or `unsafe` demo | Command Center |
| `POST` | `/api/os-monitor/reset` | Reset the OS simulation to seeded data | Command Center |
| `POST` | `/api/os-monitor/incidents` | Add a validated SOS to the demo intake queue | Command Center |
| `POST` | `/api/os-monitor/dispatch/:pid` | Banker-check, lock a demo team, and dispatch a PCB | Command Center |
| `POST` | `/api/os-monitor/complete/:pid` | Terminate the running demo PCB and release resources | Command Center |
| `GET` | `/api/incidents` | Fetch incidents (supports `status`, `severity`, `category` filters) | All |
| `POST` | `/api/incidents` | Submit SOS or new incident report | Citizen App / RescueApp |
| `GET` | `/api/incidents/:id` | Fetch incident details | All |
| `PATCH` | `/api/incidents/:id/verify` | Command Center verifies incident and dispatches unit | Command Center |
| `POST` | `/api/incidents/:id/assign` | Assign specific rescue team with ETA | Command Center |
| `PATCH` | `/api/incidents/:id/status` | Update field status (`On site`, `Responding`, `Resolved`) | RescueApp / CC |
| `GET` | `/api/teams` | Get response teams roster with live coordinates | CC / RescueApp |
| `PATCH` | `/api/teams/:id` | Update team GPS location or operational status | RescueApp |
| `GET` | `/api/alerts` | Get disaster alerts and broadcast advisories | All |
| `POST` | `/api/alerts` | Command Center dispatches emergency broadcast | Command Center |
| `GET` | `/api/messages/:channel` | Fetch chat/radio communications for channel | CC / RescueApp |
| `POST` | `/api/messages/:channel` | Send chat/radio message | CC / RescueApp |

---

## PostgreSQL Setup and DBMS Demonstration

The backend uses PostgreSQL as its persistent store. Existing data in `backend/data/store.json` is used only to seed database rows that do not already exist; new changes are written to PostgreSQL.

1. Install dependencies from the `backend` folder with `npm install`.
2. Copy `backend/.env.example` to `backend/.env` and enter your local PostgreSQL connection details. Keep `.env` private.
3. Confirm the connection with `npm run test:db`.
4. Start the backend with `npm start`. At startup it creates or updates the required schema, imports missing seed records, and loads data from PostgreSQL. The backend will not accept API traffic if database initialization fails.
5. Submit an SOS from the Citizen app, verify it in the Command Center, and update it from the Tactical app. Refresh the PostgreSQL tables in pgAdmin to see the changes.

The `incidents`, `teams`, `assignments`, and `incident_status_history` tables model the dispatch workflow. Alerts and chat messages are also persisted in PostgreSQL. Database transactions keep each saved snapshot consistent, status changes are recorded in the history table, and a partial unique index prevents one team from having multiple active assignments.

Useful pgAdmin queries:

```sql
SELECT id, title, severity, status
FROM incidents
ORDER BY created_at DESC;

SELECT i.id, i.title, t.name AS team, a.eta
FROM assignments a
JOIN incidents i ON i.id = a.incident_id
JOIN teams t ON t.id = a.team_id
WHERE a.released_at IS NULL;

SELECT incident_id, old_status, new_status, changed_at, changed_by
FROM incident_status_history
ORDER BY changed_at DESC;
```

---

## ⚡ WebSocket Real-Time Events (`ws://<host>:5000/ws`)

Clients receive instantaneous push notifications:
- `INCIDENT_CREATED`: Triggered when Citizen triggers 1-touch SOS or submits incident.
- `INCIDENT_VERIFIED`: Triggered when Command Center operator verifies the incident.
- `INCIDENT_ASSIGNED`: Triggered when Command Center assigns a team (e.g. Bravo 02).
- `INCIDENT_STATUS_UPDATED`: Triggered when field operatives reach the scene or resolve the crisis.
- `ALERT_BROADCAST`: Triggered when Command Center issues an urgent broadcast.
- `MESSAGE_SENT`: Triggered when communications are exchanged on any channel.
- `OS_MONITOR_UPDATED`: Triggered by changes to the isolated OS monitor simulation.

---

## OS Monitor (Seeded Demo)

Open **OS Monitor** in the Command Centre to explore the four OS concepts in a self-contained simulator. The simulated command desk is a single CPU: READY PCBs are ordered by a severity/category/affected-people score, and aging raises the score of waiting work. A more urgent SOS can replace the current review candidate, but a RUNNING PCB is not preempted. The FCFS/priority wait-time comparison uses the same synthetic burst and tier-based service durations.

The demo intake queue has a fixed capacity of 10. When full, a Critical SOS can replace the least urgent queued request; other requests receive a queue-full/retry response. Demo resource claims use ambulances, boats, medical kits, and food packs. Dispatch checks the Banker safe sequence before reserving resources; completion terminates the PCB and releases them. Team assignment uses an application-level lock, while the existing PostgreSQL partial unique index remains the database-level constraint for live assignments.

The three scenario buttons operate only on seeded/demo records. The OS simulator is in memory and does not read or mutate `/api/incidents`, the live teams table, or PostgreSQL. Its REST changes are also published as `OS_MONITOR_UPDATED` WebSocket events. The OS simulation tests can be run from `backend` with `npm test`.

When opening the Command Centre from another device or a virtual/LAN server, keep the backend reachable on port `5000` at the same host. A loopback `VITE_BACKEND_URL` (such as `http://localhost:5000`) is automatically adjusted to the host serving the page; set `VITE_BACKEND_URL` explicitly when the backend uses a different host or port. If the backend is stopped or unreachable, start it with `start_backend.bat` before opening the monitor.
