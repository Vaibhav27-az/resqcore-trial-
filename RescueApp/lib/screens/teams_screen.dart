import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../models/team_member.dart';
import '../widgets/tactical_header.dart';
import '../widgets/tactical_radar_widget.dart';

class TeamsScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onSosPressed;
  final VoidCallback onOpenTeamChat;

  const TeamsScreen({
    super.key,
    required this.appState,
    required this.onSosPressed,
    required this.onOpenTeamChat,
  });

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeTab = 'Active';
  String? _highlightedMember;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamAlpha = widget.appState.teams.first;

    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: TacticalHeader(
        title: 'Teams',
        appState: widget.appState,
        onSosPressed: widget.onSosPressed,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Column(
              children: [
                // Search Bar & Filter Tune Button
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.search, color: TacticalColors.outline, size: 18),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: TacticalColors.onSurface, fontSize: 13),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search team code, callsign, frequency...',
                            hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 13),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune, color: TacticalColors.primary, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Segmented Filter Tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    children: [
                      _buildTab('Active (8)', 'Active', hasPulse: true),
                      _buildTab('Nearby (3)', 'Nearby', hasNearMe: true),
                      _buildTab('All 14 Teams', 'All'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                // Primary Deployment Card: Team Alpha with Scenario Backdrop
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E293B)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/scenarios/forest_k9_search.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topRight,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              TacticalColors.surfaceContainer.withValues(alpha: 0.96),
                              TacticalColors.surfaceContainer.withValues(alpha: 0.90),
                              TacticalColors.surfaceContainer.withValues(alpha: 0.65),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: TacticalColors.primaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'YOUR ASSIGNED UNIT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: TacticalColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: TacticalColors.tertiaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.circle, color: TacticalColors.tertiary, size: 6),
                                SizedBox(width: 4),
                                Text(
                                  'OPR-READY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: TacticalColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: TacticalColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.sensors, color: TacticalColors.primary, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '4/4 SYNCED',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: TacticalColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Team Alpha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Icon(Icons.terrain, color: TacticalColors.tertiary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Mountain Quick Response • Sector 4 Grid Alpha',
                        style: TextStyle(
                          fontSize: 12,
                          color: TacticalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Team Leader / Commander Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.military_tech, color: TacticalColors.primary, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'FIELD COMMANDER',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: TacticalColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '12 Yrs NDRF Veteran',
                              style: TextStyle(
                                fontSize: 11,
                                color: TacticalColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: TacticalColors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: TacticalColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        teamAlpha.commanderName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: TacticalColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: TacticalColors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          teamAlpha.commanderBloodGroup,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: TacticalColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Incident Commander & Alpine Specialist',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: TacticalColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: const [
                                      Icon(Icons.radio, color: TacticalColors.primary, size: 12),
                                      SizedBox(width: 4),
                                      Text(
                                        'Ch 4A (156.8MHz)',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: TacticalColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.circle, color: TacticalColors.tertiary, size: 6),
                                      SizedBox(width: 4),
                                      Text(
                                        'Active On-Site',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: TacticalColors.tertiary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Direct Call Button
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Calling Commander at ${teamAlpha.commanderPhone}'),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: TacticalColors.surfaceBright,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.call, color: TacticalColors.primary, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Member Telemetry & Live Radar Widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.radar, color: TacticalColors.tertiary, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Member Telemetry & GPS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TacticalColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Mesh 100%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: TacticalColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Radar Custom Animation Canvas
                  TacticalRadarWidget(
                    onMemberTapped: (name) {
                      setState(() => _highlightedMember = name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Focusing GPS Telemetry on $name'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Member Roster Cards
                  ...teamAlpha.members.map((member) {
                    final isHighlighted = _highlightedMember == member.name;
                    return _buildMemberCard(member, isHighlighted);
                  }),

                  const SizedBox(height: 14),
                  // Open Tactical Team Chat CTA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: widget.onOpenTeamChat,
                      icon: const Icon(Icons.forum, size: 18),
                      label: const Text(
                        'Open Tactical Team Chat (Ch 4-Alpha)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ],
  ),
);
  }

  Widget _buildTab(String label, String key, {bool hasPulse = false, bool hasNearMe = false}) {
    final isSelected = _activeTab == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = key),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? TacticalColors.surfaceContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasPulse) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: TacticalColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              if (hasNearMe) ...[
                const Icon(Icons.near_me, color: TacticalColors.primary, size: 12),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? TacticalColors.primary : TacticalColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(TeamMember member, bool isHighlighted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TacticalColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? TacticalColors.tertiary : const Color(0xFF1E293B),
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        member.name.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: TacticalColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TacticalColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: TacticalColors.tertiaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              member.role,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: TacticalColors.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        member.specialty,
                        style: const TextStyle(
                          fontSize: 11,
                          color: TacticalColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.battery_5_bar, color: TacticalColors.tertiary, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '${member.batteryLevel}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: TacticalColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: TacticalColors.surfaceContainerLowest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: TacticalColors.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          member.status,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: TacticalColors.tertiary,
                          ),
                        ),
                        const Text(' • ', style: TextStyle(color: TacticalColors.outline)),
                        Text(
                          member.distance,
                          style: const TextStyle(
                            fontSize: 11,
                            color: TacticalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'GPS: ${member.gpsCoords}',
                      style: const TextStyle(
                        fontSize: 9,
                        fontFamily: 'monospace',
                        color: TacticalColors.outline,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tracking ${member.name} at ${member.gpsCoords}'),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.pin_drop, color: TacticalColors.primary, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Track',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: TacticalColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
