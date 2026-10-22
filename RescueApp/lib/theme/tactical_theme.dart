import 'package:flutter/material.dart';

/// Tactical Modernism Design System tokens matching DESIGN.md
class TacticalColors {
  // Base Canvas & Surface Hierarchy
  static const Color surface = Color(0xFF0B1326);
  static const Color surfaceDim = Color(0xFF0B1326);
  static const Color surfaceBright = Color(0xFF31394D);
  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow = Color(0xFF131B2E);
  static const Color surfaceContainer = Color(0xFF171F33);
  static const Color surfaceContainerHigh = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);

  // Foregrounds & Outlines
  static const Color surfaceVariant = Color(0xFF222A3D);
  static const Color surfaceTint = Color(0xFFADC6FF);
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFC2C6D6);
  static const Color outline = Color(0xFF8C909F);
  static const Color outlineVariant = Color(0xFF424754);

  // Tactical Primary Action Colors
  static const Color primary = Color(0xFFADC6FF);
  static const Color onPrimary = Color(0xFF002E6A);
  static const Color primaryContainer = Color(0xFF4D8EFF);
  static const Color onPrimaryContainer = Color(0xFF00285D);
  static const Color electricBlue = Color(0xFF3B82F6);

  // Severe Alert / Emergency Signals
  static const Color secondary = Color(0xFFFFB3AD);
  static const Color onSecondary = Color(0xFF68000A);
  static const Color secondaryContainer = Color(0xFFA40217);
  static const Color onSecondaryContainer = Color(0xFFFFADA8);
  static const Color secondaryFixed = Color(0xFFFFDAD7);
  static const Color secondaryFixedDim = Color(0xFFFFB3AD);
  static const Color emergencyRed = Color(0xFFEF4444);
  static const Color emergencyRedDark = Color(0xFFDC2626);

  // Operational Standby / Emerald
  static const Color tertiary = Color(0xFF4EDEA3);
  static const Color onTertiary = Color(0xFF003824);
  static const Color tertiaryContainer = Color(0xFF00A572);
  static const Color onTertiaryContainer = Color(0xFF00311F);
  static const Color tertiaryFixed = Color(0xFF6FFBBE);
  static const Color tertiaryFixedDim = Color(0xFF4EDEA3);
  static const Color fieldGreen = Color(0xFF10B981);
  static const Color primaryFixed = Color(0xFFD8E2FF);

  // Warning & Escalation
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningAmberBg = Color(0x33F59E0B);

  // Error Tokens
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
}

class TacticalTypography {
  static const String fontFamily = 'Inter';

  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: TacticalColors.onSurface,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLg = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: TacticalColors.onSurface,
    height: 1.33,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineMd = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: TacticalColors.onSurface,
    height: 1.4,
  );

  static const TextStyle headlineSm = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: TacticalColors.onSurface,
    height: 1.33,
  );

  static const TextStyle titleMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TacticalColors.onSurface,
    height: 1.38,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: TacticalColors.onSurface,
    height: 1.47,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TacticalColors.onSurface,
    height: 1.43,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TacticalColors.onSurfaceVariant,
    height: 1.33,
  );

  static const TextStyle labelLg = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: TacticalColors.onSurface,
    height: 1.28,
  );

  static const TextStyle labelMd = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: TacticalColors.onSurface,
    height: 1.33,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: TacticalColors.onSurfaceVariant,
    height: 1.27,
    letterSpacing: 0.3,
  );

  static const TextStyle metricStat = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: TacticalColors.onSurface,
    height: 1.2,
    letterSpacing: -0.5,
  );
}

class TacticalTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: TacticalColors.surface,
      primaryColor: TacticalColors.primary,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: TacticalColors.primary,
        onPrimary: TacticalColors.onPrimary,
        primaryContainer: TacticalColors.primaryContainer,
        onPrimaryContainer: TacticalColors.onPrimaryContainer,
        secondary: TacticalColors.secondary,
        onSecondary: TacticalColors.onSecondary,
        secondaryContainer: TacticalColors.secondaryContainer,
        onSecondaryContainer: TacticalColors.onSecondaryContainer,
        tertiary: TacticalColors.tertiary,
        onTertiary: TacticalColors.onTertiary,
        error: TacticalColors.error,
        onError: TacticalColors.onError,
        surface: TacticalColors.surface,
        onSurface: TacticalColors.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TacticalTypography.headlineSm,
        iconTheme: IconThemeData(color: TacticalColors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: TacticalColors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TacticalColors.primaryContainer,
          foregroundColor: TacticalColors.onPrimaryContainer,
          textStyle: TacticalTypography.labelLg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
