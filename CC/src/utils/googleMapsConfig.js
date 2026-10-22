// Tactical Dark Styling for Command Center Google Maps
export const TACTICAL_DARK_MAP_STYLE = [
  { elementType: 'geometry', stylers: [{ color: '#091122' }] },
  { elementType: 'labels.text.stroke', stylers: [{ color: '#091122' }] },
  { elementType: 'labels.text.fill', stylers: [{ color: '#748DA6' }] },
  {
    featureType: 'administrative.locality',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#94A3B8' }]
  },
  {
    featureType: 'poi',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#64748B' }]
  },
  {
    featureType: 'poi.park',
    elementType: 'geometry',
    stylers: [{ color: '#0D1E32' }]
  },
  {
    featureType: 'poi.park',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#38BDF8' }]
  },
  {
    featureType: 'road',
    elementType: 'geometry',
    stylers: [{ color: '#162846' }]
  },
  {
    featureType: 'road',
    elementType: 'geometry.stroke',
    stylers: [{ color: '#0E172A' }]
  },
  {
    featureType: 'road',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#8899A6' }]
  },
  {
    featureType: 'road.highway',
    elementType: 'geometry',
    stylers: [{ color: '#1E3A8A' }]
  },
  {
    featureType: 'road.highway',
    elementType: 'geometry.stroke',
    stylers: [{ color: '#0F172A' }]
  },
  {
    featureType: 'road.highway',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#60A5FA' }]
  },
  {
    featureType: 'transit',
    elementType: 'geometry',
    stylers: [{ color: '#132338' }]
  },
  {
    featureType: 'transit.station',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#94A3B8' }]
  },
  {
    featureType: 'water',
    elementType: 'geometry',
    stylers: [{ color: '#030814' }]
  },
  {
    featureType: 'water',
    elementType: 'labels.text.fill',
    stylers: [{ color: '#38BDF8' }]
  },
  {
    featureType: 'water',
    elementType: 'labels.text.stroke',
    stylers: [{ color: '#030814' }]
  }
];

// Helper to parse coordinate string like "9.9658° N" or number into float
export function parseCoord(val, defaultVal = 0) {
  if (typeof val === 'number') return val;
  if (!val || typeof val !== 'string') return defaultVal;
  const num = parseFloat(val.replace(/[^0-9.-]/g, ''));
  if (isNaN(num)) return defaultVal;
  if (val.includes('S') || val.includes('W')) return -num;
  return num;
}

// Default Command Center Focus (Dehradun, Uttarakhand)
export const DEFAULT_COMMAND_CENTER_LOCATION = {
  lat: 30.3165,
  lng: 78.0322,
  zoom: 10
};

export const UTTARAKHAND_DISTRICT_COORDS = {
  'Dehradun, Uttarakhand': { lat: 30.3165, lng: 78.0322, zoom: 11 },
  'Chamoli, Uttarakhand': { lat: 30.4072, lng: 79.3242, zoom: 10 },
  'Rudraprayag, Uttarakhand': { lat: 30.2844, lng: 78.9811, zoom: 11 },
  'Uttarkashi, Uttarakhand': { lat: 30.7268, lng: 78.4354, zoom: 10 },
  'Nainital, Uttarakhand': { lat: 29.3919, lng: 79.4542, zoom: 11 },
  'Haridwar, Uttarakhand': { lat: 29.9457, lng: 78.1642, zoom: 11 },
  'Pithoragarh, Uttarakhand': { lat: 29.5829, lng: 80.2182, zoom: 10 },
  'Tehri Garhwal, Uttarakhand': { lat: 30.3789, lng: 78.4803, zoom: 10 }
};

export function getDistrictCenter(districtName) {
  if (districtName && UTTARAKHAND_DISTRICT_COORDS[districtName]) {
    return UTTARAKHAND_DISTRICT_COORDS[districtName];
  }
  return DEFAULT_COMMAND_CENTER_LOCATION;
}

// Generates an SVG Data URI for tactical pins
export function createTacticalMarkerIcon(severity, isVerified = false, isSelected = false) {
  const color = isVerified
    ? '#10B981'
    : severity === 'High'
    ? '#EF4444'
    : severity === 'Medium'
    ? '#F59E0B'
    : '#38BDF8';

  const size = isSelected ? 36 : 28;
  const radius = size / 2;

  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
      <defs>
        <filter id="glow" x="-30%" y="-30%" width="160%" height="160%">
          <feDropShadow dx="0" dy="2" stdDeviation="3" flood-color="${color}" flood-opacity="0.6"/>
        </filter>
      </defs>
      <circle cx="${radius}" cy="${radius}" r="${radius - 3}" fill="#091122" stroke="${color}" stroke-width="${isSelected ? 3 : 2}" filter="url(#glow)"/>
      <circle cx="${radius}" cy="${radius}" r="5" fill="${color}"/>
    </svg>
  `;

  return `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`;
}

// Marker for Rescue Teams (Shield)
export function createTeamMarkerIcon() {
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="#091122" stroke="#10B981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
    </svg>
  `;
  return `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`;
}
