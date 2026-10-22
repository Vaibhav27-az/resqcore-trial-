import 'package:flutter/material.dart';

enum EmergencyType {
  flood,
  earthquake,
  fire,
  other;

  String get id => name;

  String get title {
    switch (this) {
      case EmergencyType.flood:
        return 'Flood';
      case EmergencyType.earthquake:
        return 'Earthquake';
      case EmergencyType.fire:
        return 'Fire';
      case EmergencyType.other:
        return 'Other emergency';
    }
  }

  String get description {
    switch (this) {
      case EmergencyType.flood:
        return 'Rising water or people stranded';
      case EmergencyType.earthquake:
        return 'Shaking, damage or trapped people';
      case EmergencyType.fire:
        return 'Smoke, flames or a fire hazard';
      case EmergencyType.other:
        return 'Medical help or another urgent risk';
    }
  }

  IconData get icon {
    switch (this) {
      case EmergencyType.flood:
        return Icons.water;
      case EmergencyType.earthquake:
        return Icons.show_chart;
      case EmergencyType.fire:
        return Icons.local_fire_department;
      case EmergencyType.other:
        return Icons.emergency;
    }
  }

  String get imagePath {
    switch (this) {
      case EmergencyType.flood:
        return 'assets/images/scenarios/flood_river_boat.png';
      case EmergencyType.earthquake:
        return 'assets/images/scenarios/earthquake_rubble_collapse.png';
      case EmergencyType.fire:
        return 'assets/images/scenarios/highway_ambulance_storm.png';
      case EmergencyType.other:
        return 'assets/images/scenarios/helicopter_mountain_alpine.png';
    }
  }
}
