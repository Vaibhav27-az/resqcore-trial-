import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/rescue_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../dialogs/call_112_dialog.dart';
import '../main_shell.dart';

class ReportSubmissionSuccessScreen extends StatefulWidget {
  const ReportSubmissionSuccessScreen({super.key});

  @override
  State<ReportSubmissionSuccessScreen> createState() =>
      _ReportSubmissionSuccessScreenState();
}

class _ReportSubmissionSuccessScreenState
    extends State<ReportSubmissionSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _onCopyId(String id) {
    Clipboard.setData(ClipboardData(text: id));
    setState(() {
      _copied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied Request ID: $id'),
        duration: const Duration(seconds: 1),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final request = provider.lastSubmittedRequest;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Request Details',
              showBack: true,
              onBack: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Status Chip & Sub-header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
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
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Encrypted Dispatch',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Ref #842',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Hero Success Indicator (Tactical Concentric Rings)
                    AnimatedBuilder(
                      animation: _rippleController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ripple wave
                              Container(
                                width: 100 + (20 * _rippleController.value),
                                height: 100 + (20 * _rippleController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondaryContainer
                                      .withValues(
                                          alpha: 0.15 *
                                              (1 - _rippleController.value)),
                                ),
                              ),
                              // Outer circle ring
                              Container(
                                width: 96,
                                height: 96,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerHigh,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              // Mid circle
                              Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerHighest,
                                ),
                              ),
                              // Inner dark beacon core
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerLow,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 28,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Success Messaging
                    Text(
                      'You’ve taken the first step.',
                      style: AppTextStyles.headlineXlMobile.copyWith(
                        color: AppColors.textWhite,
                        height: 1.25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your report has been received. Follow your request for assignment and team updates.',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Deployed Field Unit Tactical Scenario Banner
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryContainer.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryContainer.withValues(alpha: 0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                request?.photoAssetPath ??
                                    'assets/images/scenarios/flood_river_boat.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox.shrink(),
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
                                      const Color(0xFF070E1E).withValues(alpha: 0.70),
                                      const Color(0xFF070E1E).withValues(alpha: 0.35),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981)
                                              .withValues(alpha: 0.25),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: const Color(0xFF10B981),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.radar,
                                              size: 12,
                                              color: Color(0xFF34D399),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'DISPATCH ACTIVE',
                                              style:
                                                  AppTextStyles.labelSm.copyWith(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF34D399),
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceContainerHigh
                                              .withValues(alpha: 0.8),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'ETA · 8 MIN',
                                          style: AppTextStyles.labelSm.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Unit Bravo 02 · Marine Speedboat Assigned',
                                        style: AppTextStyles.labelLg.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Navigating Sector 4-B Waterway towards current GPS lock',
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
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

                    // Incident Verification Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Label & Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'REQUEST ID',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x33F59E0B),
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
                                        color: AppColors.tertiary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Pending',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.tertiary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ID + Copy Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                request?.id ?? 'RQ-261010-0842',
                                style: AppTextStyles.codeNum.copyWith(
                                  color: AppColors.textWhite,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () => _onCopyId(
                                    request?.id ?? 'RQ-261010-0842'),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _copied ? Icons.done : Icons.content_copy,
                                    size: 18,
                                    color: _copied
                                        ? AppColors.success
                                        : AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Incident Category & Geo Metadata
                          Row(
                            children: [
                              const Icon(
                                Icons.waves,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${request?.title ?? "Flood assistance"} · Fort Kochi',
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Submitted 10 Oct 2026, 09:20 · 1 photo',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tactical Dispatch Info Advisory Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'We’ll keep you informed',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Assignment, dispatch and progress updates will appear in your request and notifications.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Live Dispatch Readiness Preview
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shield,
                              color: AppColors.onSurfaceVariant,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rescue Zone 04 Command',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'E.T.A. triage queue: ~4 min',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'STANDBY',
                              style: AppTextStyles.labelSm.copyWith(
                                fontSize: 10,
                                letterSpacing: 0.8,
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action CTAs
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.setActiveNavIndex(1); // Requests tab
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const MainShell()),
                            (route) => false,
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
                              Icons.explore,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Track my request',
                              style: AppTextStyles.labelLg.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.setActiveNavIndex(0); // Home tab
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const MainShell()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          foregroundColor: AppColors.textWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Back to home',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Emergency 112 Footer Callout
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Keep your phone available. If the danger increases, call ',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          InkWell(
                            onTap: () => Call112Dialog.show(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.call,
                                  size: 13,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '112',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            ' instead of waiting for an update.',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
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
