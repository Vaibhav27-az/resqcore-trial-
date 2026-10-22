import 'dart:async';
import 'package:flutter/material.dart';
import 'incident.dart';
import 'team_member.dart';
import 'chat_message.dart';
import 'shelter_model.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  String _userRole = 'Commander';
  String _userName = 'Devank (HQ Commander)';
  String _userPhone = '+91 98110 44201';
  bool _isAuthenticated = false;
  int _activeTabIndex = 0;
  bool _nightOpsEnabled = true;
  bool _sosActive = false;

  List<Incident> _incidents = Incident.mockIncidents();
  List<RescueTeam> _teams = RescueTeam.mockTeams();
  List<ChatMessage> _messages = ChatMessage.mockMessages();
  List<Shelter> _shelters = Shelter.mockShelters();
  List<Evacuee> _evacuees = Evacuee.mockEvacuees();
  final Set<String> _knownFieldIncidentIds = {};
  final List<Incident> _pendingDispatchNotifications = [];
  bool _hasLoadedFieldIncidents = false;

  Timer? _syncTimer;

  AppState() {
    _startBackendSync();
  }

  void _startBackendSync() {
    _syncFromBackend();
    _syncTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _syncFromBackend();
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  Future<void> _syncFromBackend() async {
    try {
      final backendIncidents = await ApiService.fetchIncidents();
      if (backendIncidents != null) {
        final List<Incident> updatedList = [];
        final List<Incident> newDispatches = [];
        for (final raw in backendIncidents) {
          try {
            final parsed = Incident.fromJson(raw as Map<String, dynamic>);
            updatedList.add(parsed);
            if (_hasLoadedFieldIncidents &&
                !_knownFieldIncidentIds.contains(parsed.id)) {
              newDispatches.add(parsed);
            }
          } catch (_) {}
        }
        _knownFieldIncidentIds
          ..clear()
          ..addAll(updatedList.map((incident) => incident.id));
        _hasLoadedFieldIncidents = true;
        _incidents = updatedList;
        _pendingDispatchNotifications.addAll(newDispatches);
        notifyListeners();
      }

      final backendMsgs = await ApiService.fetchMessages();
      if (backendMsgs.isNotEmpty) {
        bool hasMsgChanges = false;
        for (final raw in backendMsgs) {
          try {
            final msg = ChatMessage.fromJson(raw as Map<String, dynamic>, currentUserName: _userName);
            if (!_messages.any((m) => m.id == msg.id || (m.text == msg.text && m.sender == msg.sender))) {
              _messages.add(msg);
              hasMsgChanges = true;
            }
          } catch (_) {}
        }
        if (hasMsgChanges) notifyListeners();
      }
    } catch (_) {}
  }

  // Getters
  String get userRole => _userRole;
  String get userName => _userName;
  String get userPhone => _userPhone;
  bool get isAuthenticated => _isAuthenticated;
  int get activeTabIndex => _activeTabIndex;
  bool get nightOpsEnabled => _nightOpsEnabled;
  bool get sosActive => _sosActive;

  List<Incident> get incidents => _incidents;
  List<RescueTeam> get teams => _teams;
  List<ChatMessage> get messages => _messages;
  List<Shelter> get shelters => _shelters;
  List<Evacuee> get evacuees => _evacuees;

  List<Incident> takePendingDispatchNotifications() {
    final notifications = List<Incident>.unmodifiable(
      _pendingDispatchNotifications,
    );
    _pendingDispatchNotifications.clear();
    return notifications;
  }

  int get affectedTotal => _incidents.fold<int>(0, (sum, i) => sum + i.affectedCount);
  int get rescuedTotal => _evacuees.where((e) => e.status == 'Rescued').length * 47 + 1;
  int get missingTotal => _evacuees.where((e) => e.status == 'Missing').length * 7;

  // Actions
  void setDemoRole(String role, String phone, String name) {
    _userRole = role;
    _userPhone = phone;
    _userName = name;
    _isAuthenticated = true;
    notifyListeners();
  }

  void login(String role, String phone) {
    _userRole = role;
    _userPhone = phone;
    _userName = role == 'Civilian' ? 'Citizen Distress User' : 'Field Operative Devank';
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  void toggleNightOps() {
    _nightOpsEnabled = !_nightOpsEnabled;
    notifyListeners();
  }

  void triggerSos() {
    _sosActive = true;
    final sosId = 'SOS-${DateTime.now().millisecondsSinceEpoch}';
    final sosText = 'EMERGENCY SOS ACTIVATED by $_userName at GPS 30.3165° N, 78.0322° E (Dehradun). Team Alpha dispatched!';

    _messages.insert(
      0,
      ChatMessage(
        id: sosId,
        sender: 'DISPATCH ALERT',
        initials: 'SOS',
        role: 'EMERGENCY BEACON',
        time: 'Just now',
        text: sosText,
        isAlert: true,
        isBot: true,
      ),
    );
    notifyListeners();

    // Broadcast to Unified Backend
    ApiService.reportIncident(
      id: sosId,
      title: '🚨 TACTICAL FIELD SOS',
      location: 'GPS 30.3165° N, 78.0322° E (Dehradun)',
      severity: 'High',
      description: sosText,
    );
    ApiService.sendMessage(sosText, sender: 'DISPATCH ALERT', role: 'EMERGENCY BEACON');
  }

  void cancelSos() {
    _sosActive = false;
    notifyListeners();
  }

  void addMessage(String text, {String? locationTag}) {
    if (text.trim().isEmpty) return;
    _messages.add(
      ChatMessage(
        id: 'MSG-${DateTime.now().millisecondsSinceEpoch}',
        sender: _userName,
        initials: _userName.isNotEmpty ? _userName[0].toUpperCase() : 'ME',
        role: _userRole,
        time: 'Just now',
        text: text,
        locationTag: locationTag,
        isMe: true,
      ),
    );
    notifyListeners();

    // Sync with Unified Backend
    ApiService.sendMessage(text, sender: _userName, role: _userRole);
  }

  void reportIncident({
    required String title,
    required String location,
    required String severity,
    required String description,
    String? photoAssetPath,
  }) {
    final incidentId = 'INC-${_incidents.length + 101}';
    final newIncident = Incident(
      id: incidentId,
      title: title,
      location: location,
      timestamp: 'Today · Just now',
      severity: severity,
      status: 'Active',
      teamAssigned: 'En route / Assigning',
      eta: '10 min',
      affectedCount: 12,
      coordinates: '30.5562° N, 79.5670° E',
      description: description,
      substatus: 'Immediate triage in progress',
      photoAssetPath: photoAssetPath ?? 'assets/images/scenarios/earthquake_rubble_collapse.png',
    );
    _incidents.insert(0, newIncident);
    notifyListeners();

    // Broadcast to Unified Backend
    ApiService.reportIncident(
      id: incidentId,
      title: title,
      location: location,
      severity: severity,
      description: description,
      photoAssetPath: photoAssetPath,
    );
  }

  Future<void> updateIncidentStatus(String incidentId, String newStatus) async {
    final idx = _incidents.indexWhere((i) => i.id == incidentId);
    if (idx != -1) {
      _incidents[idx] = _incidents[idx].copyWith(
        status: newStatus,
        substatus: '$newStatus · Updated by $_userName',
      );
      notifyListeners();
    }
    await ApiService.updateIncidentStatus(incidentId, newStatus);
  }
}
