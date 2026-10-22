import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/incident_card.dart';
import 'dialogs/call_112_dialog.dart';
import 'dialogs/quick_sos_dialog.dart';
import 'dialogs/request_detail_dialog.dart';
import 'dialogs/safety_advice_dialog.dart';
import 'live_map_screen.dart';
import 'profile_screen.dart';
import 'resources_guidance_screen.dart';
import 'wizard/select_emergency_type_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final latestRequest = provider.latestRequest;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Online Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.isDemoMode
                          ? 'Demo Citizen · Kerala Command'
                          : 'Good morning, ${provider.currentUser.fullName.split(" ").first}',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF34D399),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ONLINE',
                      style: AppTextStyles.labelSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Main Headline
          Text(
            "Let's keep you safe.",
            style: AppTextStyles.headlineXlMobile.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          // Geolocation Selector Pill
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Current GPS locked: Fort Kochi, Ernakulam'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.strokeBorder, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    provider.currentLocationName,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_more,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Amber Tactical Advisory Banner with Scenario Photo Backdrop
          InkWell(
            onTap: () => SafetyAdviceDialog.show(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.tertiary.withValues(alpha: 0.45),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
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
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                    // Amber/Dark Scrim
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color(0xFF261204).withValues(alpha: 0.96),
                              const Color(0xFF261204).withValues(alpha: 0.88),
                              const Color(0xFF3B1C06).withValues(alpha: 0.50),
                            ],
                            stops: const [0.0, 0.60, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.tertiary.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.tertiary.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.tertiary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Flood warning near you',
                                      style: AppTextStyles.labelLg.copyWith(
                                        color: AppColors.tertiaryFixed,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiaryContainer
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        'Active Warning',
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.tertiaryFixed,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Low-lying wards of Fort Kochi inundated. Response teams actively clearing road barriers.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View safety advice & live status',
                                      style: AppTextStyles.labelMd.copyWith(
                                        color: AppColors.tertiary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                      color: AppColors.tertiary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 1-TOUCH INSTANT SOS (No form filling required)
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF581C1C), Color(0xFF1E0A0A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEF4444),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => QuickSosDialog.show(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDC2626).withValues(alpha: 0.6),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '1-TOUCH INSTANT SOS',
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '1-CLICK',
                                    style: TextStyle(
                                      color: Color(0xFF991B1B),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Instant dispatch without forms. Immediately alerts nearest rescue units.',
                              style: AppTextStyles.bodySm.copyWith(
                                color: const Color(0xFFFECACA),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Color(0xFFFCA5A5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Emergency CTA Master Card (Detailed wizard report)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.strokeBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Need help right now?',
                      style: AppTextStyles.headlineSm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Share what happened and where you are. A response team can review your request.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Report Emergency Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SelectEmergencyTypeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.primaryContainer.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle,
                          size: 22,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Report emergency',
                          style: AppTextStyles.labelLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Dispatch Hotline Call 112 subtext
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Immediate danger? ',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      InkWell(
                        onTap: () => Call112Dialog.show(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Call 112',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.call,
                              size: 14,
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // LIVE RADAR MAP & TACTICAL UNITS (Affected areas + rescue teams)
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LiveMapScreen()),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // Scenario Photo Backdrop: Command Center Radar Screen
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/scenarios/command_radar_dispatch.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                    // Deep Slate Navy Scrim
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color(0xFF071228).withValues(alpha: 0.95),
                              const Color(0xFF0B1936).withValues(alpha: 0.88),
                              const Color(0xFF0F2B5C).withValues(alpha: 0.45),
                            ],
                            stops: const [0.0, 0.60, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.7),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.radar_rounded,
                              color: Color(0xFF38BDF8),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Live Tactical Map & Radar',
                                      style: AppTextStyles.labelLg.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'LIVE',
                                        style: TextStyle(
                                          color: Color(0xFF38BDF8),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '3 Affected Hazard Zones · 4 Rescue Teams tracked',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Color(0xFF38BDF8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // TACTICAL RESPONSE FLEET IN ACTION (Scenario cards with live fleet capabilities)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Response Fleet',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '4 Deployed Units',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _buildFleetCard(
                  title: 'Marine Boat Unit',
                  unitId: 'Bravo 02',
                  status: 'En Route · 8 min',
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
          const SizedBox(height: 18),

          // EMERGENCY RESOURCES & GUIDANCE (Do's & Don'ts for Disasters)
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ResourcesGuidanceScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.strokeBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF10B981),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disaster Resources & Guidance',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Do's, Don'ts & survival checklists for Flood, Quake & Fire",
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Active Request Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Your latest request',
                    style: AppTextStyles.headlineSm.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  provider.setActiveNavIndex(1); // Switch to Requests tab
                },
                child: Text(
                  'View all',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Incident Card
          IncidentCard(
            request: latestRequest,
            onTap: () => RequestDetailDialog.show(context, latestRequest),
          ),
          const SizedBox(height: 20),

          // Bottom Tactical Quick Action Grid (2 Cards)
          Row(
            children: [
              // Card 1: Live alerts
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.setActiveNavIndex(2); // Alerts tab
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.strokeBorder, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.cell_tower,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                            ),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Live alerts',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '3 area updates',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Card 2: Notifications
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.setActiveNavIndex(3); // Inbox tab
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.strokeBorder, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: AppColors.onSurface,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '2',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.onErrorContainer,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Notifications',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '2 unread messages',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
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
      width: 175,
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
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: accentColor, width: 0.8),
                        ),
                        child: Text(
                          unitId,
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
}
