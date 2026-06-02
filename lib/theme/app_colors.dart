import 'package:flutter/material.dart';

/// Hue Hunt brand palette — aligned with pitch deck and business documents.
abstract final class AppColors {
  static const backgroundDark = Color(0xFF0B1026);
  static const backgroundMid = Color(0xFF2B1B5A);
  static const backgroundLight = Color(0xFF5C2D7A);
  static const primary = Color(0xFF7B2FF7);
  static const accent = Color(0xFF00D4FF);
  static const amber = Color(0xFFFFD166);
  static const boxOrange = Color(0xFFE85D04);

  static const expeditionGradient = LinearGradient(
    colors: [backgroundDark, backgroundMid, backgroundLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
