import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../screens/profile_screen.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onProfile;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isDark = provider.isDarkMode;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surface.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.strokeBorder.withValues(alpha: 0.8)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBack) ...[
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.onSurface : const Color(0xFF0F172A),
                    size: 24,
                  ),
                  splashRadius: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.shield,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 18,
                      color: isDark ? AppColors.textWhite : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      style: AppTextStyles.labelSm.copyWith(
                        color: isDark ? AppColors.onSurfaceVariant : const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Theme Toggle Icon Button (Light / Dark mode)
              IconButton(
                onPressed: () => provider.toggleTheme(),
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? AppColors.tertiary : AppColors.primaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 4),
              // User Avatar Button -> Opens Profile Screen
              InkWell(
                onTap: onProfile ??
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
