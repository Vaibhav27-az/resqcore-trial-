import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../widgets/tactical_header.dart';
import '../widgets/tactical_map_canvas.dart';

class HomeDashboardScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onSosPressed;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenIncidents;
  final VoidCallback onOpenTeams;
  final VoidCallback onReportIncident;

  const HomeDashboardScreen({
    super.key,
    required this.appState,
    required this.onSosPressed,
    required this.onOpenMap,
    required this.onOpenIncidents,
    required this.onOpenTeams,
    required this.onReportIncident,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: TacticalHeader(
        title: 'Home Command',
        appState: appState,
        onSosPressed: onSosPressed,
        onProfilePressed: () => _showUserMenu(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Operational Greeting & Live Pulse Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RescueTeam',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TacticalColors.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Good morning, ${appState.userName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: TacticalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  // Notification Bell with ping dot
                  Stack(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: TacticalColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.notifications, color: TacticalColors.primary, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('3 Priority Broadcasts active in Joshimath & Chamoli'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: TacticalColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            // Critical Emergency Alert Card (Flash Flood) with Scenario Photo Backdrop
            GestureDetector(
              onTap: onOpenIncidents,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TacticalColors.secondaryContainer.withValues(alpha: 0.8),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33A40217),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      // Scenario Photo Backdrop
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/scenarios/flood_response_street.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                      // Amber/Crimson Dark Gradient Scrim
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0xFF2B070B).withValues(alpha: 0.96),
                                const Color(0xFF2B070B).withValues(alpha: 0.88),
                                const Color(0xFF3D0C12).withValues(alpha: 0.55),
                              ],
                              stops: const [0.0, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: TacticalColors.secondary.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: TacticalColors.secondary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Flood Alert – Uttarakhand',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: TacticalColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'High risk in Joshimath · Water level rising rapidly',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: TacticalColors.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: TacticalColors.secondaryFixed,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2x2 Tactical Metrics Grid (Compact)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.75,
              children: [
                // Metric 1: Active Incidents
                _buildMetricCard(
                  title: 'Active Incidents',
                  value: '${appState.incidents.where((i) => i.status == 'Active').length}',
                  subtitle: '1 High · 2 Med',
                  icon: Icons.report_problem,
                  iconColor: TacticalColors.secondary,
                  iconBg: TacticalColors.secondaryContainer.withValues(alpha: 0.3),
                  onTap: onOpenIncidents,
                ),
                // Metric 2: Rescue Teams
                _buildMetricCard(
                  title: 'Rescue Teams',
                  value: '12',
                  subtitle: 'Connected nearby',
                  icon: Icons.groups,
                  iconColor: TacticalColors.primary,
                  iconBg: TacticalColors.primaryContainer.withValues(alpha: 0.2),
                  onTap: onOpenTeams,
                ),
                // Metric 3: People in Need
                _buildMetricCard(
                  title: 'People in Need',
                  value: '${appState.affectedTotal}',
                  subtitle: 'Joshimath region',
                  icon: Icons.person_pin_circle,
                  iconColor: TacticalColors.primary,
                  iconBg: TacticalColors.primary.withValues(alpha: 0.2),
                  onTap: onOpenIncidents,
                ),
                // Metric 4: Your Location
                _buildMetricCard(
                  title: 'Your Location',
                  value: 'Dehradun',
                  subtitle: 'Uttarakhand',
                  icon: Icons.location_on,
                  iconColor: TacticalColors.primary,
                  iconBg: TacticalColors.primaryContainer.withValues(alpha: 0.2),
                  isLocation: true,
                  onTap: onOpenMap,
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Field Units in Active Deployment (Operational Fleet Carousel)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Field units deployed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: TacticalColors.onSurface,
                  ),
                ),
                InkWell(
                  onTap: onOpenTeams,
                  child: Row(
                    children: const [
                      Text(
                        'View all teams',
                        style: TextStyle(
                          fontSize: 11,
                          color: TacticalColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 11, color: TacticalColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 92,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFleetCard(
                    title: 'Swiftwater Boat Unit',
                    unitId: 'Unit Bravo 02',
                    status: 'Active · Joshimath River',
                    imagePath: 'assets/images/scenarios/flood_river_boat.png',
                    accentColor: const Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 10),
                  _buildFleetCard(
                    title: 'Alpine Helicopter',
                    unitId: 'Falcon 01',
                    status: 'Airborne · Sector 9',
                    imagePath: 'assets/images/scenarios/helicopter_mountain_alpine.png',
                    accentColor: const Color(0xFFFBBF24),
                  ),
                  const SizedBox(width: 10),
                  _buildFleetCard(
                    title: 'Wilderness K9 Unit',
                    unitId: 'Canine Alpha',
                    status: 'Ground Search Active',
                    imagePath: 'assets/images/scenarios/forest_k9_search.png',
                    accentColor: const Color(0xFF34D399),
                  ),
                  const SizedBox(width: 10),
                  _buildFleetCard(
                    title: 'Collapse & Triage',
                    unitId: 'Delta 04',
                    status: 'On Scene · Heavy Equip',
                    imagePath: 'assets/images/scenarios/earthquake_rubble_collapse.png',
                    accentColor: const Color(0xFFF87171),
                  ),
                  const SizedBox(width: 10),
                  _buildFleetCard(
                    title: 'Storm Mobile ICU',
                    unitId: 'Echo 01',
                    status: 'Standby Base Camp',
                    imagePath: 'assets/images/scenarios/highway_ambulance_storm.png',
                    accentColor: const Color(0xFFA78BFA),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Quick Actions Section
            const Text(
              'Quick actions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: TacticalColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionBtn(
                    label: 'Report incident',
                    icon: Icons.report_problem,
                    iconColor: TacticalColors.secondary,
                    onTap: onReportIncident,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionBtn(
                    label: 'SOS',
                    icon: Icons.sos,
                    iconColor: TacticalColors.secondary,
                    isSos: true,
                    onTap: onSosPressed,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionBtn(
                    label: 'Find help',
                    icon: Icons.search,
                    iconColor: TacticalColors.primary,
                    onTap: onOpenIncidents,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionBtn(
                    label: 'Volunteer',
                    icon: Icons.volunteer_activism,
                    iconColor: TacticalColors.tertiary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registered as Volunteer Rescuer in Sector 4'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    bool isLocation = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: TacticalColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: TacticalColors.onSurfaceVariant,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(icon, color: iconColor, size: 12),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.onSurface,
                    height: 1.1,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: TacticalColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn({
    required String label,
    required IconData icon,
    required Color iconColor,
    bool isSos = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: isSos
              ? TacticalColors.secondaryContainer.withValues(alpha: 0.2)
              : TacticalColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSos
                ? TacticalColors.secondaryContainer
                : const Color(0xFF1E293B),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSos
                    ? TacticalColors.secondaryContainer.withValues(alpha: 0.4)
                    : TacticalColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: isSos ? FontWeight.bold : FontWeight.w500,
                color: isSos ? TacticalColors.secondary : TacticalColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFleetCard({
    required String title,
    required String unitId,
    required String status,
    required String imagePath,
    required Color accentColor,
  }) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF070E1E).withValues(alpha: 0.95),
                      const Color(0xFF070E1E).withValues(alpha: 0.75),
                      const Color(0xFF070E1E).withValues(alpha: 0.25),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070E1E).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          unitId.toUpperCase(),
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TacticalColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: TacticalColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              appState.userName.isNotEmpty ? appState.userName[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: TacticalColors.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TacticalColors.onSurface,
                              ),
                            ),
                            Text(
                              'Role: ${appState.userRole} · ${appState.userPhone}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: TacticalColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: TacticalColors.outline),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF1E293B)),
                const SizedBox(height: 12),
                const Text(
                  'QUICK PERSONA SWITCH',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('Commander Sharma'),
                      avatar: const Icon(Icons.military_tech, size: 16, color: TacticalColors.primary),
                      backgroundColor: TacticalColors.surfaceContainerHigh,
                      onPressed: () {
                        appState.setDemoRole('Commander', '+91 98110 44201', 'Devank (HQ Commander)');
                        Navigator.pop(ctx);
                      },
                    ),
                    ActionChip(
                      label: const Text('Paramedic Priya'),
                      avatar: const Icon(Icons.medical_services, size: 16, color: TacticalColors.tertiary),
                      backgroundColor: TacticalColors.surfaceContainerHigh,
                      onPressed: () {
                        appState.setDemoRole('Medical', '+91 98223 11842', 'Dr. Priya Sharma (Triage)');
                        Navigator.pop(ctx);
                      },
                    ),
                    ActionChip(
                      label: const Text('Civilian Distress'),
                      avatar: const Icon(Icons.sos, size: 16, color: TacticalColors.secondary),
                      backgroundColor: TacticalColors.surfaceContainerHigh,
                      onPressed: () {
                        appState.setDemoRole('Civilian', '+91 94115 88921', 'Rohan Verma (Resident)');
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TacticalColors.emergencyRed,
                      side: const BorderSide(color: TacticalColors.emergencyRed),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('LOGOUT / RETURN TO ACCESS PORTAL'),
                    onPressed: () {
                      Navigator.pop(ctx);
                      appState.logout();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
