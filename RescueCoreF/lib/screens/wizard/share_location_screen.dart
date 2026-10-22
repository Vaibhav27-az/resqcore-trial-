import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rescue_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import 'add_report_details_screen.dart';

class ShareLocationScreen extends StatefulWidget {
  const ShareLocationScreen({super.key});

  @override
  State<ShareLocationScreen> createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _addressController;
  late AnimationController _pulseController;
  bool _isDetectingGps = false;
  bool _useSatelliteRadar = true;

  @override
  void initState() {
    super.initState();
    final provider = context.read<RescueProvider>();
    _addressController = TextEditingController(text: provider.draftAddress);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onCurrentLocationPressed() {
    setState(() {
      _isDetectingGps = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isDetectingGps = false;
          _addressController.text = '18, KB Jacob Road, Fort Kochi (Refreshed)';
        });
        context.read<RescueProvider>().setDraftAddress(
              '18, KB Jacob Road, Fort Kochi',
              'Ernakulam, Kerala 682001',
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('GPS Signal Locked: Sector 4-B, Fort Kochi'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'New Request',
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step & Progress Tracker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STEP 2 OF 3 · YOUR LOCATION',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '66%',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 3-Segmented Stepper
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Headline
                    Text(
                      'Help needs the right location.',
                      style: AppTextStyles.headlineXlMobile.copyWith(
                        color: AppColors.textWhite,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Confirm where help is needed, not necessarily where you are right now.',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Interactive Tactical Map Box
                    Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Base Dark Satellite / Vector Map Visual
                            Positioned.fill(
                              child: Image.asset(
                                _useSatelliteRadar
                                    ? 'assets/images/scenarios/command_radar_dispatch.png'
                                    : 'assets/images/map_dark.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFF101927),
                                    child: const Center(
                                      child: Icon(
                                        Icons.map,
                                        size: 64,
                                        color: AppColors.strokeBorder,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Satellite / Vector Mode Switcher Pill
                            Positioned(
                              top: 14,
                              left: 14,
                              child: InkWell(
                                onTap: () => setState(
                                    () => _useSatelliteRadar = !_useSatelliteRadar),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHigh
                                        .withValues(alpha: 0.90),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: AppColors.primaryContainer
                                          .withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _useSatelliteRadar
                                            ? Icons.satellite_alt
                                            : Icons.map,
                                        size: 13,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _useSatelliteRadar
                                            ? 'Overwatch Radar'
                                            : 'Street Vector',
                                        style: AppTextStyles.labelSm.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Tactical Nocturnal Grid & Shimmer Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.surfaceContainerLowest
                                          .withValues(alpha: 0.8),
                                      Colors.transparent,
                                      AppColors.surface.withValues(alpha: 0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Map Geographic Placemark Labels (Sector 4-B)
                            Positioned(
                              top: 24,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'ERNAKULAM',
                                    style: AppTextStyles.labelSm.copyWith(
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textWhite.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  Text(
                                    'Sector 4-B',
                                    style: AppTextStyles.bodySm.copyWith(
                                      fontSize: 10,
                                      color: AppColors.outline.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Map Geographic Placemark Labels (Fort Kochi Basin)
                            Positioned(
                              bottom: 40,
                              left: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FORT KOCHI',
                                    style: AppTextStyles.labelMd.copyWith(
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                  Text(
                                    'Kochi Backwaters Basin',
                                    style: AppTextStyles.bodySm.copyWith(
                                      fontSize: 10,
                                      color: AppColors.secondary.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Center Radar Pin / Pinpoint Target Node
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Tooltip Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerHigh
                                          .withValues(alpha: 0.95),
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x66000000),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'You · Fort Kochi',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: AppColors.textWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Animated Concentric Pulse
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (context, child) {
                                      final wave = _pulseController.value;
                                      return SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Outer pulse wave
                                            Container(
                                              width: 24 + (24 * wave),
                                              height: 24 + (24 * wave),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryContainer
                                                    .withValues(
                                                        alpha: 0.3 * (1 - wave)),
                                              ),
                                            ),
                                            // Mid circle
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryContainer
                                                    .withValues(alpha: 0.35),
                                              ),
                                            ),
                                            // Inner core node
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryContainer,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.primaryContainer,
                                                    blurRadius: 10,
                                                  ),
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
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Recenter Floating Button
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: InkWell(
                                onTap: _onCurrentLocationPressed,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHigh
                                        .withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.my_location,
                                    color: AppColors.secondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            // Disclaimer Pill
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest
                                      .withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Illustrative map · Not for navigation',
                                  style: AppTextStyles.bodySm.copyWith(
                                    fontSize: 10,
                                    color: AppColors.outline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // GPS Status Metadata Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x33064E3B),
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
                                'GPS location selected',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: const Color(0xFF6EE7B7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Sample accuracy ±15 m',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.textSecondary,
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Emergency Address Section
                    Text(
                      'EMERGENCY ADDRESS',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.primaryFixedDim,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _addressController,
                                  style: AppTextStyles.headlineSm.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (val) {
                                    context
                                        .read<RescueProvider>()
                                        .setDraftAddress(val);
                                  },
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Ernakulam, Kerala 682001',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Use my current location link
                    InkWell(
                      onTap: _onCurrentLocationPressed,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isDetectingGps
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                          const SizedBox(width: 8),
                          Text(
                            _isDetectingGps
                                ? 'Detecting GPS signal...'
                                : 'Use my current location',
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info Callout Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppColors.tertiary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Not the right spot? Move the pin or edit the address above. Location is shared directly with your tactical response team.',
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Button: Confirm location
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddReportDetailsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor:
                              AppColors.primaryContainer.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Confirm location',
                              style: AppTextStyles.labelLg.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
            ),
          ],
        ),
      ),
    );
  }
}
