import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../models/shelter_model.dart';
import '../widgets/tactical_header.dart';

class SheltersScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onSosPressed;
  final VoidCallback onAirEvacPressed;

  const SheltersScreen({
    super.key,
    required this.appState,
    required this.onSosPressed,
    required this.onAirEvacPressed,
  });

  @override
  State<SheltersScreen> createState() => _SheltersScreenState();
}

class _SheltersScreenState extends State<SheltersScreen> {
  String _registryFilter = 'All'; // 'All', 'Missing', 'Safe'

  @override
  Widget build(BuildContext context) {
    final shelters = widget.appState.shelters;
    final evacuees = widget.appState.evacuees;

    final filteredEvacuees = evacuees.where((e) {
      if (_registryFilter == 'Missing') return e.status == 'Missing';
      if (_registryFilter == 'Safe') return e.status == 'Rescued';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: TacticalHeader(
        title: 'Shelters',
        appState: widget.appState,
        onSosPressed: widget.onSosPressed,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
            // Mission Alert Header Ribbon
            // Mission Alert Header Ribbon with Scenario Backdrop
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
                        'assets/images/scenarios/village_flood_evac.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
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
                              TacticalColors.surfaceContainer.withValues(alpha: 0.88),
                              TacticalColors.surfaceContainer.withValues(alpha: 0.6),
                            ],
                            stops: const [0.0, 0.65, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: TacticalColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: TacticalColors.emergencyRed, size: 6),
                            SizedBox(width: 4),
                            Text(
                              'LEVEL 3 CRITICAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.timer, color: TacticalColors.outline, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Active: 04h 18m',
                            style: TextStyle(
                              fontSize: 11,
                              color: TacticalColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mission #JK-402: Joshimath Lower Valley Flash Flood & Landslide',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.hub, color: TacticalColors.tertiary, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Assigned Team: Garhwal SAR Alpha-7 • Comms: SatLink Bravo',
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
                  ],
                ),
              ),
            ),
        const SizedBox(height: 12),

            // Geospatial & Telemetry Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: TacticalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: TacticalColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.share_location, color: TacticalColors.primary, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'TARGET SECTOR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onSurfaceVariant,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Joshimath Ward 4 & Alaknanda Basin',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'Vulnerability 8.9/10',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: TacticalColors.secondary,
                            ),
                          ),
                          Text(
                            '840 people/km²',
                            style: TextStyle(
                              fontSize: 11,
                              color: TacticalColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainerHighest.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning, color: TacticalColors.secondary, size: 12),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'NH-07 Blocked at Km 42',
                                  style: TextStyle(fontSize: 10, color: TacticalColors.onSurface),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainerHighest.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.water_drop, color: TacticalColors.primary, size: 12),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Heavy Rain (14mm/h)',
                                  style: TextStyle(fontSize: 10, color: TacticalColors.primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Field Triage Pulse Counters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'FIELD TRIAGE PULSE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.sync, color: TacticalColors.primary, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Auto-synced',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: TacticalColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Affected
                Expanded(
                  child: _buildTriageCounter(
                    title: 'AFFECTED',
                    count: '247',
                    subtitle: 'Estimated',
                    color: TacticalColors.secondary,
                    barColor: TacticalColors.secondaryContainer,
                    progress: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                // Rescued
                Expanded(
                  child: _buildTriageCounter(
                    title: 'RESCUED',
                    count: '189',
                    subtitle: '76.5% cleared',
                    color: TacticalColors.tertiary,
                    barColor: TacticalColors.tertiaryContainer,
                    progress: 0.765,
                  ),
                ),
                const SizedBox(width: 8),
                // Missing
                Expanded(
                  child: _buildTriageCounter(
                    title: 'MISSING',
                    count: '14',
                    subtitle: 'Active search',
                    color: TacticalColors.secondaryFixed,
                    barColor: TacticalColors.secondary,
                    progress: 0.24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Field Evacuation Actions Grid
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.directions_walk,
                    label: 'Route to Camp',
                    color: TacticalColors.surfaceContainer,
                    iconColor: TacticalColors.primary,
                    textColor: TacticalColors.onSurface,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Safe evacuation corridor to Govt Higher Secondary Camp active'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.person_add,
                    label: 'Report Status',
                    color: TacticalColors.primary,
                    iconColor: TacticalColors.onPrimary,
                    textColor: TacticalColors.onPrimary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opened Civilian / Casualty status logging modal'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.emergency,
                    label: 'Air Evac SOS',
                    color: TacticalColors.secondaryContainer,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    onTap: widget.onAirEvacPressed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detailed People Registry Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Detailed People Registry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TacticalColors.onSurface,
                      ),
                    ),
                    Text(
                      'Real-time civilian log & last tracking points',
                      style: TextStyle(
                        fontSize: 11,
                        color: TacticalColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filteredEvacuees.length} Listed',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Filter Tabs for People Registry
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: TacticalColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildRegistryTab('All (${evacuees.length})', 'All'),
                  _buildRegistryTab('Missing (14)', 'Missing'),
                  _buildRegistryTab('Safe (189)', 'Safe'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Evacuee Cards
            ...filteredEvacuees.map((e) => _buildEvacueeCard(e)),

            const SizedBox(height: 16),

            // Nearby Shelters Section
            const Text(
              'Designated Evacuation Shelters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: TacticalColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),

            ...shelters.map((shelter) => _buildShelterCard(shelter)),

            const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTriageCounter({
    required String title,
    required String count,
    required String subtitle,
    required Color color,
    required Color barColor,
    required double progress,
  }) {
    return Container(
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
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: TacticalColors.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: TacticalColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: TacticalColors.surfaceContainerLowest,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistryTab(String label, String key) {
    final isSelected = _registryFilter == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _registryFilter = key),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? TacticalColors.surfaceBright : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? TacticalColors.onSurface : TacticalColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvacueeCard(Evacuee e) {
    final isMissing = e.status == 'Missing';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TacticalColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMissing ? TacticalColors.secondaryContainer.withOpacity(0.5) : const Color(0xFF1E293B),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    e.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${e.age}y • ${e.gender})',
                    style: const TextStyle(
                      fontSize: 11,
                      color: TacticalColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      e.bloodGroup,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: TacticalColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isMissing
                      ? TacticalColors.secondaryContainer.withOpacity(0.3)
                      : TacticalColors.tertiaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isMissing ? 'MISSING' : 'SAFE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isMissing ? TacticalColors.secondary : TacticalColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: TacticalColors.outline, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Last seen: ${e.lastSeen}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: TacticalColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Notes: ${e.notes}',
            style: const TextStyle(
              fontSize: 11,
              color: TacticalColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelterCard(Shelter shelter) {
    final rate = (shelter.occupancyRate * 100).toInt();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TacticalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shelter.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                  ),
                  Text(
                    '${shelter.location} • ${shelter.distance}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: TacticalColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: rate > 80
                      ? TacticalColors.secondaryContainer.withOpacity(0.3)
                      : TacticalColors.tertiaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$rate% FULL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: rate > 80 ? TacticalColors.secondary : TacticalColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: shelter.occupancyRate,
              backgroundColor: TacticalColors.surfaceContainerLowest,
              valueColor: AlwaysStoppedAnimation<Color>(
                rate > 80 ? TacticalColors.secondary : TacticalColors.tertiary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Capacity: ${shelter.occupied} / ${shelter.capacity} civilians',
                style: const TextStyle(
                  fontSize: 11,
                  color: TacticalColors.outline,
                ),
              ),
              Text(
                shelter.amenities,
                style: const TextStyle(
                  fontSize: 10,
                  color: TacticalColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
