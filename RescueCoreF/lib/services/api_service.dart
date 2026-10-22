import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String _host = '';

  static String get baseUrl {
    if (_host.isNotEmpty) return _host;
    if (kIsWeb) return 'http://localhost:5000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  static set customHost(String host) {
    _host = host.trim();
  }

  static final http.Client _client = http.Client();

  /// Check server health
  static Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/api/health');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[RescueCoreF-ApiService] Health check failed: $e');
      return false;
    }
  }

  /// Submit SOS or Emergency Request to Unified Backend
  static Future<Map<String, dynamic>?> submitEmergencyRequest({
    required String id,
    required String title,
    required String category,
    required String description,
    required String address,
    required String contactNumber,
    double? lat,
    double? lng,
    String? photoAssetPath,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/incidents');
      final payload = jsonEncode({
        'id': id,
        'title': title,
        'category': category,
        'type': category,
        'location': address,
        'address': address,
        'description': description,
        'contactNumber': contactNumber,
        'lat': lat ?? 9.9658,
        'lng': lng ?? 76.2421,
        'photoAssetPath': photoAssetPath ?? 'assets/images/scenarios/flood_river_boat.png',
        'severity': 'High',
        'status': 'Unverified',
        'citizenStatus': 'pending',
      });

      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
    } catch (e) {
      debugPrint('[RescueCoreF-ApiService] Failed to submit emergency request: $e');
    }
    return null;
  }

  /// Fetch updated incidents/requests
  static Future<List<dynamic>> fetchIncidents() async {
    try {
      final uri = Uri.parse('$baseUrl/api/incidents');
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? [];
      }
    } catch (e) {
      debugPrint('[RescueCoreF-ApiService] Fetch incidents failed: $e');
    }
    return [];
  }

  /// Fetch broadcast disaster alerts
  static Future<List<dynamic>> fetchAlerts() async {
    try {
      final uri = Uri.parse('$baseUrl/api/alerts');
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? [];
      }
    } catch (e) {
      debugPrint('[RescueCoreF-ApiService] Fetch alerts failed: $e');
    }
    return [];
  }
}
