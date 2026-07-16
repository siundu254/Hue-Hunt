import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Flashy-yet-elegant overlays — gold foil shimmer, emboss, sparkles, vault aura.
class RaidMapLuxuryEffects {
  RaidMapLuxuryEffects._();

  static const _goldHi = Color(0xFFFFE566);
  static const _gold = Color(0xFFE8C547);
  static const _goldLo = Color(0xFF9A7420);

  static void drawCornerOrnament(Canvas canvas, Offset c, {required bool flipX, required bool flipY}) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(flipX ? -1 : 1, flipY ? -1 : 1);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(18, 2, 24, 14)
      ..quadraticBezierTo(14, 10, 8, 22)
      ..quadraticBezierTo(6, 12, 0, 0);
    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.35));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..shader = const LinearGradient(
          colors: [_goldHi, _gold, _goldLo],
        ).createShader(const Rect.fromLTWH(0, 0, 28, 26)),
    );
    canvas.drawCircle(const Offset(4, 4), 2.5, Paint()..shader = RadialGradient(colors: [_goldHi, _goldLo]).createShader(const Rect.fromCircle(center: Offset(4, 4), radius: 3)));
    canvas.restore();
  }

  static void drawSparkleField(Canvas canvas, Rect area, {required int seed, required double phase, int count = 24}) {
    final rng = math.Random(seed);
    for (var i = 0; i < count; i++) {
      final px = area.left + rng.nextDouble() * area.width;
      final py = area.top + rng.nextDouble() * area.height;
      final pulse = (math.sin(phase * math.pi * 2 + i * 0.9) + 1) * 0.5;
      if (pulse < 0.35) continue;
      _drawStar(canvas, Offset(px, py), 2 + rng.nextDouble() * 2, _goldHi.withValues(alpha: pulse * 0.55));
    }
  }

  static void _drawStar(Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
      final a2 = a + math.pi / 4;
      path.lineTo(c.dx + r * 0.35 * math.cos(a2), c.dy + r * 0.35 * math.sin(a2));
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  static void drawBeamShimmer(Canvas canvas, Path path, Rect bounds, double phase) {
    final shift = phase * bounds.width * 1.4 - bounds.width * 0.2;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment(-1 + shift / bounds.width, -0.5),
          end: Alignment(shift / bounds.width, 0.5),
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.55),
            _goldHi.withValues(alpha: 0.85),
            Colors.white.withValues(alpha: 0.45),
            Colors.transparent,
          ],
          stops: const [0, 0.35, 0.5, 0.65, 1],
        ).createShader(bounds),
    );
  }

  static void drawVaultAura(Canvas canvas, Offset center, double r, double phase) {
    for (var ring = 0; ring < 3; ring++) {
      final pulse = (math.sin(phase * math.pi * 2 + ring * 1.1) + 1) * 0.5;
      final radius = r + 10 + ring * 9;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = const Color(0xFFB794F6).withValues(alpha: 0.12 + pulse * 0.18),
      );
    }
    canvas.drawCircle(
      center,
      r + 6,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _goldHi.withValues(alpha: 0.14 + math.sin(phase * math.pi * 2) * 0.06),
            const Color(0xFF9D7BD8).withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r + 20)),
    );
  }

  static void drawGemStud(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c + const Offset(0, 1), r, Paint()..color = Colors.black.withValues(alpha: 0.4));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          colors: [_goldHi, _gold, _goldLo],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(c, r, Paint()..style = PaintingStyle.stroke..strokeWidth = 0.8..color = Colors.white.withValues(alpha: 0.45));
  }

  static void drawGlassSheen(Canvas canvas, Rect rect) {
    final sheen = Path()
      ..moveTo(rect.left, rect.top + rect.height * 0.15)
      ..lineTo(rect.left + rect.width * 0.45, rect.top + rect.height * 0.15)
      ..lineTo(rect.left + rect.width * 0.25, rect.top + rect.height * 0.55)
      ..lineTo(rect.left, rect.top + rect.height * 0.45)
      ..close();
    canvas.drawPath(sheen, Paint()..color = Colors.white.withValues(alpha: 0.08));
  }

  static void drawEmbossedLabel(
    Canvas canvas,
    String text,
    Offset at,
    TextStyle style, {
    double? maxWidth,
  }) {
    final shadowStyle = style.copyWith(color: Colors.black.withValues(alpha: 0.55));
    final highlightStyle = style.copyWith(color: Colors.white.withValues(alpha: 0.22));
    final goldStyle = style.copyWith(
      foreground: Paint()
        ..shader = LinearGradient(
          colors: [_goldHi, _gold, _goldLo, _goldHi],
          stops: const [0, 0.35, 0.7, 1],
        ).createShader(Rect.fromLTWH(at.dx, at.dy, 140, 18)),
    );
    for (final entry in [
      (shadowStyle, at + const Offset(0, 1.2)),
      (highlightStyle, at + const Offset(0, -0.6)),
      (goldStyle, at),
    ]) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: entry.$1),
        textDirection: ui.TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: maxWidth ?? 240);
      tp.paint(canvas, entry.$2);
    }
  }

  static void drawRimLight(Canvas canvas, RRect rrect) {
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.22),
            Colors.transparent,
            Colors.transparent,
            _goldHi.withValues(alpha: 0.12),
          ],
        ).createShader(rrect.outerRect),
    );
  }

  static void drawTokenJewel(Canvas canvas, Offset pos, Color team, String initial, {bool glow = true}) {
    if (glow) {
      canvas.drawCircle(
        pos,
        14,
        Paint()
          ..shader = RadialGradient(
            colors: [team.withValues(alpha: 0.35), Colors.transparent],
          ).createShader(Rect.fromCircle(center: pos, radius: 14)),
      );
    }
    canvas.drawCircle(pos + const Offset(0, 1.5), 9.5, Paint()..color = Colors.black.withValues(alpha: 0.45));
    canvas.drawCircle(
      pos,
      9.5,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.35),
          colors: [Color.lerp(team, Colors.white, 0.35)!, team, Color.lerp(team, Colors.black, 0.25)!],
        ).createShader(Rect.fromCircle(center: pos, radius: 10)),
    );
    canvas.drawCircle(pos, 9.5, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.6..color = _goldHi.withValues(alpha: 0.9));
    final tp = TextPainter(
      text: TextSpan(
        text: initial,
        style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }
}
