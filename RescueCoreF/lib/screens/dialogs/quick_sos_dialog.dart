import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rescue_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class QuickSosDialog extends StatefulWidget {
  const QuickSosDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const QuickSosDialog(),
    );
  }

  @override
  State<QuickSosDialog> createState() => _QuickSosDialogState();
}

class _QuickSosDialogState extends State<QuickSosDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isDispatching = false;
  bool _isDispatched = false;
  String _sosId = '';
  String? _dispatchError;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _onDispatchSos() async {
    setState(() {
      _isDispatching = true;
      _dispatchError = null;
    });

    try {
      final req = await context.read<RescueProvider>().triggerQuickSos();
      if (!mounted) return;
      setState(() {
        _isDispatching = false;
        _isDispatched = true;
        _sosId = req.id;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isDispatching = false;
        _dispatchError = error.toString().replaceFirst('Bad state: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();
    final isDark = provider.isDarkMode;
    final dialogBg = isDark ? AppColors.surfaceContainerHigh : Colors.white;
    final textPrimary = isDark ? AppColors.textWhite : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.error, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isDispatched) ...[
              // Strobe pulsing SOS circle
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error.withValues(
                        alpha: 0.2 + (_pulseController.value * 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withValues(
                            alpha: 0.4 + (_pulseController.value * 0.4),
                          ),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.emergency,
                        color: AppColors.error,
                        size: 38,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),

              Text(
                '1-TOUCH QUICK SOS',
                style: AppTextStyles.headlineSm.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Your emergency alert and GPS location will be sent to the command centre for verification before a rescue team is dispatched.',
                style: AppTextStyles.bodySm.copyWith(
                  color: textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (_dispatchError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _dispatchError!,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 14),

              // Location preview pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainerLowest : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primaryContainer, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Location: ${provider.currentLocationName}',
                        style: AppTextStyles.labelSm.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? AppColors.strokeBorder : const Color(0xFFCBD5E1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.labelMd.copyWith(color: textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isDispatching ? null : _onDispatchSos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isDispatching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'DISPATCH NOW',
                              style: AppTextStyles.labelMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Success state
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF10B981),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),

              Text(
                'SOS SENT TO COMMAND CENTRE',
                style: AppTextStyles.headlineSm.copyWith(
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'SOS ID: $_sosId\nThe command centre has been notified. A rescue team will be dispatched after verification.',
                style: AppTextStyles.bodySm.copyWith(
                  color: textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    provider.setActiveNavIndex(1); // Go to requests tab
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Track SOS Status'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
