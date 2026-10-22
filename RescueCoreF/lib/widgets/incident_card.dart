import 'package:flutter/material.dart';
import '../models/emergency_request.dart';
import '../models/emergency_type.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_badge.dart';

class IncidentCard extends StatelessWidget {
  final EmergencyRequest request;
  final VoidCallback? onTap;

  const IncidentCard({
    super.key,
    required this.request,
    this.onTap,
  });

  IconData _getTypeIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.flood:
        return Icons.water_damage;
      case EmergencyType.earthquake:
        return Icons.show_chart;
      case EmergencyType.fire:
        return Icons.local_fire_department;
      case EmergencyType.other:
        return Icons.medical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field Evidence Scenario Photo Strip
            if (request.photoAssetPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          request.photoAssetPath!,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
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
                                AppColors.surfaceContainer.withValues(alpha: 0.95),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera,
                                  size: 10, color: Colors.white70),
                              SizedBox(width: 4),
                              Text(
                                'Field Evidence',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Header Row: Icon, Title, Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getTypeIcon(request.type),
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          request.title,
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: 8),

            // Metadata: Request ID, Time, Location
            Row(
              children: [
                Text(
                  request.id,
                  style: AppTextStyles.labelSm.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.secondaryFixedDim,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '•',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                Text(
                  request.timeLabel,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.location,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Fleet Update Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.strokeBorder.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      request.dispatchIcon,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      request.dispatchUpdate,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.textTertiary,
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
