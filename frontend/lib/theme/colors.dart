import 'package:flutter/material.dart';

/// HerCare premium color system.
/// Soft feminine pink + purple palette with a clean neutral base.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFFFF4D8D);
  static const Color primaryDark = Color(0xFFE0397A);
  static const Color secondary = Color(0xFF9B5DE5);
  static const Color accent = Color(0xFFFFC2D1);

  // Gradients
  static const List<Color> brandGradient = [primary, secondary];
  static const List<Color> softGradient = [Color(0xFFFFE3ED), Color(0xFFF3E8FF)];
  static const List<Color> heroGradient = [Color(0xFFFF6FA5), Color(0xFF9B5DE5)];

  // Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Colors.white;
  static const Color glassFill = Color(0xCCFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Water tracker
  static const Color water = Color(0xFF38BDF8);
  static const Color waterLight = Color(0xFFE0F2FE);

  // Shadows
  static Color shadow = primary.withOpacity(0.15);
  static Color shadowSoft = const Color(0xFF1F2937).withOpacity(0.06);
}
