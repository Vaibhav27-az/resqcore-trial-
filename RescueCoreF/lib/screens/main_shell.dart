import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import 'alerts_screen.dart';
import 'home_screen.dart';
import 'inbox_screen.dart';
import 'my_requests_screen.dart';
import 'profile_screen.dart';
import 'welcome_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  void _showProfileModal(BuildContext context) {
    final provider = context.read<RescueProvider>();
    final user = provider.currentUser;
    final isDark = provider.isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceContainerHigh : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.strokeBorder : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryContainer,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: AppTextStyles.headlineSm.copyWith(
                              color: isDark ? AppColors.textWhite : const Color(0xFF0F172A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${user.phoneNumber} • ${provider.isDemoMode ? "Demo Mode" : "Citizen"}',
                            style: AppTextStyles.bodySm.copyWith(
                              color: isDark ? AppColors.textSecondary : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  color: isDark ? AppColors.strokeBorder : const Color(0xFFE2E8F0),
                  height: 1,
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.location_on, color: AppColors.secondary),
                  title: Text(
                    'Sector: ${user.sector}',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: isDark ? AppColors.textWhite : const Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: Text(
                    'Address: ${user.address}',
                    style: AppTextStyles.bodySm.copyWith(
                      color: isDark ? AppColors.textSecondary : const Color(0xFF64748B),
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.favorite, color: AppColors.error),
                  title: Text(
                    'Blood Group: ${user.bloodGroup}',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: isDark ? AppColors.textWhite : const Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: Text(
                    'Contact: ${user.emergencyContactName} (${user.emergencyContactPhone})',
                    style: AppTextStyles.bodySm.copyWith(
                      color: isDark ? AppColors.textSecondary : const Color(0xFF64748B),
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.badge, size: 18),
                        label: const Text('View Full Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        provider.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const WelcomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final currentIndex = provider.activeNavIndex;

    String title;
    String? subtitle;
    Widget body;

    switch (currentIndex) {
      case 0:
        title = 'RescueCore';
        subtitle = 'Home';
        body = const HomeScreen();
        break;
      case 1:
        title = 'RescueCore';
        subtitle = 'Requests';
        body = const MyRequestsScreen();
        break;
      case 2:
        title = 'RescueCore';
        subtitle = 'Alerts';
        body = const AlertsScreen();
        break;
      case 3:
        title = 'RescueCore';
        subtitle = 'Inbox';
        body = const InboxScreen();
        break;
      default:
        title = 'RescueCore';
        subtitle = 'Home';
        body = const HomeScreen();
    }

    return Scaffold(
      backgroundColor: provider.isDarkMode
          ? AppColors.surface
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: title,
              subtitle: subtitle,
              onProfile: () => _showProfileModal(context),
            ),
            Expanded(child: body),
            BottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) => provider.setActiveNavIndex(index),
            ),
          ],
        ),
      ),
    );
  }
}
