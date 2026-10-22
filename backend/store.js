// Unified ResQCore / Tactical Ops / Citizen Emergency Response Store
const fs = require('fs');
const path = require('path');
const database = require('./database');

const DATA_FILE = path.join(__dirname, 'data', 'store.json');

const defaultIncidents = [
  {
    id: "INC-2048",
    title: "Flash flooding",
    category: "flood",
    type: "flood",
    location: "Fort Kochi · Ernakulam, Kerala",
    shortLocation: "Fort Kochi",
    area: "Fort Kochi",
    fullAddress: "18, KB Jacob Road, Fort Kochi, Ernakulam, Kerala 682001",
    affected: 320,
    affectedCount: 320,
    time: "14:32 IST",
    timestamp: "12 Oct 2026 · 02:32 PM",
    timeLabel: "Today · 14:32",
    timeAgo: "Now",
    severity: "High",
    status: "Unverified", // 'Unverified' | 'Verified' | 'Responding' | 'Escalated' | 'On site' | 'Monitoring' | 'Resolved'
    citizenStatus: "pending", // 'pending' | 'assigned' | 'inProgress' | 'resolved'
    responseSummary: "Awaiting verification",
    responseDetail: "Verify to respond",
    dispatchUpdate: "Awaiting review by the response desk",
    description: "Rapid water rise near the ferry terminal. Families stranded; evacuation required.",
    contactNumber: "+91 98470 21836",
    fieldReport: "Field report · FK-01 camera confirmed",
    coordinates: {
      lat: 9.9658,
      lng: 76.2421,
      latText: "9.9658° N",
      lngText: "76.2421° E",
      x: 34,
      y: 58
    },
    assignedTeam: null,
    teamAssigned: "None",
    eta: "Awaiting dispatch",
    photoCount: 1,
    image: "/assets/flood.png",
    photoAssetPath: "assets/images/scenarios/flood_river_boat.png"
  },
  {
    id: "INC-2047",
    title: "Bridge collapse",
    category: "earthquake",
    type: "other",
    location: "Mattancherry · Ernakulam, Kerala",
    shortLocation: "Mattancherry",
    area: "Mattancherry",
    fullAddress: "Synagogue Lane, Mattancherry, Kochi 682002",
    affected: 85,
    affectedCount: 85,
    time: "14:25 IST",
    timestamp: "12 Oct 2026 · 02:25 PM",
    timeLabel: "Today · 14:25",
    timeAgo: "7m",
    severity: "High",
    status: "Escalated",
    citizenStatus: "assigned",
    responseSummary: "No team available",
    responseDetail: "District notified",
    dispatchUpdate: "District SAR response notified · ETA 25 min",
    description: "Bridge access cut off. Technical rescue assistance requested for the eastern bank.",
    contactNumber: "+91 94471 88204",
    fieldReport: "Field report · MC-02 camera confirmed",
    escalationNote: "District response notified at 14:30 IST. Awaiting technical rescue support.",
    coordinates: {
      lat: 9.9587,
      lng: 76.2594,
      latText: "9.9587° N",
      lngText: "76.2594° E",
      x: 40,
      y: 73
    },
    assignedTeam: "Delta 04",
    teamAssigned: "Delta 04",
    eta: "ETA 25 min",
    photoCount: 1,
    image: "/assets/bridge_cctv.png",
    photoAssetPath: "assets/images/scenarios/earthquake_rubble_collapse.png"
  },
  {
    id: "INC-2046",
    title: "Coastal evacuation",
    category: "flood",
    type: "flood",
    location: "Vypin · Ernakulam, Kerala",
    shortLocation: "Vypin",
    area: "Vypin",
    fullAddress: "Vypeen Coast Road, Sector 3, Ernakulam",
    affected: 210,
    affectedCount: 210,
    time: "14:18 IST",
    timestamp: "12 Oct 2026 · 02:18 PM",
    timeLabel: "Today · 14:18",
    timeAgo: "14m",
    severity: "High",
    status: "Responding",
    citizenStatus: "inProgress",
    responseSummary: "Alpha 01",
    responseDetail: "ETA 8 min",
    dispatchUpdate: "Alpha 01 is on the way · ETA 8 min",
    description: "High tidal surge threatening coastal settlement. Evacuation of zone 2 in progress.",
    contactNumber: "+91 98470 21836",
    fieldReport: "Field report · VP-03 camera confirmed",
    coordinates: {
      lat: 9.9920,
      lng: 76.2300,
      latText: "9.9920° N",
      lngText: "76.2300° E",
      x: 36,
      y: 37
    },
    assignedTeam: "Alpha 01",
    teamAssigned: "Alpha 01",
    eta: "ETA 8 min",
    photoCount: 1,
    image: "/assets/coastal_cctv.png",
    photoAssetPath: "assets/images/scenarios/flood_response_street.png"
  },
  {
    id: "INC-2045",
    title: "Residential fire",
    category: "fire",
    type: "fire",
    location: "Edappally · Ernakulam, Kerala",
    shortLocation: "Edappally",
    area: "Edappally",
    fullAddress: "Toll Junction, Edappally North, Kochi",
    affected: 40,
    affectedCount: 40,
    time: "14:05 IST",
    timestamp: "12 Oct 2026 · 02:05 PM",
    timeLabel: "Today · 14:05",
    timeAgo: "27m",
    severity: "Medium",
    status: "Responding",
    citizenStatus: "inProgress",
    responseSummary: "Delta 04",
    responseDetail: "ETA 16 min",
    dispatchUpdate: "Delta 04 deployed with fire tender",
    description: "Multi-family residential complex electrical fire. 2 units evacuated; no casualties reported.",
    contactNumber: "+91 98110 44201",
    fieldReport: "Field report · Edappally Station",
    coordinates: {
      lat: 10.0261,
      lng: 76.3089,
      latText: "10.0261° N",
      lngText: "76.3089° E",
      x: 58,
      y: 42
    },
    assignedTeam: "Delta 04",
    teamAssigned: "Delta 04",
    eta: "ETA 16 min",
    photoCount: 1,
    image: "/assets/satellite.png",
    photoAssetPath: "assets/images/scenarios/highway_ambulance_storm.png"
  },
  {
    id: "INC-2044",
    title: "Road inundation",
    category: "flood",
    type: "flood",
    location: "Thevara · Ernakulam, Kerala",
    shortLocation: "Thevara",
    area: "Thevara",
    fullAddress: "Ferry Road, Thevara Waterfront, Kochi",
    affected: 120,
    affectedCount: 120,
    time: "13:50 IST",
    timestamp: "12 Oct 2026 · 01:50 PM",
    timeLabel: "Today · 13:50",
    timeAgo: "42m",
    severity: "Medium",
    status: "On site",
    citizenStatus: "inProgress",
    responseSummary: "Echo 05",
    responseDetail: "On site",
    dispatchUpdate: "Echo 05 on scene conducting safe evacuation",
    description: "Backwater inundation across main arterial link. Water depth 0.9m; vehicle access closed.",
    contactNumber: "+91 98470 21836",
    fieldReport: "Field report · Traffic camera T-04",
    coordinates: {
      lat: 9.9328,
      lng: 76.2974,
      latText: "9.9328° N",
      lngText: "76.2974° E",
      x: 50,
      y: 78
    },
    assignedTeam: "Echo 05",
    teamAssigned: "Echo 05",
    eta: "On site",
    photoCount: 1,
    image: "/assets/satellite.png",
    photoAssetPath: "assets/images/scenarios/village_flood_evac.png"
  },
  {
    id: "INC-2043",
    title: "Shelter check-in",
    category: "medical",
    type: "other",
    location: "Kakkanad · Ernakulam, Kerala",
    shortLocation: "Kakkanad",
    area: "Kakkanad",
    fullAddress: "Relief Camp 4, Civil Station Road, Kakkanad",
    affected: 160,
    affectedCount: 160,
    time: "13:45 IST",
    timestamp: "12 Oct 2026 · 01:45 PM",
    timeLabel: "Today · 13:45",
    timeAgo: "47m",
    severity: "Info",
    status: "Monitoring",
    citizenStatus: "resolved",
    responseSummary: "Foxtrot 06",
    responseDetail: "On site",
    dispatchUpdate: "Shelter operating at capacity; medical triage active",
    description: "Relief camp 4 reached 80% capacity. Medical supplies and dry ration kit verification.",
    contactNumber: "+91 94471 88204",
    fieldReport: "Field report · Relief coordinator verified",
    coordinates: {
      lat: 10.0150,
      lng: 76.3400,
      latText: "10.0150° N",
      lngText: "76.3400° E",
      x: 61,
      y: 62
    },
    assignedTeam: "Foxtrot 06",
    teamAssigned: "Foxtrot 06",
    eta: "On site",
    photoCount: 1,
    image: "/assets/satellite.png",
    photoAssetPath: "assets/images/scenarios/helicopter_mountain_alpine.png"
  }
];

const defaultTeams = [
  {
    id: "alpha-01",
    name: "Alpha 01",
    callsign: "STORM-LEAD",
    specialization: "Swiftwater rescue",
    type: "Marine & Swiftwater Unit",
    status: "Deployed",
    responders: 10,
    lead: "R. Menon",
    commanderName: "Capt. R. Menon",
    commanderPhone: "+91 98470 21990",
    staging: "Vypin coastal zone",
    task: "INC-2046 · Coastal evacuation",
    eta: "ETA 8 min",
    equipment: "3 Zodiac boats · Sonar scanner",
    latitude: 9.9920,
    longitude: 76.2300,
    gpsCoords: "9.9920° N, 76.2300° E",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "bravo-02",
    name: "Bravo 02",
    callsign: "RIVER-RUNNER",
    specialization: "Water rescue",
    type: "Marine / Inundation Unit",
    status: "Available",
    responders: 8,
    lead: "S. Nair",
    commanderName: "Cmdr. S. Nair",
    commanderPhone: "+91 98470 21832",
    staging: "Fort Kochi staging area",
    readiness: "Ready for deployment",
    equipment: "Boat equipped · Radio connected",
    latitude: 9.9658,
    longitude: 76.2415,
    gpsCoords: "9.9658° N, 76.2415° E",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "charlie-03",
    name: "Charlie 03",
    callsign: "MEDIC-1",
    specialization: "Medical response",
    type: "Mobile Triage Unit",
    status: "Available",
    responders: 6,
    lead: "P. Thomas",
    commanderName: "Dr. P. Thomas",
    commanderPhone: "+91 98470 21855",
    staging: "Ernakulam relief hub",
    readiness: "Ready for deployment",
    equipment: "Medical kits stocked · Portable oxygen",
    latitude: 9.9702,
    longitude: 76.2798,
    gpsCoords: "9.9702° N, 76.2798° E",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "delta-04",
    name: "Delta 04",
    callsign: "EXTRICATION",
    specialization: "Fire & rescue",
    type: "Heavy Rescue & Roadway Clearing",
    status: "Deployed",
    responders: 9,
    lead: "A. Joseph",
    commanderName: "Lt. A. Joseph",
    commanderPhone: "+91 98470 21888",
    staging: "Edappally",
    task: "INC-2045 · Residential fire",
    eta: "ETA 16 min",
    latitude: 10.0261,
    longitude: 76.3089,
    gpsCoords: "10.0261° N, 76.3089° E",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "echo-05",
    name: "Echo 05",
    callsign: "HIGH-WATER",
    specialization: "Evacuation support",
    type: "High-Clearance Transport Unit",
    status: "On site",
    responders: 8,
    lead: "M. Pillai",
    commanderName: "Sub. M. Pillai",
    commanderPhone: "+91 98470 21911",
    staging: "Thevara",
    task: "INC-2044 · Road inundation",
    note: "120 people · Evacuation underway",
    latitude: 9.9328,
    longitude: 76.2974,
    gpsCoords: "9.9328° N, 76.2974° E",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "foxtrot-06",
    name: "Foxtrot 06",
    callsign: "LOGISTICS-BASE",
    specialization: "Shelter support",
    type: "Civil Defence & Shelter Ops",
    status: "On site",
    responders: 6,
    lead: "K. Mathew",
    commanderName: "Capt. K. Mathew",
    commanderPhone: "+91 98470 21944",
    staging: "Kakkanad",
    task: "INC-2043 · Shelter check-in",
    note: "160 people · Monitoring",
    latitude: 10.0150,
    longitude: 76.3400,
    gpsCoords: "10.0150° N, 76.3400° E",
    online: true,
    lastUpdate: "Updated 1m ago"
  }
];

const defaultAlerts = [
  {
    id: "a-1",
    title: "Flash flooding · Fort Kochi",
    code: "INC-2048",
    subtitle: "INC-2048 · 320 people affected",
    category: "Flood",
    riskLevel: "High risk",
    location: "Fort Kochi Low-Lying Canal Basin",
    timeAgo: "Now",
    severity: "High",
    requiresVerification: true,
    createdAt: new Date().toISOString()
  },
  {
    id: "a-2",
    title: "Bridge collapse · Mattancherry",
    code: "INC-2047",
    subtitle: "INC-2047 · Escalated",
    category: "Earthquake",
    riskLevel: "Watch",
    location: "Mattancherry Palace Road",
    timeAgo: "7m",
    severity: "High",
    escalated: true,
    createdAt: new Date().toISOString()
  },
  {
    id: "a-3",
    title: "Evacuation · Vypin",
    code: "INC-2046",
    subtitle: "INC-2046 · Alpha 01 responding",
    category: "Weather",
    riskLevel: "Advisory",
    location: "Vypin Coastline Surge",
    timeAgo: "14m",
    severity: "High",
    createdAt: new Date().toISOString()
  }
];

const defaultMessages = {
  "ernakulam-command": [
    {
      id: "m-1",
      sender: "District Control",
      initials: "DC",
      time: "14:22",
      text: "Heavy rain advisory remains in effect. Keep evacuation routes clear around Fort Kochi and Vypin."
    },
    {
      id: "m-2",
      sender: "Alpha 01 · R. Menon",
      initials: "AM",
      time: "14:26",
      text: "Responding to INC-2046 in Vypin. Team of 10 en route. ETA 8 min; coastal evacuation preparations underway."
    },
    {
      id: "m-3",
      sender: "Ananya Kumar · You",
      initials: "AK",
      isSelf: true,
      time: "14:29",
      text: "Received, Alpha 01. Report on arrival. Mattancherry bridge incident INC-2047 has been escalated to district response."
    },
    {
      id: "m-4",
      sender: "Bravo 02 · S. Nair",
      initials: "BN",
      time: "14:31",
      text: "Water rescue team available at Fort Kochi staging area. 8 responders and rescue boat ready."
    }
  ],
  "field-coordination": [
    {
      id: "m-fc-1",
      sender: "Field Ops",
      initials: "FO",
      time: "14:15",
      text: "VHF channel 4 open for all boat rescue teams in Kochi harbor."
    }
  ]
};

class Store {
  constructor() {
    this.incidents = [];
    this.teams = [];
    this.alerts = [];
    this.messages = {};
    this.lastPersistedSnapshot = null;
    this.load();
  }

  load() {
    try {
      if (fs.existsSync(DATA_FILE)) {
        const raw = fs.readFileSync(DATA_FILE, 'utf8');
        const data = JSON.parse(raw);
        this.incidents = data.incidents || defaultIncidents;
        this.teams = data.teams || defaultTeams;
        this.alerts = data.alerts || defaultAlerts;
        this.messages = data.messages || defaultMessages;
        return;
      }
    } catch (e) {
      console.warn('Failed to read persisted store, falling back to defaults:', e.message);
    }
    this.incidents = defaultIncidents;
    this.teams = defaultTeams;
    this.alerts = defaultAlerts;
    this.messages = defaultMessages;
  }

  async initialize() {
    await database.initialize(this);
    this.lastPersistedSnapshot = this.createSnapshot();
  }

  createSnapshot() {
    return JSON.parse(JSON.stringify({
      incidents: this.incidents,
      teams: this.teams,
      alerts: this.alerts,
      messages: this.messages
    }));
  }

  restoreSnapshot(snapshot) {
    this.incidents = snapshot.incidents;
    this.teams = snapshot.teams;
    this.alerts = snapshot.alerts;
    this.messages = snapshot.messages;
  }

  save() {
    const snapshot = this.createSnapshot();
    return database.persistSnapshot(snapshot).then(() => {
      this.lastPersistedSnapshot = snapshot;
    }).catch((error) => {
      if (this.lastPersistedSnapshot) {
        this.restoreSnapshot(JSON.parse(JSON.stringify(this.lastPersistedSnapshot)));
      }
      throw error;
    });
  }

  getStats() {
    const active = this.incidents.filter(i => i.status !== 'Resolved');
    const affected = this.incidents.reduce((sum, i) => sum + (i.affected || i.affectedCount || 0), 0);
    const deployedTeams = this.teams.filter(t => t.status === 'Deployed' || t.status === 'On site').length;
    return {
      activeIncidents: active.length,
      peopleAffected: affected,
      rescueTeamsDeployed: `${deployedTeams} / ${this.teams.length}`,
      teamsDeployedCount: deployedTeams,
      totalTeams: this.teams.length,
      reliefSupplies: 8450,
      resolvedToday: this.incidents.filter(i => i.status === 'Resolved').length
    };
  }
}

module.exports = new Store();
