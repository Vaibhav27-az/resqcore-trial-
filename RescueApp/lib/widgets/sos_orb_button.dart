import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tactical_theme.dart';

class SosOrbButton extends StatefulWidget {
  final VoidCallback onTrigger;
  final bool compact;

  const SosOrbButton({
    super.key,
    required this.onTrigger,
    this.compact = false,
  });

  @override
  State<SosOrbButton> createState() => _SosOrbButtonState();
}

class _SosOrbButtonState extends State<SosOrbButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _holdTimer;
  double _progress = 0.0;
  bool _isHolding = false;
  static const int _holdDurationMs = 3000;
  static const int _tickIntervalMs = 50;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHolding() {
    setState(() {
      _isHolding = true;
      _progress = 0.0;
    });

    HapticFeedback.heavyImpact();

    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: _tickIntervalMs), (timer) {
      setState(() {
        _progress += _tickIntervalMs / _holdDurationMs;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          _triggerSos();
        }
      });
    });
  }

  void _cancelHolding() {
    if (_progress < 1.0) {
      _holdTimer?.cancel();
      setState(() {
        _isHolding = false;
        _progress = 0.0;
      });
    }
  }

  void _triggerSos() {
    HapticFeedback.vibrate();
    setState(() {
      _isHolding = false;
      _progress = 1.0;
    });
    widget.onTrigger();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = widget.compact;
    final size = isCompact ? 160.0 : 220.0;
    final outerRing = isCompact ? 150.0 : 210.0;
    final midRing = isCompact ? 124.0 : 175.0;
    final orbSize = isCompact ? 96.0 : 130.0;
    final coreSize = isCompact ? 84.0 : 114.0;
    final iconSize = isCompact ? 22.0 : 30.0;
    final fontSize = isCompact ? 16.0 : 22.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulseScale = 1.0 + (_pulseController.value * 0.08);
            return SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Pulsing Wave Ring
                  Transform.scale(
                    scale: pulseScale,
                    child: Container(
                      width: outerRing,
                      height: outerRing,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  // Middle Ring
                  Container(
                    width: midRing,
                    height: midRing,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  // Interactive SOS Central Orb
                  GestureDetector(
                    onTapDown: (_) => _startHolding(),
                    onTapUp: (_) => _cancelHolding(),
                    onTapCancel: _cancelHolding,
                    child: SizedBox(
                      width: orbSize,
                      height: orbSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Circular Progress Ring Indicator
                          SizedBox(
                            width: orbSize,
                            height: orbSize,
                            child: CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: isCompact ? 4.0 : 5.0,
                              backgroundColor: Colors.white.withOpacity(0.35),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          // Core Crimson Button
                          Container(
                            width: coreSize,
                            height: coreSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  TacticalColors.emergencyRed,
                                  TacticalColors.secondaryContainer,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: TacticalColors.emergencyRed.withOpacity(_isHolding ? 0.9 : 0.6),
                                  blurRadius: _isHolding ? 36 : 24,
                                  spreadRadius: _isHolding ? 8 : 4,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.call, color: Colors.white, size: iconSize),
                                const SizedBox(height: 2),
                                Text(
                                  'SOS',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: isCompact ? 8 : 16),
        Text(
          _isHolding
              ? 'HOLDING... SENDING IN ${(3 - (_progress * 3)).clamp(0, 3).toStringAsFixed(1)}s'
              : 'Tap & hold 3s for emergency alert',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isCompact ? 11 : 13,
            fontWeight: _isHolding ? FontWeight.w700 : FontWeight.w500,
            color: _isHolding ? TacticalColors.secondaryFixed : TacticalColors.secondaryFixed.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
