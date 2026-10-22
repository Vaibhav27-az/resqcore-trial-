import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppStatusBar extends StatelessWidget {
  const AppStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.signal_cellular_4_bar,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              SizedBox(width: 4),
              Icon(
                Icons.wifi,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              SizedBox(width: 4),
              Icon(
                Icons.battery_full,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
