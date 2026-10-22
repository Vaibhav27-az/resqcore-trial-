import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hazard_zone.dart';
import '../models/rescue_team.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  int _selectedFilter = 0; // 0: All, 1: Hazards, 2: Rescue Teams
  RescueTeam? _selectedTeam;
  HazardZone? _selectedHazard;
  bool _isOverwatchRadar = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isDark = provider.isDarkMode;
    final teams = provider.rescueTeams;
    final hazards = provider.hazardZones;

    final bgColor = isDark ? AppColors.surface : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.surfaceContainer : Colors.white;
    final textPrimary = isDark ? AppColors.textWhite : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    final borderColor = isDark ? AppColors.strokeBorder : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Live Tactical Radar & Map',
          style: AppTextStyles.headlineSm.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: cardBg,
              child: Row(
                children: [
                  _buildFilterChip('All Units & Hazards', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('🚨 Hazard Zones', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('🚤 Rescue Teams', 2),
                ],
              ),
            ),

            // Tactical Map Container
            Container(
              height: 240,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Base Map Imagery: Radar Recon vs Vector Night Map
                    Positioned.fill(
                      child: Image.asset(
                        _isOverwatchRadar
                            ? 'assets/images/scenarios/command_radar_dispatch.png'
                            : 'assets/images/map_dark.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF101927),
                          child: const Center(
                            child: Icon(Icons.map, size: 64, color: AppColors.outline),
                          ),
                        ),
                      ),
                    ),

                    // Nocturnal Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.surfaceContainerLowest.withValues(alpha: 0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Layer Switcher (Tactical Radar / Vector)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () => setState(() => _isOverwatchRadar = !_isOverwatchRadar),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isOverwatchRadar
                                  ? AppColors.tertiary
                                  : AppColors.primaryContainer,
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(color: Color(0x66000000), blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isOverwatchRadar ? Icons.radar : Icons.map_outlined,
                                size: 13,
                                color: _isOverwatchRadar
                                    ? AppColors.tertiary
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _isOverwatchRadar ? 'RADAR RECON' : 'VECTOR MAP',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // User Location Pin
                    Positioned(
                      top: 110,
                      left: 170,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(color: Color(0x66000000), blurRadius: 4),
                              ],
                            ),
                            child: Text(
                              'You · Fort Kochi',
                              style: AppTextStyles.labelSm.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryContainer,
                              boxShadow: [
                                BoxShadow(color: AppColors.primaryContainer, blurRadius: 8),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bravo 02 Unit Pin
                    Positioned(
                      top: 70,
                      left: 110,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTeam = teams[0];
                            _selectedHazard = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Color(0x66000000), blurRadius: 6),
                            ],
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.directions_boat, size: 14, color: Colors.white),
                        ),
                      ),
                    ),

                    // Delta 04 Unit Pin
                    Positioned(
                      bottom: 60,
                      right: 120,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTeam = teams[1];
                            _selectedHazard = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Color(0x66000000), blurRadius: 6),
                            ],
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.engineering, size: 14, color: Colors.white),
                        ),
                      ),
                    ),

                    // Hazard Zone 1 Pin
                    Positioned(
                      top: 80,
                      right: 100,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedHazard = hazards[0];
                            _selectedTeam = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: const [
                              BoxShadow(color: Color(0x66EF4444), blurRadius: 8),
                            ],
                          ),
                          child: const Icon(Icons.warning, size: 14, color: Colors.white),
                        ),
                      ),
                    ),

                    // Legend Overlay
                    Positioned(
                      bottom: 8,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2563EB))),
                            const SizedBox(width: 4),
                            Text('Rescue Unit', style: AppTextStyles.labelSm.copyWith(fontSize: 10, color: Colors.white)),
                            const SizedBox(width: 8),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error)),
                            const SizedBox(width: 4),
                            Text('Hazard Area', style: AppTextStyles.labelSm.copyWith(fontSize: 10, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Active Data Feed Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  if (_selectedTeam != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2563EB), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.gps_fixed, color: Color(0xFF38BDF8), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Target Locked: ${_selectedTeam!.name} (${_selectedTeam!.eta})',
                              style: AppTextStyles.labelMd.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            color: textSecondary,
                            onPressed: () => setState(() => _selectedTeam = null),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_selectedHazard != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: AppColors.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Hazard Focused: ${_selectedHazard!.name}',
                              style: AppTextStyles.labelMd.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            color: textSecondary,
                            onPressed: () => setState(() => _selectedHazard = null),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_selectedFilter == 0 || _selectedFilter == 1) ...[
                    Text(
                      'NEARBY AFFECTED HAZARD ZONES',
                      style: AppTextStyles.labelSm.copyWith(
                        color: textSecondary,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...hazards.map((h) => _buildHazardCard(h, cardBg, textPrimary, textSecondary, borderColor)),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedFilter == 0 || _selectedFilter == 2) ...[
                    Text(
                      'ACTIVE RESCUE FLEET (DEPLOYED NEAR YOU)',
                      style: AppTextStyles.labelSm.copyWith(
                        color: textSecondary,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...teams.map((t) => _buildTeamCard(t, cardBg, textPrimary, textSecondary, borderColor)),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHazardCard(
    HazardZone h,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: h.severity.color.withValues(alpha: 0.35), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (h.imagePath != null)
              SizedBox(
                height: 80,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      h.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            cardBg.withValues(alpha: 0.95),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: h.severity.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: h.severity.color.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          h.severity.label,
                          style: AppTextStyles.labelSm.copyWith(
                            color: h.severity.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        'Radius ~${h.radius}',
                        style: AppTextStyles.bodySm.copyWith(color: textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    h.name,
                    style: AppTextStyles.labelLg.copyWith(color: textPrimary, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    h.description,
                    style: AppTextStyles.bodySm.copyWith(color: textSecondary, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(
    RescueTeam t,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
              ),
              child: t.imagePath != null
                  ? Image.asset(
                      t.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(t.icon, color: AppColors.primaryContainer, size: 22),
                    )
                  : Icon(t.icon, color: AppColors.primaryContainer, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        t.name,
                        style: AppTextStyles.labelMd.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: t.status.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        t.status.label,
                        style: AppTextStyles.labelSm.copyWith(
                          color: t.status.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  t.currentSector,
                  style: AppTextStyles.bodySm.copyWith(color: textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  'E.T.A: ${t.eta} • ${t.type}',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.primaryContainer,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
