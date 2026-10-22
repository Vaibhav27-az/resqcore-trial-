import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rescue_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'main_shell.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<RescueProvider>();
    _controllers = List.generate(
      6,
      (i) => TextEditingController(text: provider.otpDigits[i]),
    );
    _focusNodes = List.generate(6, (_) => FocusNode());

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    final provider = context.read<RescueProvider>();
    final enteredCode = _controllers.map((c) => c.text).join();
    if (enteredCode.length < 6) {
      provider.triggerOtpError();
      _shakeController.forward(from: 0.0);
      return;
    }

    // If initial error demo code (386210), let user experience the exact screen match,
    // and if tapped or changed, allow smooth progression to the Home App!
    if (provider.hasOtpError) {
      _shakeController.forward(from: 0.0);
      // Let's offer a quick toggle or allow proceeding
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceContainerHigh,
          content: Text(
            'Demo: Tap "Verify code" again to accept code and enter Citizen Home.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textWhite),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Auto-Fix',
            textColor: AppColors.primary,
            onPressed: () {
              provider.clearOtpError();
              provider.login();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainShell()),
                (route) => false,
              );
            },
          ),
        ),
      );
      // Next tap will succeed
      provider.clearOtpError();
    } else {
      provider.login();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final hasError = provider.hasOtpError;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Tactical Night S&R Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/scenarios/night_canyon_search.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          // Dark Gradient Scrim
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface.withValues(alpha: 0.82),
                    AppColors.surface.withValues(alpha: 0.94),
                    AppColors.surface,
                  ],
                  stops: const [0.0, 0.40, 0.80],
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
              // Top Navigation Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceContainer,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Verify your number',
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
              const SizedBox(height: 24),

              // Illustration Badge
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.secondary,
                      size: 26,
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerHigh,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: AppColors.primary,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Content Headings
              Text(
                'A quick check.\nThen you’re ready.',
                style: AppTextStyles.headlineXlMobile.copyWith(
                  color: AppColors.textWhite,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'Enter the 6–digit code sent to '),
                    TextSpan(
                      text: '+91 98470 21836',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Change phone number',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Verification Code Section Label
              Text(
                'VERIFICATION CODE',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.outline,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // 6 Code Input Cells
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = (hasError && _shakeController.isAnimating)
                      ? (10 * (1 - _shakeController.value) * ((_shakeController.value * 20).toInt() % 2 == 0 ? 1 : -1))
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(offset.toDouble(), 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 48,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: hasError ? AppColors.error : AppColors.strokeBorder,
                          width: hasError ? 1.5 : 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: AppTextStyles.codeNum.copyWith(
                              color: AppColors.textWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (val) {
                              provider.setOtpDigit(index, val);
                              if (val.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (val.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                          if (hasError)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                color: AppColors.error,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Error Alert Container
              if (hasError) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline,
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
                              'That code doesn’t match',
                              style: AppTextStyles.labelLg.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Check the digits and try again, or request a new code. Your report data stays safe.',
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.onErrorContainer,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Action CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onVerifyPressed,
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
                      Text(
                        'Verify code',
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
              const SizedBox(height: 14),

              // Resend Actions
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Didn’t receive a code? ',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('A new 6-digit code has been sent!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        'Resend code',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Privacy Security Card
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your number is kept private',
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Only the response team handling your request can use it to contact you.',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
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
