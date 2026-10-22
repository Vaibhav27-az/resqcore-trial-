import 'package:flutter/material.dart';

enum TeamStatus {
  enRoute,
  onScene,
  standby;

  String get label {
    switch (this) {
      case TeamStatus.enRoute:
        return 'En Route';
      case TeamStatus.onScene:
        return 'On Scene';
      case TeamStatus.standby:
        return 'Standby';
    }
  }

  Color get color {
    switch (this) {
      case TeamStatus.enRoute:
        return const Color(0xFF60A5FA);
      case TeamStatus.onScene:
        return const Color(0xFF34D399);
      case TeamStatus.standby:
        return const Color(0xFFFBBF24);
    }
  }
}

class RescueTeam {
  final String id;
  final String name;
  final String type;
  final IconData icon;
  final TeamStatus status;
  final String currentSector;
  final String eta;
  final double latitude;
  final double longitude;
  final String? imagePath;

  const RescueTeam({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.status,
    required this.currentSector,
    required this.eta,
    required this.latitude,
    required this.longitude,
    this.imagePath,
  });
}
