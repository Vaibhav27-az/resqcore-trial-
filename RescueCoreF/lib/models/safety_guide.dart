import 'package:flutter/material.dart';

class SafetyGuide {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color themeColor;
  final List<String> dos;
  final List<String> donts;
  final List<String> kitChecklist;
  final String? imagePath;

  const SafetyGuide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeColor,
    required this.dos,
    required this.donts,
    required this.kitChecklist,
    this.imagePath,
  });
}
