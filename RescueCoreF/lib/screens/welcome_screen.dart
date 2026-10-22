import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/tactical_radar_graphic.dart';
import 'verification_screen.dart';
import 'main_shell.dart';
import 'dialogs/call_112_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<RescueProvider>();
    _inputController = TextEditingController(
      text: provider.authMethod == 'phone'
          ? provider.phoneNumber
          : provider.email,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isPhone = provider.authMethod == 'phone';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Tactical Rescue Hero Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_rescue.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          // Gradient Scrim for high contrast & anti-glare
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface.withValues(alpha: 0.78),
                    AppColors.surface.withValues(alpha: 0.92),
                    AppColors.surface,
                  ],
                  stops: const [0.0, 0.38, 0.75],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Top Bar: Brand & Demo Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryContainer.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ResQCore',
                        style: AppTextStyles.headlineSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => provider.toggleTheme(),
                    tooltip: provider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                    icon: Icon(
                      provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: provider.isDarkMode
                          ? AppColors.tertiary
                          : AppColors.primaryContainer,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hero Visual / Tactical Core Radar Graphic
              const Center(
                child: TacticalRadarGraphic(),
              ),
              const SizedBox(height: 8),

              // Hero Titles
              Text(
                'When it matters,\nhelp starts here.',
                style: AppTextStyles.headlineXlMobile.copyWith(
                  color: AppColors.textWhite,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Report an emergency, follow your request and stay informed about risks near you.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Authentication Segmented Track
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
                        onTap: () {
                          provider.setAuthMethod('phone');
                          _inputController.text = provider.phoneNumber;
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isPhone
                                ? AppColors.surfaceContainerHigh
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isPhone
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
                              'Phone number',
                              style: AppTextStyles.labelMd.copyWith(
                                color: isPhone
                                    ? AppColors.textWhite
                                    : AppColors.textSecondary,
                                fontWeight: isPhone
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
                        onTap: () {
                          provider.setAuthMethod('email');
                          _inputController.text = provider.email;
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isPhone
                                ? AppColors.surfaceContainerHigh
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !isPhone
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
                              'Email address',
                              style: AppTextStyles.labelMd.copyWith(
                                color: !isPhone
                                    ? AppColors.textWhite
                                    : AppColors.textSecondary,
                                fontWeight: !isPhone
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
              const SizedBox(height: 16),

              // Form Input Section
              Text(
                isPhone ? 'Mobile number' : 'Email address',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.strokeBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (isPhone) ...[
                      const Icon(
                        Icons.call,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+91',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ] else ...[
                      const Icon(
                        Icons.email,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textWhite,
                          fontSize: 15,
                        ),
                        keyboardType: isPhone
                            ? TextInputType.phone
                            : TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: isPhone
                              ? '98470 21836'
                              : 'your.name@resqcore.org',
                          hintStyle: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.outline,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          if (isPhone) {
                            provider.setPhoneNumber(val);
                          } else {
                            provider.setEmail(val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "We'll send a 6-digit verification code.",
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 20),

              // Primary CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VerificationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: AppColors.primaryContainer.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue securely',
                        style: AppTextStyles.labelLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Create Account Link
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'New to ResQCore? ',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Demo account creation ready!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        'Create an account',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // DEMO MODE (Instant Access without login / fake data)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E3A8A).withValues(alpha: 0.35),
                      const Color(0xFF0F172A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D4ED8).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      provider.enterDemoMode();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 6,
                                  children: [
                                    Text(
                                      'Explore Demo Mode',
                                      style: AppTextStyles.labelLg.copyWith(
                                        color: AppColors.textWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'NO LOGIN',
                                        style: TextStyle(
                                          color: Color(0xFF34D399),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Explore all app screens instantly with simulated Kerala flood & rescue fleet data',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Saved Citizen Profile Quick Login (Live data persistence)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.strokeBorder,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved account: Anjali Nair',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '+91 98470 21836 · Live Kerala Citizen',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        provider.setPhoneNumber('98470 21836');
                        _inputController.text = '98470 21836';
                        provider.login();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const MainShell()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppColors.primary, width: 0.5),
                        ),
                      ),
                      child: Text(
                        'Quick Login',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Direct Emergency Callout Card
              InkWell(
                onTap: () => Call112Dialog.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.strokeBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.phone_in_talk,
                          color: AppColors.error,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Immediate danger? Call 112',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Do not wait for an app response.',
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms & Regional Footer
              Center(
                child: Column(
                  children: [
                    Text(
                      'By continuing, you agree to our Terms & Privacy Policy.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.outline,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Citizen app · Illustrative Kerala scenario',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.outline,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ],
  ),
);
  }
}
