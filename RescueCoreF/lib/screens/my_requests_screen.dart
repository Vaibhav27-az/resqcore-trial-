import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/incident_card.dart';
import 'dialogs/request_detail_dialog.dart';
import 'wizard/select_emergency_type_screen.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isRecentTab = provider.requestsFilterTab == 0;
    final requests = provider.filteredRequests;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Context / Intro Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My requests',
                style: AppTextStyles.headlineLg.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'ACTIVE HUB',
                  style: AppTextStyles.labelSm.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Every report, from submission to resolution. Follow live dispatches and rescue team updates.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),

          // Segmented Control Filter (Recent / All requests)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.strokeBorder.withValues(alpha: 0.6),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => provider.setRequestsFilterTab(0),
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isRecentTab
                            ? AppColors.surfaceContainerHigh
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isRecentTab
                            ? [
                                const BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          'Recent',
                          style: AppTextStyles.labelMd.copyWith(
                            color: isRecentTab
                                ? AppColors.textWhite
                                : AppColors.textSecondary,
                            fontWeight: isRecentTab
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => provider.setRequestsFilterTab(1),
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isRecentTab
                            ? AppColors.surfaceContainerHigh
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: !isRecentTab
                            ? [
                                const BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          'All requests',
                          style: AppTextStyles.labelMd.copyWith(
                            color: !isRecentTab
                                ? AppColors.textWhite
                                : AppColors.textSecondary,
                            fontWeight: !isRecentTab
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRecentTab ? 'Recent reports' : 'All reports',
                style: AppTextStyles.headlineSm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${requests.length} requests',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Cards List
          ...requests.map((req) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IncidentCard(
                request: req,
                onTap: () => RequestDetailDialog.show(context, req),
              ),
            );
          }),
          const SizedBox(height: 12),

          // Report Another Emergency Button
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
                    Icons.add,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Report another emergency',
                    style: AppTextStyles.labelLg.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
