import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SafetyAdviceDialog extends StatelessWidget {
  const SafetyAdviceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const SafetyAdviceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.tertiary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.tertiary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Flood Safety Guidance',
                    style: AppTextStyles.headlineSm.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTip(
              '1. Avoid walking or driving in floodwaters',
              'Just 15 cm of moving water can knock you down, and 30 cm can float a small car.',
            ),
            const SizedBox(height: 10),
            _buildTip(
              '2. Move to higher ground / upper floors',
              'Bring essential medications, battery torches, and vital documents with you.',
            ),
            const SizedBox(height: 10),
            _buildTip(
              '3. Disconnect electrical mains',
              'Turn off the main electrical breaker if water begins entering your home safely.',
            ),
            const SizedBox(height: 10),
            _buildTip(
              '4. Keep communications open',
              'Keep your mobile phone charged and check official state disaster management alerts.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLowest,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.strokeBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Understood',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.tertiaryFixed,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: AppTextStyles.bodySm.copyWith(
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
