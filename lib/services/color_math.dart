import 'dart:math';
import 'package:flutter/material.dart';

class ColorMath {
  static int channel(double value) => (value * 255.0).round() & 0xff;

  static String toHex(Color color) {
    final r = channel(color.r).toRadixString(16).padLeft(2, '0').toUpperCase();
    final g = channel(color.g).toRadixString(16).padLeft(2, '0').toUpperCase();
    final b = channel(color.b).toRadixString(16).padLeft(2, '0').toUpperCase();
    return '#$r$g$b';
  }

  static Color onColor(Color color) =>
      color.computeLuminance() > 0.42 ? Colors.black : Colors.white;

  static double distance(Color a, Color b) {
    final dr = (channel(a.r) - channel(b.r)).toDouble();
    final dg = (channel(a.g) - channel(b.g)).toDouble();
    final db = (channel(a.b) - channel(b.b)).toDouble();
    return sqrt(dr * dr + dg * dg + db * db);
  }

  static int matchPercent(Color mixed, Color target) {
    final maxDist = sqrt(3 * 255 * 255);
    final dist = distance(mixed, target);
    return ((1 - (dist / maxDist)) * 100).round().clamp(0, 100);
  }

  static Color fromChannels(int r, int g, int b) =>
      Color.fromRGBO(r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255), 1);
}
