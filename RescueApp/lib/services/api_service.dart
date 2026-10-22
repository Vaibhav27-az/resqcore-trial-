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
      debugPrint('[RescueApp-ApiService] Health check failed: $e');
      return false;
    }
  }

  /// Fetch all incidents from unified backend
  static Future<List<dynamic>?> fetchIncidents() async {
    try {
      final uri = Uri.parse('$baseUrl/api/incidents?audience=field');
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? [];
      }
    } catch (e) {
      debugPrint('[RescueApp-ApiService] Fetch incidents failed: $e');
    }
    return null;
  }

  /// Create new incident from Field App
  static Future<Map<String, dynamic>?> reportIncident({
    required String id,
    required String title,
    required String location,
    required String severity,
    required String description,
    String? photoAssetPath,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/incidents');
      final payload = jsonEncode({
        'id': id,
        'title': title,
        'location': location,
        'severity': severity,
        'description': description,
        'photoAssetPath': photoAssetPath ?? 'assets/images/scenarios/earthquake_rubble_collapse.png',
        'status': 'Unverified',
        'affectedCount': 12,
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
      debugPrint('[RescueApp-ApiService] Failed to report incident: $e');
    }
    return null;
  }

  /// Update incident status (e.g. 'On site', 'Resolved')
  static Future<bool> updateIncidentStatus(String id, String status, {String? substatus}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/incidents/$id/status');
      final payload = jsonEncode({
        'status': status,
        'substatus': substatus ?? '$status · Field operative updated',
      });

      final response = await _client.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      ).timeout(const Duration(seconds: 4));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[RescueApp-ApiService] Failed to update status: $e');
      return false;
    }
  }

  /// Fetch radio chat messages
  static Future<List<dynamic>> fetchMessages([String channel = 'ernakulam-command']) async {
    try {
      final uri = Uri.parse('$baseUrl/api/messages/$channel');
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? [];
      }
    } catch (e) {
      debugPrint('[RescueApp-ApiService] Fetch messages failed: $e');
    }
    return [];
  }

  /// Send radio chat message
  static Future<bool> sendMessage(String text, {required String sender, required String role, String channel = 'ernakulam-command'}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/messages/$channel');
      final payload = jsonEncode({
        'sender': sender,
        'role': role,
        'initials': sender.isNotEmpty ? sender[0].toUpperCase() : 'OP',
        'text': text,
        'isSelf': true,
      });

      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      ).timeout(const Duration(seconds: 4));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[RescueApp-ApiService] Send message failed: $e');
      return false;
    }
  }

  /// Fetch teams from unified backend
  static Future<List<dynamic>> fetchTeams() async {
    try {
      final uri = Uri.parse('$baseUrl/api/teams');
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? [];
      }
    } catch (e) {
      debugPrint('[RescueApp-ApiService] Fetch teams failed: $e');
    }
    return [];
  }
}
