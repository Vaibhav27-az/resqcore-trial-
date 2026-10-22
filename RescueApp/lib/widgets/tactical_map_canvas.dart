import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';

class TacticalMapCanvas extends StatefulWidget {
  final double? height;
  final bool showControls;
  final ValueChanged<String>? onMarkerSelected;

  const TacticalMapCanvas({
    super.key,
    this.height,
    this.showControls = true,
    this.onMarkerSelected,
  });

  @override
  State<TacticalMapCanvas> createState() => _TacticalMapCanvasState();
}

class _TacticalMapCanvasState extends State<TacticalMapCanvas> {
  double _zoom = 1.0;
  bool _showSatellite = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: TacticalColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Map Satellite Base Layer
            if (_showSatellite)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/map_dark.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            // Map Vector & Topography Layer
            Positioned.fill(
              child: Transform.scale(
                scale: _zoom,
                child: CustomPaint(
                  painter: _MapTopographyPainter(isSatellite: _showSatellite),
                ),
              ),
            ),
            // Top HUD Layer: Satellite vs Affected zones toggle
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainerLowest.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _showSatellite = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _showSatellite ? TacticalColors.primaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Satellite',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _showSatellite ? TacticalColors.onPrimaryContainer : TacticalColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _showSatellite = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: !_showSatellite ? TacticalColors.primaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Affected zones',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: !_showSatellite ? TacticalColors.onPrimaryContainer : TacticalColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Map Navigation Controls (Top Right)
            if (widget.showControls)
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    _buildControlBtn(
                      icon: Icons.my_location,
                      color: TacticalColors.primary,
                      onTap: () => setState(() => _zoom = 1.0),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: TacticalColors.surfaceContainerLowest.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Column(
                        children: [
                          _buildControlBtn(
                            icon: Icons.add,
                            color: TacticalColors.onSurface,
                            onTap: () {
                              setState(() {
                                if (_zoom < 1.6) _zoom += 0.15;
                              });
                            },
                          ),
                          Container(height: 1, width: 28, color: const Color(0xFF1E293B)),
                          _buildControlBtn(
                            icon: Icons.remove,
                            color: TacticalColors.onSurface,
                            onTap: () {
                              setState(() {
                                if (_zoom > 0.7) _zoom -= 0.15;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Tactical Zone Markers
            // 1. Chamoli Warning Marker
            Positioned(
              top: (widget.height ?? 320) * 0.28,
              left: 70,
              child: _buildMapMarker(
                title: 'CHAMOLI',
                icon: Icons.warning_amber,
                color: TacticalColors.warningAmber,
                onTap: () => widget.onMarkerSelected?.call('Chamoli Landslide Risk'),
              ),
            ),
            // 2. Joshimath Critical Hazard Marker
            Positioned(
              top: (widget.height ?? 320) * 0.40,
              left: 170,
              child: _buildMapMarker(
                title: 'JOSHIMATH',
                icon: Icons.priority_high,
                color: TacticalColors.emergencyRed,
                isPulsing: true,
                onTap: () => widget.onMarkerSelected?.call('Joshimath Flood Alert'),
              ),
            ),
            // 3. Team Alpha / Unit 04 Deployed Shield
            Positioned(
              top: (widget.height ?? 320) * 0.62,
              left: 90,
              child: InkWell(
                onTap: () => widget.onMarkerSelected?.call('Team Alpha On Route'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainerLowest.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: TacticalColors.tertiary.withOpacity(0.5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user, color: TacticalColors.tertiary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Team Alpha',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: TacticalColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 4. Info Point
            Positioned(
              bottom: 40,
              right: 60,
              child: InkWell(
                onTap: () => widget.onMarkerSelected?.call('Relief Staging Point'),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: TacticalColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline, color: TacticalColors.onPrimaryContainer, size: 16),
                ),
              ),
            ),
            // Bottom Legend Strip
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainerLowest.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem(TacticalColors.emergencyRed, 'High'),
                    _buildLegendItem(TacticalColors.warningAmber, 'Medium'),
                    _buildLegendItem(TacticalColors.primaryContainer, 'Info'),
                    _buildLegendItem(TacticalColors.tertiary, 'Deployed'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: TacticalColors.surfaceContainerLowest.withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  Widget _buildMapMarker({
    required String title,
    required IconData icon,
    required Color color,
    bool isPulsing = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPulsing
                  ? TacticalColors.emergencyRed.withOpacity(0.85)
                  : TacticalColors.surfaceContainerLowest.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isPulsing ? 0.6 : 0.3),
                  blurRadius: isPulsing ? 14 : 8,
                  spreadRadius: isPulsing ? 2 : 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isPulsing ? Colors.white : color,
              size: 20,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: TacticalColors.surfaceContainerLowest.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: TacticalColors.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: TacticalColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MapTopographyPainter extends CustomPainter {
  final bool isSatellite;

  _MapTopographyPainter({required this.isSatellite});

  @override
  void paint(Canvas canvas, Size size) {
    // Canvas background gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F1A2E),
          Color(0xFF060E20),
          Color(0xFF131D31),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Alpine Topo Contour Lines
    final contourPaint = Paint()
      ..color = const Color(0x1A60A5FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i < 6; i++) {
      final path = Path();
      final offset = i * 35.0;
      path.moveTo(0, 40 + offset);
      path.cubicTo(
        size.width * 0.3,
        20 + offset,
        size.width * 0.6,
        70 + offset,
        size.width,
        30 + offset,
      );
      canvas.drawPath(path, contourPaint);
    }

    // Alaknanda River Polyline (Glowing Blue dashed flow)
    final riverGlow = Paint()
      ..color = TacticalColors.primaryContainer.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final riverPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.85)
      ..cubicTo(
        size.width * 0.45,
        size.height * 0.70,
        size.width * 0.65,
        size.height * 0.45,
        size.width * 0.95,
        size.height * 0.25,
      );
    canvas.drawPath(riverPath, riverGlow);

    final riverCore = Paint()
      ..color = TacticalColors.primaryContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(riverPath, riverCore);

    // Chamoli Perimeter Zone (Orange dashed ellipse)
    final chamoliFill = Paint()
      ..color = TacticalColors.warningAmber.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    final chamoliStroke = Paint()
      ..color = TacticalColors.warningAmber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final chamoliRect = Rect.fromCenter(
      center: Offset(size.width * 0.26, size.height * 0.35),
      width: 90,
      height: 70,
    );
    canvas.drawOval(chamoliRect, chamoliFill);
    canvas.drawOval(chamoliRect, chamoliStroke);

    // Joshimath Hazard Critical Perimeter (Red dashed ellipse)
    final joshimathFill = Paint()
      ..color = TacticalColors.emergencyRed.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final joshimathStroke = Paint()
      ..color = TacticalColors.emergencyRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final joshimathRect = Rect.fromCenter(
      center: Offset(size.width * 0.58, size.height * 0.50),
      width: 120,
      height: 85,
    );
    canvas.drawOval(joshimathRect, joshimathFill);
    canvas.drawOval(joshimathRect, joshimathStroke);
  }

  @override
  bool shouldRepaint(covariant _MapTopographyPainter oldDelegate) {
    return oldDelegate.isSatellite != isSatellite;
  }
}
