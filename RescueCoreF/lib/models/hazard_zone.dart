import 'package:flutter/material.dart';

enum HazardSeverity {
  critical,
  warning,
  advisory;

  Color get color {
    switch (this) {
      case HazardSeverity.critical:
        return const Color(0xFFEF4444);
      case HazardSeverity.warning:
        return const Color(0xFFF59E0B);
      case HazardSeverity.advisory:
        return const Color(0xFF3B82F6);
    }
  }

  String get label {
    switch (this) {
      case HazardSeverity.critical:
        return 'CRITICAL ZONE';
      case HazardSeverity.warning:
        return 'WARNING ZONE';
      case HazardSeverity.advisory:
        return 'ADVISORY AREA';
    }
  }
}

class HazardZone {
  final String id;
  final String name;
  final String type;
  final HazardSeverity severity;
  final String description;
  final String radius;
  final double latitude;
  final double longitude;
  final String? imagePath;

  const HazardZone({
    required this.id,
    required this.name,
    required this.type,
    required this.severity,
    required this.description,
    required this.radius,
    required this.latitude,
    required this.longitude,
    this.imagePath,
  });
}
