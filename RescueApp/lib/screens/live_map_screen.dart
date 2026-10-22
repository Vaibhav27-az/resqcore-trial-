import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../widgets/tactical_header.dart';
import '../widgets/tactical_map_canvas.dart';

class LiveMapScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onSosPressed;
  final VoidCallback onOpenIncidentDetails;

  const LiveMapScreen({
    super.key,
    required this.appState,
    required this.onSosPressed,
    required this.onOpenIncidentDetails,
  });

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'All incidents';
  bool _teamCardVisible = true;
  String _selectedIncident = 'Flood Alert';

  final List<String> _filters = [
    'All incidents',
    'High',
    'Teams',
    'Routes',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: TacticalHeader(
        title: 'Tactical Map',
        appState: widget.appState,
        onSosPressed: widget.onSosPressed,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            // Search Input with Filter Tune Button
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: TacticalColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search, color: TacticalColors.outline, size: 20),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: TacticalColors.onSurface, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search places or incidents',
                        hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: TacticalColors.outline, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Filter parameters: Radius 25km • Uttarakhand Grid UK-07'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Filter Pills Row
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _activeFilter == filter;

                  Color bgColor;
                  Color textColor;
                  Widget dotWidget;

                  if (filter == 'High') {
                    bgColor = isSelected
                        ? TacticalColors.secondaryContainer.withOpacity(0.6)
                        : TacticalColors.secondaryContainer.withOpacity(0.25);
                    textColor = TacticalColors.secondary;
                    dotWidget = Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: TacticalColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    );
                  } else if (filter == 'Teams') {
                    bgColor = isSelected
                        ? TacticalColors.tertiaryContainer.withOpacity(0.5)
                        : TacticalColors.tertiaryContainer.withOpacity(0.2);
                    textColor = TacticalColors.tertiary;
                    dotWidget = Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: TacticalColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    );
                  } else if (filter == 'Routes') {
                    bgColor = TacticalColors.surfaceContainerHigh;
                    textColor = TacticalColors.onSurfaceVariant;
                    dotWidget = Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: TacticalColors.outline,
                        shape: BoxShape.circle,
                      ),
                    );
                  } else {
                    bgColor = isSelected ? TacticalColors.primaryContainer : TacticalColors.surfaceContainerHigh;
                    textColor = isSelected ? TacticalColors.onPrimaryContainer : TacticalColors.onSurface;
                    dotWidget = Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: TacticalColors.surfaceTint,
                        shape: BoxShape.circle,
                      ),
                    );
                  }

                  return InkWell(
                    onTap: () => setState(() => _activeFilter = filter),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? TacticalColors.primaryContainer : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          dotWidget,
                          const SizedBox(width: 6),
                          Text(
                            filter,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      Expanded(
            child: Stack(
              children: [
                // Live Interactive Tactical Map View (Fill entire area)
                Positioned.fill(
                  child: TacticalMapCanvas(
                    showControls: true,
                    onMarkerSelected: (marker) {
                      setState(() => _selectedIncident = marker);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Focusing radar on: $marker'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),

                // Floating Bottom Sheet / Incident Alert Card
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainerLow.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1E293B)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Incident Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Flood Alert',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: TacticalColors.onSurface,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  'Joshimath, UK · 10:24 AM',
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
                                color: TacticalColors.secondaryContainer.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, color: TacticalColors.secondary, size: 7),
                                  SizedBox(width: 4),
                                  Text(
                                    'High',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: TacticalColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Impact Readout
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainer.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning, color: TacticalColors.secondary, size: 16),
                              SizedBox(width: 6),
                              Text(
                                '247 affected',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onSurface,
                                ),
                              ),
                              Text(
                                ' · ',
                                style: TextStyle(color: TacticalColors.outline),
                              ),
                              Expanded(
                                child: Text(
                                  'Road blocked',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: TacticalColors.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Team Assignment Module
                        if (_teamCardVisible) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: TacticalColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                              border: const Border(
                                left: BorderSide(color: TacticalColors.tertiary, width: 3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: TacticalColors.tertiary, size: 14),
                                const SizedBox(width: 6),
                                const Expanded(
                                  child: Text(
                                    'Team Alpha · ETA 12 min (Verified)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: TacticalColors.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => setState(() => _teamCardVisible = false),
                                  child: const Icon(Icons.close, color: TacticalColors.outline, size: 14),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),
                        // Primary Incident Action CTA
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: widget.onOpenIncidentDetails,
                            icon: const Text(
                              'Incident details',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            label: const Icon(Icons.arrow_forward, size: 16),
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
