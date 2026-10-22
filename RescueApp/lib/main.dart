import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/tactical_theme.dart';
import 'models/app_state.dart';
import 'models/incident.dart';
import 'screens/login_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/live_map_screen.dart';
import 'screens/incident_list_screen.dart';
import 'screens/teams_screen.dart';
import 'screens/shelters_screen.dart';
import 'screens/tactical_chat_screen.dart';
import 'screens/emergency_sos_screen.dart';
import 'widgets/tactical_bottom_navigation.dart';
import 'widgets/report_incident_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: TacticalColors.surfaceContainerLowest,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const RescueApp());
}

class RescueApp extends StatefulWidget {
  const RescueApp({super.key});

  @override
  State<RescueApp> createState() => _RescueAppState();
}

class _RescueAppState extends State<RescueApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'RescueTeam - Tactical Ops',
          debugShowCheckedModeBanner: false,
          theme: TacticalTheme.darkTheme,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            scrollbars: false,
            overscroll: false,
          ),
          builder: (context, child) => TacticalDeviceShell(child: child ?? const SizedBox.shrink()),
          home: _appState.isAuthenticated
              ? MainShellScreen(appState: _appState)
              : LoginScreen(
                  appState: _appState,
                  onLoginSuccess: () => setState(() {}),
                  onSosPressed: () => _openSosScreen(context),
                ),
        );
      },
    );
  }

  void _openSosScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmergencySosScreen(
          appState: _appState,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

/// Tactical Mobile Shell: On wide screens (Desktop Web / Tablet), renders as an authentic
/// centered tactical command device with high contrast borders and shadows.
/// On mobile phones / APK, natively fills 100% of the display.
class TacticalDeviceShell extends StatelessWidget {
  final Widget child;

  const TacticalDeviceShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 540) {
          return child;
        }
        return Container(
          color: const Color(0xFF030712), // Deep tactical black backdrop
          alignment: Alignment.center,
          height: constraints.maxHeight,
          child: Container(
            width: 480,
            height: constraints.maxHeight,
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: TacticalColors.surfaceContainerLowest,
              border: Border.symmetric(
                vertical: BorderSide(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  width: 1.5,
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xCC000000),
                  blurRadius: 40,
                  spreadRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRect(child: child),
          ),
        );
      },
    );
  }
}

class MainShellScreen extends StatefulWidget {
  final AppState appState;

  const MainShellScreen({super.key, required this.appState});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  @override
  void initState() {
    super.initState();
    widget.appState.addListener(_showDispatchNotifications);
  }

  @override
  void didUpdateWidget(MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appState != widget.appState) {
      oldWidget.appState.removeListener(_showDispatchNotifications);
      widget.appState.addListener(_showDispatchNotifications);
    }
  }

  @override
  void dispose() {
    widget.appState.removeListener(_showDispatchNotifications);
    super.dispose();
  }

  void _showDispatchNotifications() {
    final notifications = widget.appState.takePendingDispatchNotifications();
    if (notifications.isEmpty || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    for (final incident in notifications) {
      final notificationTitle =
          incident.id.startsWith('SOS-') ? 'SOS verified' : 'Incident verified';
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF12352D),
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.notification_important, color: Color(0xFF6EE7B7)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$notificationTitle: ${incident.title}. '
                  'Team ${incident.teamAssigned} dispatched · ${incident.eta}.',
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'VIEW',
            textColor: const Color(0xFF6EE7B7),
            onPressed: () => widget.appState.setTabIndex(2),
          ),
        ),
      );
    }
  }

  void _openSosScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmergencySosScreen(
          appState: widget.appState,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openTeamChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TacticalChatScreen(
          appState: widget.appState,
          onSosPressed: _openSosScreen,
        ),
      ),
    );
  }

  void _openIncidentDetails(Incident incident) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TacticalChatScreen(
          appState: widget.appState,
          onSosPressed: _openSosScreen,
        ),
      ),
    );
  }

  void _openReportIncidentDialog() {
    showDialog(
      context: context,
      builder: (_) => ReportIncidentDialog(appState: widget.appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final activeIndex = widget.appState.activeTabIndex;

        final List<Widget> pages = [
          HomeDashboardScreen(
            appState: widget.appState,
            onSosPressed: _openSosScreen,
            onOpenMap: () => widget.appState.setTabIndex(1),
            onOpenIncidents: () => widget.appState.setTabIndex(2),
            onOpenTeams: () => widget.appState.setTabIndex(3),
            onReportIncident: _openReportIncidentDialog,
          ),
          LiveMapScreen(
            appState: widget.appState,
            onSosPressed: _openSosScreen,
            onOpenIncidentDetails: _openTeamChat,
          ),
          IncidentListScreen(
            appState: widget.appState,
            onSosPressed: _openSosScreen,
            onSelectIncident: _openIncidentDetails,
            onReportNewIncident: _openReportIncidentDialog,
          ),
          TeamsScreen(
            appState: widget.appState,
            onSosPressed: _openSosScreen,
            onOpenTeamChat: _openTeamChat,
          ),
          SheltersScreen(
            appState: widget.appState,
            onSosPressed: _openSosScreen,
            onAirEvacPressed: _openSosScreen,
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: activeIndex,
            children: pages,
          ),
          bottomNavigationBar: TacticalBottomNavigation(
            currentIndex: activeIndex,
            onTap: (index) {
              widget.appState.setTabIndex(index);
            },
          ),
        );
      },
    );
  }
}
