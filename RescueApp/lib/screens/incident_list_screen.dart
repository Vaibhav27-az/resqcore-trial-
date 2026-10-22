import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../models/incident.dart';
import '../widgets/tactical_header.dart';

class IncidentListScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onSosPressed;
  final ValueChanged<Incident> onSelectIncident;
  final VoidCallback onReportNewIncident;

  const IncidentListScreen({
    super.key,
    required this.appState,
    required this.onSosPressed,
    required this.onSelectIncident,
    required this.onReportNewIncident,
  });

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeTab = 'All'; // 'All', 'Active', 'Resolved'
  String _searchQuery = '';
  bool _sortBySeverity = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Incident> get _filteredIncidents {
    List<Incident> list = widget.appState.incidents;

    if (_activeTab == 'Active') {
      list = list.where((i) => i.status == 'Active').toList();
    } else if (_activeTab == 'Resolved') {
      list = list.where((i) => i.status == 'Resolved').toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((i) {
        return i.title.toLowerCase().contains(q) ||
            i.location.toLowerCase().contains(q) ||
            i.description.toLowerCase().contains(q);
      }).toList();
    }

    if (_sortBySeverity) {
      list.sort((a, b) {
        final order = {'High': 0, 'Medium': 1, 'Info': 2};
        return (order[a.severity] ?? 3).compareTo(order[b.severity] ?? 3);
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final incidents = _filteredIncidents;

    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: TacticalHeader(
        title: 'Active Incidents',
        appState: widget.appState,
        onSosPressed: widget.onSosPressed,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: TacticalColors.primaryContainer,
        foregroundColor: TacticalColors.onPrimaryContainer,
        onPressed: widget.onReportNewIncident,
        icon: const Icon(Icons.add_alert),
        label: const Text(
          'Report Incident',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              children: [
                // Filter Segmented Bar (All / Active / Resolved)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    children: [
                      _buildFilterTab('All'),
                      _buildFilterTab('Active'),
                      _buildFilterTab('Resolved'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Search Bar
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainerLow,
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
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search incidents or locations',
                            hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 13),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close, color: TacticalColors.outline, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Telemetry Metadata & Sort Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Priority sorted · ${incidents.length} incidents',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TacticalColors.onSurfaceVariant,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _sortBySeverity = !_sortBySeverity),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, color: TacticalColors.primary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            _sortBySeverity ? 'Severity' : 'Default',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: TacticalColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Incident List Cards (Scrolling within viewport only)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
              itemCount: incidents.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index < incidents.length) {
                  return _buildIncidentCard(incidents[index]);
                }
                return _buildOverwatchCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverwatchCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TacticalColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.satellite_alt, color: TacticalColors.tertiary, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Area Overwatch Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: TacticalColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TacticalColors.tertiaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Telemetry Live',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.tertiaryFixedDim,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/scenarios/command_radar_dispatch.png',
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
                            TacticalColors.surfaceContainerLowest.withValues(alpha: 0.95),
                            TacticalColors.surfaceContainerLowest.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TacticalColors.surfaceContainerLowest.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Radar coverage 98.4%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: TacticalColors.onSurface,
                            ),
                          ),
                          Text(
                            'UK-07 Alpine Grid',
                            style: TextStyle(
                              fontSize: 9,
                              color: TacticalColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    final isSelected = _activeTab == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = label),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? TacticalColors.surfaceContainerHighest : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? TacticalColors.primary : TacticalColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncidentCard(Incident inc) {
    Color badgeBg;
    Color badgeTextColor;
    Color iconColor;
    IconData icon;

    if (inc.severity == 'High') {
      badgeBg = TacticalColors.secondaryContainer.withOpacity(0.4);
      badgeTextColor = TacticalColors.secondary;
      iconColor = TacticalColors.secondary;
      icon = Icons.warning;
    } else if (inc.severity == 'Medium') {
      badgeBg = TacticalColors.surfaceContainerHighest;
      badgeTextColor = TacticalColors.secondaryFixedDim;
      iconColor = TacticalColors.warningAmber;
      icon = Icons.landslide;
    } else {
      badgeBg = TacticalColors.surfaceContainerHighest.withOpacity(0.8);
      badgeTextColor = TacticalColors.primary;
      iconColor = TacticalColors.primary;
      icon = Icons.water_drop;
    }

    return InkWell(
      onTap: () => widget.onSelectIncident(inc),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TacticalColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inc.photoAssetPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          inc.photoAssetPath!,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
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
                                TacticalColors.surfaceContainerLow.withValues(alpha: 0.95),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera, size: 10, color: Colors.white70),
                              SizedBox(width: 4),
                              Text(
                                'Field Evidence',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inc.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: TacticalColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          inc.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: TacticalColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: badgeTextColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        inc.severity,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule, color: TacticalColors.outline, size: 14),
                const SizedBox(width: 5),
                Text(
                  inc.timestamp,
                  style: const TextStyle(
                    fontSize: 11,
                    color: TacticalColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: TacticalColors.surfaceContainerLowest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    inc.severity == 'High' ? Icons.verified : Icons.campaign,
                    color: inc.severity == 'High' ? TacticalColors.tertiary : TacticalColors.secondaryFixedDim,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      inc.substatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: inc.severity == 'High' ? TacticalColors.tertiaryFixedDim : TacticalColors.secondaryFixedDim,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: TacticalColors.outline, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
