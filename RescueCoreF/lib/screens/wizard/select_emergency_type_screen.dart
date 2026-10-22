import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/emergency_type.dart';
import '../../providers/rescue_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../dialogs/call_112_dialog.dart';
import 'share_location_screen.dart';

class SelectEmergencyTypeScreen extends StatelessWidget {
  const SelectEmergencyTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final selectedType = provider.draftType;

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
                    // Progress Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STEP 1 OF 3 · EMERGENCY TYPE',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '33%',
                            style: AppTextStyles.labelSm.copyWith(
                              fontSize: 10,
                              letterSpacing: 0.8,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress Bar
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header Prompt
                    Text(
                      'What kind of help\ndo you need?',
                      style: AppTextStyles.headlineXlMobile.copyWith(
                        color: AppColors.textWhite,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the closest match. You can explain the situation in the next steps.',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Radio Category List
                    ...EmergencyType.values.map((type) {
                      final isSelected = selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => provider.setDraftType(type),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : AppColors.strokeBorder,
                                width: isSelected ? 2.0 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryContainer
                                            .withValues(alpha: 0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  // Scenario Background Photo
                                  Positioned.fill(
                                    child: Image.asset(
                                      type.imagePath,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerRight,
                                      errorBuilder: (_, _, _) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                  // Gradient Scrim for maximum text contrast
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            (isSelected
                                                    ? const Color(0xFF0C1935)
                                                    : const Color(0xFF0F172A))
                                                .withValues(alpha: 0.95),
                                            (isSelected
                                                    ? const Color(0xFF0C1935)
                                                    : const Color(0xFF0F172A))
                                                .withValues(alpha: 0.82),
                                            (isSelected
                                                    ? const Color(0xFF1D3557)
                                                    : const Color(0xFF1E293B))
                                                .withValues(alpha: 0.40),
                                          ],
                                          stops: const [0.0, 0.55, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Card Content
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryContainer
                                                : AppColors.surfaceContainerHigh
                                                    .withValues(alpha: 0.8),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white.withValues(alpha: 0.4)
                                                  : AppColors.strokeBorder,
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            type.icon,
                                            size: 24,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                type.title,
                                                style: AppTextStyles.headlineSm
                                                    .copyWith(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textWhite,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                type.description,
                                                style: AppTextStyles.bodySm
                                                    .copyWith(
                                                  color: AppColors.textSecondary,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          isSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: isSelected
                                              ? AppColors.primaryBright
                                              : AppColors.outlineVariant,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ShareLocationScreen(),
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
                            Text(
                              'Continue to location',
                              style: AppTextStyles.labelLg.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Advisory Warning Banner
                    InkWell(
                      onTap: () => Call112Dialog.show(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
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
                                color: AppColors.tertiaryContainer
                                    .withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.tertiary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'If someone is in immediate danger',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: AppColors.tertiary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "Call 112 now. Only report from a safe place; don't put yourself at risk to gather details.",
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
