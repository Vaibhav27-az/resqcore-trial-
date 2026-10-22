import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../widgets/sos_orb_button.dart';

class EmergencySosScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onBack;

  const EmergencySosScreen({
    super.key,
    required this.appState,
    required this.onBack,
  });

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  void _onSosTriggered() {
    widget.appState.triggerSos();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: TacticalColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: TacticalColors.emergencyRed, width: 2),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning, color: TacticalColors.emergencyRed, size: 24),
            SizedBox(width: 8),
            Text(
              'SOS TRANSMITTED',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency distress beacon has been broadcasted across the live mesh network!',
              style: TextStyle(color: TacticalColors.onSurface, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TacticalColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Operative: ${widget.appState.userName}',
                    style: const TextStyle(fontSize: 11, color: TacticalColors.primary),
                  ),
                  const Text(
                    'GPS: 30.3165° N, 78.0322° E (Dehradun)',
                    style: TextStyle(fontSize: 11, color: TacticalColors.tertiary),
                  ),
                  const Text(
                    'Dispatched: Team Alpha SAR Unit',
                    style: TextStyle(fontSize: 11, color: TacticalColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK', style: TextStyle(color: TacticalColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TacticalColors.emergencyRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dialing 112 Emergency Dispatch...')),
              );
            },
            child: const Text('Call 112 Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: TacticalColors.primary, size: 20),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Big Crimson Hero SOS Activation Card with Scenario Photo Backdrop
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TacticalColors.emergencyRed.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TacticalColors.emergencyRed.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
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
                          'assets/images/scenarios/highway_ambulance_storm.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                      // Deep Crimson / Tactical Night Scrim
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF5C0710).withValues(alpha: 0.94),
                                const Color(0xFF7A0A17).withValues(alpha: 0.88),
                                const Color(0xFF380308).withValues(alpha: 0.96),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        child: Column(
                          children: [
                            const Text(
                              'Need urgent help?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Concentric Target Pulsing Button with 3-second hold progress ring
                            SosOrbButton(
                              compact: true,
                              onTrigger: _onSosTriggered,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Location & GPS Telemetry Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: TacticalColors.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'GPS CONNECTED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: TacticalColors.tertiary,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.near_me, color: TacticalColors.primary, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'Dehradun, Uttarakhand',
                          style: TextStyle(
                            fontSize: 11,
                            color: TacticalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Emergency Assistance Service Grid (2x2 Compact)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Emergency Assistance Channels',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: TacticalColors.onSurface,
                          ),
                        ),
                        Text(
                          '4 active links',
                          style: TextStyle(
                            fontSize: 10,
                            color: TacticalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactTile(
                            icon: Icons.location_on,
                            title: 'Your Location',
                            subtitle: 'GPS 30.31° N, 78.03° E',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sharing GPS Beacon: 30.3165° N, 78.0322° E')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactTile(
                            icon: Icons.medical_services,
                            title: 'Medical Help',
                            subtitle: 'AIIMS / District ER',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Connecting to District Emergency Medical Response...')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactTile(
                            icon: Icons.groups,
                            title: 'Rescue Team',
                            subtitle: 'Alpha SAR (1.2km)',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Direct radio alert sent to Team Alpha & SDRF')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactTile(
                            icon: Icons.phone_in_talk,
                            title: 'Disaster Line',
                            subtitle: 'State EOC 1070',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Dialing State Emergency Operation Center: 1070')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Immediate Action CTA & Directory Footer
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TacticalColors.secondaryContainer,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dialing 112 Emergency Police/SDRF...')),
                        );
                      },
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text(
                        'Call 112',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '112 Emergency · 108 Ambulance · 1070 Disaster helpline',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: TacticalColors.onSurfaceVariant,
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

  Widget _buildCompactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: TacticalColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            Icon(icon, color: TacticalColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: TacticalColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
