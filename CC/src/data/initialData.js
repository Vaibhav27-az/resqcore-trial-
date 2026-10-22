// Initial mock data mirroring the Figma ResQCore specification

export const initialIncidents = [
  {
    id: "INC-2048",
    title: "Flash flooding",
    location: "Fort Kochi · Ernakulam, Kerala",
    shortLocation: "Fort Kochi",
    area: "Fort Kochi",
    affected: 320,
    time: "14:32 IST",
    timeAgo: "Now",
    severity: "High", // 'High' | 'Medium' | 'Info'
    status: "Unverified", // 'Unverified' | 'Verified' | 'Responding' | 'Escalated' | 'On site' | 'Monitoring'
    responseSummary: "Awaiting verification",
    responseDetail: "Verify to respond",
    description: "Rapid water rise near the ferry terminal. Families stranded; evacuation required.",
    fieldReport: "Field report · FK-01 camera confirmed",
    coordinates: {
      lat: "9.9658° N",
      lng: "76.2421° E",
      x: 34, // % map position
      y: 58
    },
    assignedTeam: null,
    image: "/assets/flood.png"
  },
  {
    id: "INC-2047",
    title: "Bridge collapse",
    location: "Mattancherry · Ernakulam, Kerala",
    shortLocation: "Mattancherry",
    area: "Mattancherry",
    affected: 85,
    time: "14:25 IST",
    timeAgo: "7m",
    severity: "High",
    status: "Escalated",
    responseSummary: "No team available",
    responseDetail: "District notified",
    description: "Bridge access cut off. Technical rescue assistance requested for the eastern bank.",
    fieldReport: "Field report · MC-02 camera confirmed",
    escalationNote: "District response notified at 14:30 IST. Awaiting technical rescue support.",
    coordinates: {
      lat: "9.9587° N",
      lng: "76.2594° E",
      x: 40,
      y: 73
    },
    assignedTeam: null,
    image: "/assets/bridge_cctv.png"
  },
  {
    id: "INC-2046",
    title: "Coastal evacuation",
    location: "Vypin · Ernakulam, Kerala",
    shortLocation: "Vypin",
    area: "Vypin",
    affected: 210,
    time: "14:18 IST",
    timeAgo: "14m",
    severity: "High",
    status: "Responding",
    responseSummary: "Alpha 01",
    responseDetail: "ETA 8 min",
    description: "High tidal surge threatening coastal settlement. Evacuation of zone 2 in progress.",
    fieldReport: "Field report · VP-03 camera confirmed",
    coordinates: {
      lat: "9.9920° N",
      lng: "76.2300° E",
      x: 36,
      y: 37
    },
    assignedTeam: "Alpha 01",
    image: "/assets/coastal_cctv.png"
  },
  {
    id: "INC-2045",
    title: "Residential fire",
    location: "Edappally · Ernakulam, Kerala",
    shortLocation: "Edappally",
    area: "Edappally",
    affected: 42,
    time: "14:10 IST",
    timeAgo: "22m",
    severity: "Medium",
    status: "Responding",
    responseSummary: "Delta 04",
    responseDetail: "ETA 16 min",
    description: "Electrical short-circuit triggered fire during heavy water logging. Containment ongoing.",
    fieldReport: "Field report · Unit 4 responder verified",
    coordinates: {
      lat: "10.0240° N",
      lng: "76.3080° E",
      x: 57,
      y: 49
    },
    assignedTeam: "Delta 04",
    image: "/assets/satellite.png"
  },
  {
    id: "INC-2044",
    title: "Road inundation",
    location: "Thevara · Ernakulam, Kerala",
    shortLocation: "Thevara",
    area: "Thevara",
    affected: 120,
    time: "13:56 IST",
    timeAgo: "36m",
    severity: "Medium",
    status: "On site",
    responseSummary: "Echo 05",
    responseDetail: "On site",
    description: "Major junction submerged by 3.5 ft water. Traffic diverted; emergency pumps deployed.",
    fieldReport: "Field report · Municipal sensor triggered",
    coordinates: {
      lat: "9.9350° N",
      lng: "76.2980° E",
      x: 54,
      y: 78
    },
    assignedTeam: "Echo 05",
    image: "/assets/satellite.png"
  },
  {
    id: "INC-2043",
    title: "Shelter check-in",
    location: "Kakkanad · Ernakulam, Kerala",
    shortLocation: "Kakkanad",
    area: "Kakkanad",
    affected: 160,
    time: "13:45 IST",
    timeAgo: "47m",
    severity: "Info",
    status: "Monitoring",
    responseSummary: "Foxtrot 06",
    responseDetail: "On site",
    description: "Relief camp 4 reached 80% capacity. Medical supplies and dry ration kit verification.",
    fieldReport: "Field report · Relief coordinator verified",
    coordinates: {
      lat: "10.0150° N",
      lng: "76.3400° E",
      x: 61,
      y: 62
    },
    assignedTeam: "Foxtrot 06",
    image: "/assets/satellite.png"
  },
  // Additional incidents to make up the 24 active incidents
  {
    id: "INC-2042",
    title: "Power line collapse",
    location: "Aluva · Ernakulam, Kerala",
    shortLocation: "Aluva",
    area: "Aluva",
    affected: 55,
    time: "13:30 IST",
    timeAgo: "1h",
    severity: "Medium",
    status: "Responding",
    responseSummary: "Delta 02",
    responseDetail: "ETA 20 min",
    description: "Fallen eucalyptus tree snapped HT cable across main bypass road.",
    coordinates: { lat: "10.1076° N", lng: "76.3516° E", x: 68, y: 25 },
    assignedTeam: "Delta 02"
  },
  {
    id: "INC-2041",
    title: "River embankment seepage",
    location: "Perumbavoor · Ernakulam, Kerala",
    shortLocation: "Perumbavoor",
    area: "Perumbavoor",
    affected: 90,
    time: "13:15 IST",
    timeAgo: "1h 17m",
    severity: "High",
    status: "Monitoring",
    responseSummary: "Bravo 01",
    responseDetail: "On site",
    description: "Periyar river swelling near check dam; sandbag reinforcement in progress.",
    coordinates: { lat: "10.1139° N", lng: "76.4746° E", x: 75, y: 30 },
    assignedTeam: "Bravo 01"
  },
  {
    id: "INC-2040",
    title: "Hospital basement water ingress",
    location: "Kaloor · Ernakulam, Kerala",
    shortLocation: "Kaloor",
    area: "Kaloor",
    affected: 45,
    time: "13:00 IST",
    timeAgo: "1h 32m",
    severity: "Medium",
    status: "Responding",
    responseSummary: "Charlie 02",
    responseDetail: "On site",
    description: "Backup generator room flooded. Pumping engines deployed.",
    coordinates: { lat: "9.9984° N", lng: "76.2917° E", x: 52, y: 52 },
    assignedTeam: "Charlie 02"
  },
  {
    id: "INC-2039",
    title: "Disaster warning siren activation",
    location: "Marine Drive · Ernakulam, Kerala",
    shortLocation: "Marine Drive",
    area: "Marine Drive",
    affected: 30,
    time: "12:45 IST",
    timeAgo: "1h 47m",
    severity: "Info",
    status: "Monitoring",
    responseSummary: "Foxtrot 02",
    responseDetail: "On site",
    description: "Public address advisory broadcast across waterfront promenade.",
    coordinates: { lat: "9.9816° N", lng: "76.2750° E", x: 48, y: 55 },
    assignedTeam: "Foxtrot 02"
  },
  {
    id: "INC-2038",
    title: "Landslip near quarry road",
    location: "Malayattoor · Ernakulam, Kerala",
    shortLocation: "Malayattoor",
    area: "Malayattoor",
    affected: 28,
    time: "12:30 IST",
    timeAgo: "2h",
    severity: "Medium",
    status: "Responding",
    responseSummary: "Echo 03",
    responseDetail: "On site",
    description: "Minor mudslide blocking single-lane access to tribal settlement.",
    coordinates: { lat: "10.1923° N", lng: "76.5028° E", x: 80, y: 20 },
    assignedTeam: "Echo 03"
  },
  {
    id: "INC-2037",
    title: "Drinking water contamination",
    location: "Cherai · Ernakulam, Kerala",
    shortLocation: "Cherai",
    area: "Cherai",
    affected: 80,
    time: "12:15 IST",
    timeAgo: "2h 17m",
    severity: "Info",
    status: "Monitoring",
    responseSummary: "Charlie 01",
    responseDetail: "On site",
    description: "Chlorine tablets and mineral water tanks distributed to community center.",
    coordinates: { lat: "10.1417° N", lng: "76.1806° E", x: 28, y: 22 },
    assignedTeam: "Charlie 01"
  }
];

export const initialTeams = [
  {
    id: "alpha-01",
    name: "Alpha 01",
    specialization: "Coastal rescue",
    status: "Deployed",
    responders: 10,
    lead: "R. Menon",
    staging: "Vypin",
    task: "INC-2046 · Coastal evacuation",
    eta: "ETA 8 min",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "bravo-02",
    name: "Bravo 02",
    specialization: "Water rescue",
    status: "Available",
    responders: 8,
    lead: "S. Nair",
    staging: "Fort Kochi staging area",
    readiness: "Ready for deployment",
    equipment: "Boat equipped · Radio connected",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "charlie-03",
    name: "Charlie 03",
    specialization: "Medical response",
    status: "Available",
    responders: 6,
    lead: "P. Thomas",
    staging: "Ernakulam relief hub",
    readiness: "Ready for deployment",
    equipment: "Medical kits stocked",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "delta-04",
    name: "Delta 04",
    specialization: "Fire & rescue",
    status: "Deployed",
    responders: 9,
    lead: "A. Joseph",
    staging: "Edappally",
    task: "INC-2045 · Residential fire",
    eta: "ETA 16 min",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "echo-05",
    name: "Echo 05",
    specialization: "Evacuation support",
    status: "On site",
    responders: 8,
    lead: "M. Pillai",
    staging: "Thevara",
    task: "INC-2044 · Road inundation",
    note: "120 people · Evacuation underway",
    online: true,
    lastUpdate: "Updated 1m ago"
  },
  {
    id: "foxtrot-06",
    name: "Foxtrot 06",
    specialization: "Shelter support",
    status: "On site",
    responders: 6,
    lead: "K. Mathew",
    staging: "Kakkanad",
    task: "INC-2043 · Shelter check-in",
    note: "160 people · Monitoring",
    online: true,
    lastUpdate: "Updated 1m ago"
  }
];

export const initialCameras = [
  {
    id: "fk-01",
    tag: "FK-01 · HD",
    name: "Fort Kochi ferry",
    subtitle: "Flood watch · 14:32:08",
    image: "/assets/flood.png",
    status: "LIVE"
  },
  {
    id: "mc-02",
    tag: "MC-02 · HD",
    name: "Mattancherry bridge",
    subtitle: "Access restricted · 14:32:06",
    image: "/assets/bridge_cctv.png",
    status: "LIVE"
  },
  {
    id: "vp-03",
    tag: "VP-03 · HD",
    name: "Vypin coast road",
    subtitle: "Evacuation zone · 14:32:04",
    image: "/assets/coastal_cctv.png",
    status: "LIVE"
  }
];

export const initialChannels = [
  { id: "ernakulam-command", name: "Ernakulam command", members: 18, unread: 3, isChannel: true },
  { id: "field-coordination", name: "Field coordination", members: 32, unread: 0, isChannel: true },
  { id: "relief-distribution", name: "Relief distribution", members: 12, unread: 0, isChannel: true },
  { id: "medical-response", name: "Medical response", members: 9, unread: 0, isChannel: true }
];

export const initialDirectMessages = [
  { id: "alpha-01", name: "Alpha 01", online: true },
  { id: "bravo-02", name: "Bravo 02", online: true },
  { id: "district-control", name: "District Control", online: true }
];

export const initialMessages = {
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

export const initialAlerts = [
  {
    id: "a-1",
    title: "Flash flooding · Fort Kochi",
    code: "INC-2048",
    subtitle: "INC-2048 · 320 people affected",
    timeAgo: "Now",
    severity: "High",
    requiresVerification: true
  },
  {
    id: "a-2",
    title: "Bridge collapse · Mattancherry",
    code: "INC-2047",
    subtitle: "INC-2047 · Escalated",
    timeAgo: "7m",
    severity: "High",
    escalated: true
  },
  {
    id: "a-3",
    title: "Evacuation · Vypin",
    code: "INC-2046",
    subtitle: "INC-2046 · Alpha 01 responding",
    timeAgo: "14m",
    severity: "High"
  }
];
