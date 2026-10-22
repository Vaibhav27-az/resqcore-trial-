import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surface.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.98),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.strokeBorder : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home,
              label: 'Home',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.assignment,
              label: 'Requests',
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.cell_tower,
              label: 'Alerts',
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.notifications,
              label: 'Inbox',
              badgeCount: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    int? badgeCount,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primaryBright : AppColors.textTertiary;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minWidth: 56, minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -2,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: AppTextStyles.labelSm.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
