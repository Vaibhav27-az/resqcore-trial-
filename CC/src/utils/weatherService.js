import { UTTARAKHAND_DISTRICT_COORDS, DEFAULT_COMMAND_CENTER_LOCATION } from './googleMapsConfig';

// WMO Weather interpretation codes
export const WEATHER_CODE_MAP = {
  0: { label: 'Clear sky', icon: 'Sun' },
  1: { label: 'Mainly clear', icon: 'Sun' },
  2: { label: 'Partly cloudy', icon: 'CloudSun' },
  3: { label: 'Overcast', icon: 'Cloud' },
  45: { label: 'Foggy', icon: 'CloudFog' },
  48: { label: 'Depositing rime fog', icon: 'CloudFog' },
  51: { label: 'Light drizzle', icon: 'CloudDrizzle' },
  53: { label: 'Moderate drizzle', icon: 'CloudDrizzle' },
  55: { label: 'Dense drizzle', icon: 'CloudDrizzle' },
  61: { label: 'Slight rain', icon: 'CloudRain' },
  63: { label: 'Moderate rain', icon: 'CloudRain' },
  65: { label: 'Heavy rain', icon: 'CloudRain' },
  71: { label: 'Slight snow fall', icon: 'CloudSnow' },
  73: { label: 'Moderate snow fall', icon: 'CloudSnow' },
  75: { label: 'Heavy snow fall', icon: 'CloudSnow' },
  80: { label: 'Slight rain showers', icon: 'CloudRain' },
  81: { label: 'Moderate rain showers', icon: 'CloudRain' },
  82: { label: 'Violent rain showers', icon: 'CloudLightning' },
  95: { label: 'Thunderstorm', icon: 'CloudLightning' },
  96: { label: 'Thunderstorm with slight hail', icon: 'CloudLightning' },
  99: { label: 'Thunderstorm with heavy hail', icon: 'CloudLightning' }
};

export function getWeatherCondition(code) {
  return WEATHER_CODE_MAP[code] || { label: 'Cloudy', icon: 'Cloud' };
}

/**
 * Fetch real-time hourly forecast from Open-Meteo API
 * Matches user's exact specification:
 * https://api.open-meteo.com/v1/forecast?latitude=LAT&longitude=LON&hourly=temperature_2m,precipitation,relative_humidity_2m,wind_speed_10m,wind_gusts_10m,weather_code&timezone=auto&forecast_days=1
 */
export async function fetchDistrictWeather(districtName) {
  const coords = UTTARAKHAND_DISTRICT_COORDS[districtName] || DEFAULT_COMMAND_CENTER_LOCATION;
  const lat = coords.lat;
  const lon = coords.lng;

  const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&hourly=temperature_2m,precipitation,relative_humidity_2m,wind_speed_10m,wind_gusts_10m,weather_code&timezone=auto&forecast_days=1`;

  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Open-Meteo weather API responded with status ${response.status}`);
  }

  const data = await response.json();
  const hourly = data.hourly;
  if (!hourly || !hourly.time || hourly.time.length === 0) {
    throw new Error('No hourly weather data returned');
  }

  // Find the closest hour index based on current time
  const now = new Date();
  const currentIsoPrefix = now.toISOString().slice(0, 13); // "YYYY-MM-DDTHH"
  let currentIndex = hourly.time.findIndex(t => t.startsWith(currentIsoPrefix));
  if (currentIndex === -1) {
    currentIndex = Math.min(now.getHours(), hourly.time.length - 1);
  }

  const currentTemp = hourly.temperature_2m[currentIndex];
  const currentPrecip = hourly.precipitation[currentIndex];
  const currentHumidity = hourly.relative_humidity_2m[currentIndex];
  const currentWindSpeed = hourly.wind_speed_10m[currentIndex];
  const currentWindGusts = hourly.wind_gusts_10m[currentIndex];
  const currentWeatherCode = hourly.weather_code[currentIndex];
  const condition = getWeatherCondition(currentWeatherCode);

  // Build upcoming 6-hour forecast timeline
  const upcomingHours = [];
  for (let i = currentIndex; i < Math.min(currentIndex + 8, hourly.time.length); i++) {
    const rawTime = hourly.time[i];
    const hourLabel = rawTime.includes('T') ? rawTime.split('T')[1] : rawTime;
    upcomingHours.push({
      time: hourLabel,
      temp: hourly.temperature_2m[i],
      precipitation: hourly.precipitation[i],
      humidity: hourly.relative_humidity_2m[i],
      windSpeed: hourly.wind_speed_10m[i],
      windGusts: hourly.wind_gusts_10m[i],
      weatherCode: hourly.weather_code[i],
      condition: getWeatherCondition(hourly.weather_code[i])
    });
  }

  return {
    district: districtName,
    lat,
    lon,
    current: {
      temperature: currentTemp,
      precipitation: currentPrecip,
      humidity: currentHumidity,
      windSpeed: currentWindSpeed,
      windGusts: currentWindGusts,
      weatherCode: currentWeatherCode,
      conditionLabel: condition.label,
      conditionIcon: condition.icon,
      time: hourly.time[currentIndex]
    },
    hourlyTimeline: upcomingHours,
    elevation: data.elevation
  };
}
