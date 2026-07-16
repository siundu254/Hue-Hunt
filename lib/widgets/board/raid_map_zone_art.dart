import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';

/// Manufacturer-grade isometric room vignettes for The Raid Map corners.
class RaidMapZoneArt {
  RaidMapZoneArt._();

  static const _goldHi = Color(0xFFFFE566);
  static const _gold = Color(0xFFE8C547);

  static void drawLivingRoom(Canvas canvas, Rect zone, Color team) {
    _ambientWash(canvas, zone, team);
    final floor = Rect.fromLTWH(zone.left + 8, zone.top + zone.height * 0.52, zone.width - 16, zone.height * 0.38);
    _rug(canvas, floor, team);

    // Sofa
    final sofa = RRect.fromRectAndRadius(
      Rect.fromLTWH(zone.left + 10, zone.top + zone.height * 0.38, zone.width * 0.58, 22),
      const Radius.circular(6),
    );
    _fillGrad(canvas, sofa.outerRect, [team.withValues(alpha: 0.75), team.withValues(alpha: 0.95)]);
    canvas.drawRRect(sofa, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = Colors.black26);
    for (var i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(zone.left + 16 + i * 18, zone.top + zone.height * 0.34, 14, 10),
          const Radius.circular(3),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.22),
      );
    }

    // Floor lamp + warm pool
    final lampX = zone.right - 22;
    final lampGlow = Offset(lampX + 1.5, zone.top + 14);
    canvas.drawCircle(
      lampGlow,
      22,
      Paint()
        ..shader = RadialGradient(
          colors: [_goldHi.withValues(alpha: 0.22), _gold.withValues(alpha: 0.06), Colors.transparent],
        ).createShader(Rect.fromCircle(center: lampGlow, radius: 22)),
    );
    canvas.drawRect(Rect.fromLTWH(lampX, zone.top + 18, 3, 38), Paint()..color = _gold.withValues(alpha: 0.7));
    canvas.drawCircle(lampGlow, 10, Paint()..color = _goldHi.withValues(alpha: 0.45));
    canvas.drawCircle(lampGlow, 10, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = _gold);

    // Window
    final win = Rect.fromLTWH(zone.left + zone.width * 0.08, zone.top + 12, zone.width * 0.35, 28);
    canvas.drawRRect(RRect.fromRectAndRadius(win, const Radius.circular(2)), Paint()..color = const Color(0xFF8ECAE6).withValues(alpha: 0.35));
    canvas.drawRRect(RRect.fromRectAndRadius(win, const Radius.circular(2)), Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = _gold.withValues(alpha: 0.5));
    canvas.drawLine(win.centerLeft, win.centerRight, Paint()..color = _gold.withValues(alpha: 0.4)..strokeWidth = 1);
    canvas.drawLine(win.topCenter, win.bottomCenter, Paint()..color = _gold.withValues(alpha: 0.4)..strokeWidth = 1);

    // Curtains
    canvas.drawRect(Rect.fromLTWH(win.left - 4, win.top, 4, win.height), Paint()..color = team.withValues(alpha: 0.5));
    canvas.drawRect(Rect.fromLTWH(win.right, win.top, 4, win.height), Paint()..color = team.withValues(alpha: 0.5));
  }

  static void drawStudy(Canvas canvas, Rect zone, Color team) {
    _ambientWash(canvas, zone, team);

    // Bookshelf wall
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 5; col++) {
        final h = 8.0 + (col % 3) * 4;
        final book = Rect.fromLTWH(
          zone.left + 10 + col * 14,
          zone.top + 14 + row * 16 + (12 - h),
          11,
          h,
        );
        final hue = HSLColor.fromColor(team).withLightness(0.25 + (col % 4) * 0.08).toColor();
        canvas.drawRRect(RRect.fromRectAndRadius(book, const Radius.circular(1)), Paint()..color = hue);
      }
    }

    // Desk
    final desk = Rect.fromLTWH(zone.left + 8, zone.top + zone.height * 0.58, zone.width * 0.55, 14);
    _fillGrad(canvas, desk, [const Color(0xFF4A3020), const Color(0xFF2A1808)]);
    canvas.drawRRect(RRect.fromRectAndRadius(desk, const Radius.circular(2)), Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = _gold.withValues(alpha: 0.4));

    // Desk lamp glow
    final lamp = Offset(zone.left + zone.width * 0.52, desk.top - 18);
    canvas.drawCircle(
      lamp,
      16,
      Paint()
        ..shader = RadialGradient(
          colors: [_goldHi.withValues(alpha: 0.2), Colors.transparent],
        ).createShader(Rect.fromCircle(center: lamp, radius: 16)),
    );
    canvas.drawLine(Offset(zone.left + zone.width * 0.48, desk.top), Offset(zone.left + zone.width * 0.52, desk.top - 16),
        Paint()..color = _gold..strokeWidth = 1.5);
    canvas.drawCircle(lamp, 5, Paint()..color = _goldHi.withValues(alpha: 0.65));

    // Globe
    canvas.drawCircle(
      Offset(zone.right - 20, zone.top + zone.height * 0.62),
      11,
      Paint()
        ..shader = RadialGradient(colors: [const Color(0xFF4ECDC4).withValues(alpha: 0.5), team.withValues(alpha: 0.3)])
            .createShader(Rect.fromCircle(center: Offset(zone.right - 20, zone.top + zone.height * 0.62), radius: 11)),
    );
    canvas.drawCircle(Offset(zone.right - 20, zone.top + zone.height * 0.62), 11, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = _gold.withValues(alpha: 0.5));
  }

  static void drawKitchen(Canvas canvas, Rect zone, Color team) {
    _ambientWash(canvas, zone, team);

    // Upper cabinets
    for (var i = 0; i < 4; i++) {
      final cab = Rect.fromLTWH(zone.left + 8 + i * 18, zone.top + 12, 16, 22);
      _fillGrad(canvas, cab, [const Color(0xFFE8E0D0), const Color(0xFFC8B8A0)]);
      canvas.drawRRect(RRect.fromRectAndRadius(cab, const Radius.circular(2)), Paint()..style = PaintingStyle.stroke..strokeWidth = 0.8..color = _gold.withValues(alpha: 0.35));
      canvas.drawCircle(Offset(cab.center.dx, cab.bottom - 4), 1.5, Paint()..color = _goldLo);
    }

    // Counter
    final counter = Rect.fromLTWH(zone.left + 6, zone.top + zone.height * 0.42, zone.width * 0.62, 16);
    _fillGrad(canvas, counter, [const Color(0xFFD4C8B8), const Color(0xFFA89888)]);
    canvas.drawRRect(RRect.fromRectAndRadius(counter, const Radius.circular(2)), Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = Colors.black12);

    // Fridge
    final fridge = RRect.fromRectAndRadius(
      Rect.fromLTWH(zone.right - 30, zone.top + 14, 22, zone.height * 0.55),
      const Radius.circular(3),
    );
    _fillGrad(canvas, fridge.outerRect, [Colors.white.withValues(alpha: 0.85), const Color(0xFFD0D0D0)]);
    canvas.drawRRect(fridge, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = team.withValues(alpha: 0.5));
    canvas.drawLine(Offset(fridge.right - 6, fridge.top + 4), Offset(fridge.right - 6, fridge.bottom - 4),
        Paint()..color = _gold.withValues(alpha: 0.4)..strokeWidth = 1);

    // Kettle on counter
    canvas.drawOval(Rect.fromCenter(center: Offset(counter.left + 18, counter.top - 6), width: 14, height: 10),
        Paint()..color = team.withValues(alpha: 0.7));
    canvas.drawArc(Rect.fromCenter(center: Offset(counter.left + 18, counter.top - 10), width: 8, height: 6), math.pi, math.pi, false,
        Paint()..color = _gold..strokeWidth = 1.5..style = PaintingStyle.stroke);
  }

  static void drawGarden(Canvas canvas, Rect zone, Color team) {
    _ambientWash(canvas, zone, team);

    // Patio stones
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 4; col++) {
        final stone = Rect.fromLTWH(zone.left + 10 + col * 16, zone.top + zone.height * 0.55 + row * 12, 14, 10);
        canvas.drawRRect(
          RRect.fromRectAndRadius(stone, const Radius.circular(2)),
          Paint()..color = Color.lerp(const Color(0xFF9A9088), const Color(0xFF6A6058), (col + row) / 6)!,
        );
      }
    }

    // Door frame
    final door = Rect.fromLTWH(zone.right - 28, zone.top + 14, 20, zone.height * 0.5);
    canvas.drawRRect(RRect.fromRectAndRadius(door, const Radius.circular(2)), Paint()..color = const Color(0xFF5C3820));
    canvas.drawRRect(RRect.fromRectAndRadius(door.deflate(3), const Radius.circular(1)), Paint()..color = const Color(0xFF8B6914).withValues(alpha: 0.4));
    canvas.drawCircle(Offset(door.right - 5, door.center.dy), 2, Paint()..color = _gold);

    // Potted plants
    for (var i = 0; i < 3; i++) {
      final px = zone.left + 14 + i * 16;
      final py = zone.top + zone.height * 0.38;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(px - 5, py + 8, 10, 8), const Radius.circular(2)),
        Paint()..color = const Color(0xFF8B5A2B),
      );
      canvas.drawCircle(Offset(px, py), 7 + i.toDouble(), Paint()..color = team.withValues(alpha: 0.55 + i * 0.1));
      for (var l = 0; l < 4; l++) {
        final a = l * math.pi / 2 + i * 0.4;
        canvas.drawLine(Offset(px, py), Offset(px + 10 * math.cos(a), py + 8 * math.sin(a)),
            Paint()..color = const Color(0xFF2D6A4F).withValues(alpha: 0.7)..strokeWidth = 1.2);
      }
    }

    // Shoes by door
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(zone.right - 38, zone.bottom - 22, 10, 6), const Radius.circular(3)),
      Paint()..color = const Color(0xFF3A2818),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(zone.right - 26, zone.bottom - 20, 10, 6), const Radius.circular(3)),
      Paint()..color = const Color(0xFF4A3828),
    );
  }

  static void drawFiligreeFrame(Canvas canvas, Path zonePath, Color team) {
    final bounds = zonePath.getBounds();
    canvas.drawPath(
      zonePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..shader = LinearGradient(
          colors: [_goldHi, _gold, const Color(0xFF9A7420), _goldHi],
        ).createShader(bounds),
    );
    canvas.drawPath(
      zonePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = Colors.white.withValues(alpha: 0.25),
    );

    // Inner team accent line
    canvas.drawPath(
      zonePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = team.withValues(alpha: 0.35),
    );
  }

  static void drawFoldedSecretDeed(Canvas canvas, Offset corner, BoardCorner boardCorner) {
    final path = Path();
    const s = 22.0;
    switch (boardCorner) {
      case BoardCorner.topLeft:
        path.moveTo(corner.dx, corner.dy);
        path.lineTo(corner.dx + s, corner.dy);
        path.lineTo(corner.dx, corner.dy + s);
      case BoardCorner.topRight:
        path.moveTo(corner.dx, corner.dy);
        path.lineTo(corner.dx - s, corner.dy);
        path.lineTo(corner.dx, corner.dy + s);
      case BoardCorner.bottomLeft:
        path.moveTo(corner.dx, corner.dy);
        path.lineTo(corner.dx + s, corner.dy);
        path.lineTo(corner.dx, corner.dy - s);
      case BoardCorner.bottomRight:
        path.moveTo(corner.dx, corner.dy);
        path.lineTo(corner.dx - s, corner.dy);
        path.lineTo(corner.dx, corner.dy - s);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFAF0DC));
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = _gold);
    final c = switch (boardCorner) {
      BoardCorner.topLeft => corner + const Offset(6, 10),
      BoardCorner.topRight => corner + const Offset(-10, 10),
      BoardCorner.bottomLeft => corner + const Offset(6, -8),
      BoardCorner.bottomRight => corner + const Offset(-10, -8),
    };
  }

  static const _goldLo = Color(0xFF9A7420);

  static void _ambientWash(Canvas canvas, Rect zone, Color team) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(zone, const Radius.circular(4)),
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [team.withValues(alpha: 0.12), Colors.transparent],
        ).createShader(zone),
    );
  }

  static void _rug(Canvas canvas, Rect floor, Color team) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(floor, const Radius.circular(4)),
      Paint()
        ..shader = RadialGradient(
          colors: [team.withValues(alpha: 0.25), team.withValues(alpha: 0.08)],
        ).createShader(floor),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(floor, const Radius.circular(4)),
      Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = _gold.withValues(alpha: 0.35),
    );
  }

  static void _fillGrad(Canvas canvas, Rect r, List<Color> colors) {
    canvas.drawRect(
      r,
      Paint()
        ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors).createShader(r),
    );
  }

  static Path roomZonePath(BoardCorner corner, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final m = size.shortestSide * 0.055;
    final inner = size.shortestSide * 0.21;
    final path = Path();
    switch (corner) {
      case BoardCorner.topLeft:
        path.moveTo(m, m + 14);
        path.lineTo(cx - inner, m + 14);
        path.quadraticBezierTo(cx - inner * 0.55, cy - inner * 0.55, cx - inner * 0.45, cy - inner * 0.45);
        path.lineTo(m + 8, cy - inner * 0.45);
        path.quadraticBezierTo(m, cy - inner * 0.7, m, m + 14);
      case BoardCorner.topRight:
        path.moveTo(size.width - m, m + 14);
        path.lineTo(cx + inner, m + 14);
        path.quadraticBezierTo(cx + inner * 0.55, cy - inner * 0.55, cx + inner * 0.45, cy - inner * 0.45);
        path.lineTo(size.width - m - 8, cy - inner * 0.45);
        path.quadraticBezierTo(size.width - m, cy - inner * 0.7, size.width - m, m + 14);
      case BoardCorner.bottomLeft:
        path.moveTo(m, size.height - m - 28);
        path.lineTo(cx - inner, size.height - m - 28);
        path.quadraticBezierTo(cx - inner * 0.55, cy + inner * 0.55, cx - inner * 0.45, cy + inner * 0.45);
        path.lineTo(m + 8, cy + inner * 0.45);
        path.quadraticBezierTo(m, cy + inner * 0.7, m, size.height - m - 28);
      case BoardCorner.bottomRight:
        path.moveTo(size.width - m, size.height - m - 28);
        path.lineTo(cx + inner, size.height - m - 28);
        path.quadraticBezierTo(cx + inner * 0.55, cy + inner * 0.55, cx + inner * 0.45, cy + inner * 0.45);
        path.lineTo(size.width - m - 8, cy + inner * 0.45);
        path.quadraticBezierTo(size.width - m, cy + inner * 0.7, size.width - m, size.height - m - 28);
    }
    path.close();
    return path;
  }
}
