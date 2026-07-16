import 'package:flutter/material.dart';

/// Room Raiders brand palette.
abstract final class AppColors {
  static const backgroundDark = Color(0xFF0A0A0F);
  static const backgroundMid = Color(0xFF1A1028);
  static const backgroundLight = Color(0xFF4B2A8C);
  static const primary = Color(0xFF4B2A8C);
  static const accent = Color(0xFFFF8A00);
  static const amber = Color(0xFFFFC83D);
  static const boxOrange = Color(0xFFFF8A00);

  static const adventureOrange = Color(0xFFFF8A00);
  static const treasureYellow = Color(0xFFFFC83D);
  static const mysteryPurple = Color(0xFF4B2A8C);

  static const expeditionGradient = LinearGradient(
    colors: [backgroundDark, backgroundMid, backgroundLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
