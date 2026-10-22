import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isDark = provider.isDarkMode;
    final user = provider.currentUser;
    final isDemo = provider.isDemoMode;

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
          'Citizen Profile',
          style: AppTextStyles.headlineSm.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? AppColors.tertiary : AppColors.primaryContainer,
            ),
            onPressed: () => provider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Citizen Readiness Header Banner with summit_sunrise_patrol.png
              Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/scenarios/summit_sunrise_patrol.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0F172A).withValues(alpha: 0.4),
                              const Color(0xFF080D1A).withValues(alpha: 0.92),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: AppColors.primaryContainer),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.shield, color: AppColors.primary, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        'CIVIL DEFENCE NETWORK',
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'ACTIVE CITIZEN ID',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: const Color(0xFF34D399),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Disaster Response Sector: Ernakulam Command',
                              style: AppTextStyles.labelMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Connected to Emergency Dispatch Protocol 112',
                              style: AppTextStyles.bodySm.copyWith(
                                color: const Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // User Avatar & Name Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? const Color(0x33000000) : const Color(0x0A000000),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryContainer,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.fullName,
                                  style: AppTextStyles.headlineSm.copyWith(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: AppColors.primaryContainer,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.phoneNumber,
                            style: AppTextStyles.bodySm.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.primaryContainer,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Demo Mode Status Banner (if in demo mode)
              if (isDemo) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.tertiary.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.tertiary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You are viewing in Demo Mode with simulated disaster scenario and sample reports.',
                          style: AppTextStyles.bodySm.copyWith(
                            color: isDark ? AppColors.tertiaryFixed : const Color(0xFF78350F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Appearance & Theme Settings
              Text(
                'APPEARANCE & SYSTEM',
                style: AppTextStyles.labelSm.copyWith(
                  color: textSecondary,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Dark Mode Theme',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        isDark ? 'Tactical nocturnal dark mode' : 'Crisp daylight mode',
                        style: AppTextStyles.bodySm.copyWith(color: textSecondary),
                      ),
                      secondary: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? AppColors.secondary : AppColors.tertiary,
                      ),
                      value: isDark,
                      onChanged: (val) => provider.setThemeMode(val),
                      activeThumbColor: AppColors.primaryContainer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Medical & Emergency Info Card
              Text(
                'CRITICAL MEDICAL & RESCUE DATA',
                style: AppTextStyles.labelSm.copyWith(
                  color: textSecondary,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.bloodtype,
                      iconColor: AppColors.error,
                      title: 'Blood Group',
                      value: user.bloodGroup,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    Divider(color: borderColor, height: 20),
                    _buildInfoRow(
                      icon: Icons.contact_phone,
                      iconColor: AppColors.primaryContainer,
                      title: 'Emergency Contact',
                      value: '${user.emergencyContactName} • ${user.emergencyContactPhone}',
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    Divider(color: borderColor, height: 20),
                    _buildInfoRow(
                      icon: Icons.medical_information,
                      iconColor: AppColors.tertiary,
                      title: 'Medical Alert / Triage Notes',
                      value: user.medicalNotes,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Registered Address & Sector
              Text(
                'REGISTERED LOCATION',
                style: AppTextStyles.labelSm.copyWith(
                  color: textSecondary,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.home,
                      iconColor: AppColors.secondary,
                      title: 'Home Address',
                      value: user.address,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    Divider(color: borderColor, height: 20),
                    _buildInfoRow(
                      icon: Icons.radar,
                      iconColor: AppColors.primaryContainer,
                      title: 'Civil Defence Sector',
                      value: user.sector,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout / Switch Account Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    provider.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Log out / Switch Account',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelSm.copyWith(
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodySm.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
