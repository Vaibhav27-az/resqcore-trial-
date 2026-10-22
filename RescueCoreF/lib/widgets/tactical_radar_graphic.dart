import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TacticalRadarGraphic extends StatefulWidget {
  const TacticalRadarGraphic({super.key});

  @override
  State<TacticalRadarGraphic> createState() => _TacticalRadarGraphicState();
}

class _TacticalRadarGraphicState extends State<TacticalRadarGraphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.05);
        return SizedBox(
          width: 220,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer radar ring
              Container(
                width: 140 * scale,
                height: 140 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerLow,
                  border: Border.all(
                    color: AppColors.strokeBorder.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
              ),
              // Inner radar ring
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                ),
              ),
              // Central glowing core node
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF1D4ED8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.6),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.security,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              // Top-left Orbiting Location Node
              Positioned(
                top: 14,
                left: 42,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                    border: Border.all(
                      color: AppColors.strokeBorder,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Bottom-right Orbiting Vital Signs Node
              Positioned(
                bottom: 18,
                right: 44,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                    border: Border.all(
                      color: AppColors.strokeBorder,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.show_chart,
                      color: AppColors.tertiary,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
