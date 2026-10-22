import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headlineXl => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.64,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineXlMobile => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        letterSpacing: -0.52,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.36,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: -0.2,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        letterSpacing: 0,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        letterSpacing: 0.12,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelLg => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 20 / 15,
        letterSpacing: -0.075,
        color: AppColors.onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: 0.13,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 14 / 11,
        letterSpacing: 0.44,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get codeNum => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 28 / 24,
        letterSpacing: 1.2,
        color: AppColors.onSurface,
      );
}
