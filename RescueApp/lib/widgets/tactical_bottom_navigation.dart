import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';

class TacticalBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TacticalBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF2060E20), // surface-container-lowest with high opacity
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                label: 'Home',
                icon: Icons.grid_view,
              ),
              _buildNavItem(
                index: 1,
                label: 'Map',
                icon: Icons.map,
              ),
              _buildNavItem(
                index: 2,
                label: 'Incidents',
                icon: Icons.assignment,
              ),
              _buildNavItem(
                index: 3,
                label: 'Teams',
                icon: Icons.groups,
              ),
              _buildNavItem(
                index: 4,
                label: 'Shelters',
                icon: Icons.night_shelter,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool isActive = currentIndex == index;
    final Color itemColor = isActive ? TacticalColors.primaryContainer : TacticalColors.outline;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: itemColor,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: itemColor,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
