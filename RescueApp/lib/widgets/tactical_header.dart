import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';

class TacticalHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onSosPressed;
  final VoidCallback? onProfilePressed;
  final AppState appState;

  const TacticalHeader({
    super.key,
    required this.title,
    required this.appState,
    this.showBackButton = false,
    this.onBack,
    this.onSosPressed,
    this.onProfilePressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: TacticalColors.surface.withOpacity(0.92),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: TacticalColors.onSurface),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TacticalColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: TacticalColors.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'LIVE MESH',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: TacticalColors.tertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: TacticalTypography.headlineSm.copyWith(
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Emergency SOS Top Button
          InkWell(
            onTap: onSosPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: TacticalColors.secondaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: TacticalColors.secondaryContainer,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.emergency,
                color: TacticalColors.secondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Operative Avatar
          InkWell(
            onTap: onProfilePressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: TacticalColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  appState.userName.isNotEmpty ? appState.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
