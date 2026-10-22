import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'dialogs/call_112_dialog.dart';

class ResourcesGuidanceScreen extends StatefulWidget {
  const ResourcesGuidanceScreen({super.key});

  @override
  State<ResourcesGuidanceScreen> createState() =>
      _ResourcesGuidanceScreenState();
}

class _ResourcesGuidanceScreenState extends State<ResourcesGuidanceScreen> {
  int _selectedCategory = 0;
  final Set<String> _checkedItems = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isDark = provider.isDarkMode;
    final guides = provider.safetyGuides;
    final currentGuide = guides[_selectedCategory.clamp(0, guides.length - 1)];

    final bgColor = isDark ? AppColors.surface : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.surfaceContainer : Colors.white;
    final textPrimary = isDark ? AppColors.textWhite : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    final borderColor = isDark ? AppColors.strokeBorder : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Emergency Guidance & Do’s / Don’ts',
          style: AppTextStyles.headlineSm.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Tab Selector
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: cardBg,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: guides.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final isSelected = _selectedCategory == i;
                  final g = guides[i];
                  return InkWell(
                    onTap: () => setState(() => _selectedCategory = i),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? g.themeColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSelected ? g.themeColor : borderColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            g.icon,
                            size: 16,
                            color: isSelected ? Colors.white : g.themeColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            g.title,
                            style: AppTextStyles.labelSm.copyWith(
                              color: isSelected ? Colors.white : textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Header description card with scenario backdrop
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: currentGuide.themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: currentGuide.themeColor.withValues(alpha: 0.4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (currentGuide.imagePath != null)
                            Image.asset(
                              currentGuide.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const SizedBox(),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF0F172A).withValues(alpha: 0.72),
                                  const Color(0xFF0A0F1D).withValues(alpha: 0.94),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: currentGuide.themeColor.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: currentGuide.themeColor.withValues(alpha: 0.6),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(currentGuide.icon, color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentGuide.title,
                                        style: AppTextStyles.headlineSm.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        currentGuide.subtitle,
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: const Color(0xFFCBD5E1),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                  const SizedBox(height: 18),

                  // DO's Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '✅ WHAT TO DO (DO’S)',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...currentGuide.dos.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: AppTextStyles.bodySm.copyWith(
                                color: textPrimary,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DONT's Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '❌ WHAT NOT TO DO (DON’TS)',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...currentGuide.donts.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.cancel, color: AppColors.error, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: AppTextStyles.bodySm.copyWith(
                                color: textPrimary,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Emergency Survival Kit Checklist
                  Text(
                    '🎒 SURVIVAL KIT CHECKLIST',
                    style: AppTextStyles.labelSm.copyWith(
                      color: textSecondary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Column(
                      children: currentGuide.kitChecklist.map((item) {
                        final isChecked = _checkedItems.contains(item);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                _checkedItems.remove(item);
                              } else {
                                _checkedItems.add(item);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                                  color: isChecked ? AppColors.primaryContainer : textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: isChecked ? textSecondary : textPrimary,
                                      decoration: isChecked ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Helpline Callout
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.error, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_in_talk, color: AppColors.error, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Hotline: 112',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Fire: 101 • Ambulance: 108 • Disaster Desk: 1077',
                                style: AppTextStyles.bodySm.copyWith(color: textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Call112Dialog.show(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Call 112'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
