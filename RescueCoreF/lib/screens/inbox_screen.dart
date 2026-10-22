import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: AppTextStyles.headlineLg.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '2 UNREAD',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Direct dispatches, status milestones and response team communications.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),

          _buildNotificationItem(
            isUnread: true,
            icon: Icons.directions_boat,
            iconBg: AppColors.primaryContainer.withValues(alpha: 0.2),
            iconColor: AppColors.primary,
            title: 'Bravo 02 deployed to your location',
            body:
                'Speedboat rescue team en route via Kochi Backwaters basin. Expected arrival window: 12 minutes.',
            time: '09:32',
            imageThumbnail: 'assets/images/scenarios/flood_river_boat.png',
          ),
          const SizedBox(height: 10),

          _buildNotificationItem(
            isUnread: true,
            icon: Icons.verified,
            iconBg: AppColors.secondaryContainer.withValues(alpha: 0.2),
            iconColor: AppColors.secondary,
            title: 'Report verified by Response Command',
            body:
                'Your flood report RQ-261010-0842 was triaged and escalated to High Priority by Zone 04 Command.',
            time: '09:21',
            imageThumbnail: 'assets/images/scenarios/command_radar_dispatch.png',
          ),
          const SizedBox(height: 10),

          _buildNotificationItem(
            isUnread: false,
            icon: Icons.pets,
            iconBg: const Color(0xFF10B981).withValues(alpha: 0.2),
            iconColor: const Color(0xFF34D399),
            title: 'K9 Search Team Sigma deployed in Sector 4',
            body:
                'Search dog unit deployed along wooded perimeter to trace isolated civilians.',
            time: '07:45',
            imageThumbnail: 'assets/images/scenarios/forest_k9_search.png',
          ),
          const SizedBox(height: 10),

          _buildNotificationItem(
            isUnread: false,
            icon: Icons.check_circle_outline,
            iconBg: AppColors.surfaceContainerHigh,
            iconColor: AppColors.success,
            title: 'Evacuation request resolved',
            body:
                'Request RQ-261009-0801 for Amaravathy, Fort Kochi marked as completed yesterday.',
            time: 'Yesterday · 17:15',
            imageThumbnail: 'assets/images/scenarios/village_flood_evac.png',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required bool isUnread,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String body,
    required String time,
    String? imageThumbnail,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.surfaceContainer
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread
              ? AppColors.primaryContainer.withValues(alpha: 0.35)
              : AppColors.strokeBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBright,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (imageThumbnail != null) ...[
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                  imageThumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
