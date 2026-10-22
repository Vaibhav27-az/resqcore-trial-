import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';

class TacticalRadarWidget extends StatefulWidget {
  final ValueChanged<String>? onMemberTapped;

  const TacticalRadarWidget({super.key, this.onMemberTapped});

  @override
  State<TacticalRadarWidget> createState() => _TacticalRadarWidgetState();
}

class _TacticalRadarWidgetState extends State<TacticalRadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: TacticalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Custom Painter for radar circles and sweep
            AnimatedBuilder(
              animation: _sweepController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 120),
                  painter: _RadarPainter(sweepAngle: _sweepController.value * 2 * math.pi),
                );
              },
            ),
            // Center Base Station
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: TacticalColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TacticalColors.primary,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Member Blip 1: Priya (Top Left / NW)
            Positioned(
              top: 18,
              left: 45,
              child: _buildBlip(
                label: 'Priya 140m',
                color: TacticalColors.tertiary,
                onTap: () => widget.onMemberTapped?.call('Priya Sharma'),
              ),
            ),
            // Member Blip 2: Vikram (Top Right / NE)
            Positioned(
              top: 14,
              right: 65,
              child: _buildBlip(
                label: 'Vikram 320m',
                color: TacticalColors.tertiary,
                onTap: () => widget.onMemberTapped?.call('Vikram Singh'),
              ),
            ),
            // Member Blip 3: Amit Drone Base (Bottom Left / S)
            Positioned(
              bottom: 16,
              left: 70,
              child: _buildBlip(
                label: 'Drone Base',
                color: TacticalColors.primaryContainer,
                onTap: () => widget.onMemberTapped?.call('Amit Joshi'),
              ),
            ),
            // Member Blip 4: Sunita (Bottom Right / SE)
            Positioned(
              bottom: 14,
              right: 40,
              child: _buildBlip(
                label: 'Amb Pt 600m',
                color: TacticalColors.secondary,
                onTap: () => widget.onMemberTapped?.call('Sunita Devi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlip({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.8),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: TacticalColors.surfaceContainerHigh.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withOpacity(0.3), width: 0.5),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double sweepAngle;

  _RadarPainter({required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.45;

    // Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0x22ADC6FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(Offset(center.dx - maxRadius * 1.5, center.dy),
        Offset(center.dx + maxRadius * 1.5, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius),
        Offset(center.dx, center.dy + maxRadius), gridPaint);

    // Range Rings
    final ringPaint = Paint()
      ..color = const Color(0x33ADC6FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, maxRadius * 0.35, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.70, ringPaint);
    canvas.drawCircle(center, maxRadius, ringPaint);

    // Radar Sweep Line and Cone
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset.center,
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          TacticalColors.tertiary.withOpacity(0.3),
          Colors.transparent,
        ],
        transform: GradientRotation(sweepAngle - math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius, sweepPaint);

    final linePaint = Paint()
      ..color = TacticalColors.tertiary.withOpacity(0.7)
      ..strokeWidth = 1.5;

    final lineEnd = Offset(
      center.dx + maxRadius * math.cos(sweepAngle),
      center.dy + maxRadius * math.sin(sweepAngle),
    );
    canvas.drawLine(center, lineEnd, linePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}
