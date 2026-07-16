import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/services/raid_map_board_assets.dart';
import 'package:hue_hunt/widgets/board/raid_map_luxury_effects.dart';
import 'package:hue_hunt/widgets/board/raid_map_zone_art.dart';

/// The Raid Map — luxury tabletop board (manufacturer / Kickstarter hero reference).
class BoardLayoutPainter extends CustomPainter {
  BoardLayoutPainter({
    required this.venue,
    this.highlightZoneId,
    this.teamScores = const {},
    this.showDimensions = true,
    this.chaosCompassAngle = 0,
    this.shimmerPhase = 0,
    this.roomArt,
    this.vaultEmblem,
  });

  final RaidMapVenueProfile venue;
  final String? highlightZoneId;
  final Map<String, int> teamScores;
  final bool showDimensions;
  final double chaosCompassAngle;
  final double shimmerPhase;
  final Map<BoardCorner, ui.Picture>? roomArt;
  final ui.Picture? vaultEmblem;

  static const _goldHi = Color(0xFFFFE566);
  static const _gold = Color(0xFFE8C547);
  static const _goldLo = Color(0xFF9A7420);
  static const _feltHi = Color(0xFF256B52);
  static const _felt = Color(0xFF1A4D3A);
  static const _feltLo = Color(0xFF0E2E22);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    _drawOuterFrame(canvas, rect, size);
    _drawCharterRibbon(canvas, size);
    _drawFeltField(canvas, size);
    _drawVaultSpotlight(canvas, size);
    for (final team in venue.teams) {
      _drawInlaidRoomEstate(canvas, size, team);
    }
    _drawInlaidCross(canvas, size);
    _drawAllBeamTracks(canvas, size);
    _drawRaidVault(canvas, size);
    _drawBoardHeader(canvas, size);
    RaidMapLuxuryEffects.drawSparkleField(canvas, _playRect(size), seed: venue.id.index + 42, phase: shimmerPhase, count: 18);
    _drawVignette(canvas, size);
    RaidMapLuxuryEffects.drawRimLight(canvas, RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(size.shortestSide * 0.032)));
    if (showDimensions) _drawSpecLine(canvas, size);
  }

  // ─── Frame & atmosphere ─────────────────────────────────────────────

  void _drawOuterFrame(Canvas canvas, Rect rect, Size size) {
    final r = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.032));
    canvas.drawRRect(
      r,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment(-0.8, -1),
          end: Alignment(0.9, 1),
          colors: [Color(0xFF7A4E28), Color(0xFF3D2410), Color(0xFF2A1608), Color(0xFF5C3820)],
          stops: [0, 0.4, 0.7, 1],
        ).createShader(rect),
    );
    _drawWoodGrain(canvas, rect.deflate(4));

    // Gold rail
    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.8
        ..shader = LinearGradient(
          colors: [_goldHi, _gold, _goldLo, _goldHi],
        ).createShader(rect),
    );

    // Corner filigree ornaments
    final m = size.shortestSide * 0.04;
    RaidMapLuxuryEffects.drawCornerOrnament(canvas, Offset(m, m), flipX: false, flipY: false);
    RaidMapLuxuryEffects.drawCornerOrnament(canvas, Offset(size.width - m, m), flipX: true, flipY: false);
    RaidMapLuxuryEffects.drawCornerOrnament(canvas, Offset(m, size.height - m), flipX: false, flipY: true);
    RaidMapLuxuryEffects.drawCornerOrnament(canvas, Offset(size.width - m, size.height - m), flipX: true, flipY: true);
    for (final o in [
      Offset(m, m),
      Offset(size.width - m, m),
      Offset(m, size.height - m),
      Offset(size.width - m, size.height - m),
    ]) {
      RaidMapLuxuryEffects.drawGemStud(canvas, o, 4.5);
    }

    // Inner gold lip
    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _goldHi.withValues(alpha: 0.35),
    );

    // Inner shadow lip (board thickness)
    final lip = rect.deflate(size.shortestSide * 0.02);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lip, Radius.circular(size.shortestSide * 0.028)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.black.withValues(alpha: 0.45),
    );
  }

  void _drawWoodGrain(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    for (var i = 0; i < 28; i++) {
      final baseY = rect.top + rect.height * (i / 28);
      final path = Path()..moveTo(rect.left, baseY);
      for (var x = rect.left; x <= rect.right; x += 6) {
        path.lineTo(x, baseY + math.sin(x * 0.018 + i * 0.7) * 1.8);
      }
      paint.color = Colors.black.withValues(alpha: i.isEven ? 0.07 : 0.04);
      canvas.drawPath(path, paint);
    }
  }

  void _drawVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.032)),
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.42)],
          stops: const [0.55, 1],
        ).createShader(rect),
    );
  }

  // ─── Playing field ────────────────────────────────────────────────────

  Rect _playRect(Size size) {
    final i = size.shortestSide * 0.058;
    return Rect.fromLTWH(i, i + 16, size.width - i * 2, size.height - i * 2 - 38);
  }

  void _drawFeltField(Canvas canvas, Size size) {
    final play = _playRect(size);
    final r = RRect.fromRectAndRadius(play, Radius.circular(size.shortestSide * 0.018));

    canvas.drawRRect(
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.05),
          radius: 1.05,
          colors: [_feltHi, _felt, _feltLo],
          stops: const [0, 0.5, 1],
        ).createShader(play),
    );

    // Felt fibre noise
    final rng = math.Random(venue.id.index + 7);
    for (var n = 0; n < 180; n++) {
      final px = play.left + rng.nextDouble() * play.width;
      final py = play.top + rng.nextDouble() * play.height;
      canvas.drawCircle(
        Offset(px, py),
        0.6 + rng.nextDouble(),
        Paint()..color = Colors.white.withValues(alpha: rng.nextDouble() * 0.04),
      );
    }

    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _gold.withValues(alpha: 0.28),
    );
  }

  void _drawVaultSpotlight(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    canvas.drawCircle(
      c,
      size.width * 0.28,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE566).withValues(alpha: 0.09),
            const Color(0xFF4ECDC4).withValues(alpha: 0.04),
            Colors.transparent,
          ],
          stops: const [0, 0.45, 1],
        ).createShader(Rect.fromCircle(center: c, radius: size.width * 0.28)),
    );
  }

  void _drawInlaidCross(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width * 0.034;
    void plank(Rect r) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(2)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF3A2210), const Color(0xFF1A0E06)],
          ).createShader(r),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(2)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = _gold.withValues(alpha: 0.4),
      );
    }

    plank(Rect.fromCenter(center: Offset(cx, cy), width: w, height: size.height * 0.72));
    plank(Rect.fromCenter(center: Offset(cx, cy), width: size.width * 0.72, height: w));
  }

  // ─── Raid beams (spot-UV gold) ──────────────────────────────────────

  void _drawAllBeamTracks(Canvas canvas, Size size) {
    for (final team in venue.teams) {
      _drawBeamTrack(canvas, size, team);
    }
  }

  void _drawBeamTrack(Canvas canvas, Size size, BoardTeam team) {
    final path = _beamPath(team.corner, size);
    final bounds = path.getBounds();
    final score = teamScores[team.id] ?? 0;

    // Carved trench
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..color = Colors.black.withValues(alpha: 0.55),
    );

    // Gold foil groove — metallic sweep
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_goldLo, _goldHi, _gold, _goldHi, _goldLo],
          stops: const [0, 0.25, 0.5, 0.75, 1],
        ).createShader(bounds),
    );

    // Specular highlight stripe
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.35),
    );

    RaidMapLuxuryEffects.drawBeamShimmer(canvas, path, bounds, shimmerPhase);

    final metrics = path.computeMetrics().first;
    for (var s = 0; s <= BoardPrototypeSpec.winScore; s++) {
      final t = s / BoardPrototypeSpec.winScore;
      final tangent = metrics.getTangentForOffset(metrics.length * t)!;
      _drawBeamPad(canvas, tangent.position, tangent.angle, s, team, score);
    }
  }

  void _drawBeamPad(Canvas canvas, Offset pos, double ang, int space, BoardTeam team, int score) {
    final kind = _spaceKind(space);
    final active = space == score;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(ang);

    const pw = 14.0;
    const ph = 10.0;
    final pad = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: pw, height: ph),
      const Radius.circular(2.5),
    );

    final base = switch (kind) {
      'crown' => _goldHi,
      'hq' => const Color(0xFF1A5C40),
      'chaos' => const Color(0xFF4A2800),
      'death' => const Color(0xFF4A1515),
      'bounty' => const Color(0xFF4A3A08),
      _ => const Color(0xFF2C2418),
    };

    // Drop shadow
    canvas.drawRRect(pad.shift(const Offset(0.5, 1.2)), Paint()..color = Colors.black.withValues(alpha: 0.5));

    // Body
    canvas.drawRRect(
      pad,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(base, Colors.white, 0.22)!,
            base,
            Color.lerp(base, Colors.black, 0.2)!,
          ],
        ).createShader(pad.outerRect),
    );

    // Bevel highlight / shadow
    canvas.drawLine(const Offset(-pw / 2 + 1, -ph / 2 + 1), Offset(pw / 2 - 1, -ph / 2 + 1),
        Paint()..color = Colors.white.withValues(alpha: 0.35)..strokeWidth = 0.8);
    canvas.drawLine(Offset(-pw / 2 + 1, ph / 2 - 1), Offset(pw / 2 - 1, ph / 2 - 1),
        Paint()..color = Colors.black.withValues(alpha: 0.35)..strokeWidth = 0.8);

    canvas.drawRRect(
      pad,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 2 : 1
        ..color = active ? Colors.white : _gold.withValues(alpha: 0.65),
    );

    final numColor = kind == 'crown' || kind == 'hq' ? const Color(0xFF1A1008) : Colors.white.withValues(alpha: 0.85);
    _text(canvas, '$space', const Offset(-4, -4), TextStyle(color: numColor, fontSize: 6.5, fontWeight: FontWeight.w900));

    canvas.restore();

    if (active) {
      RaidMapLuxuryEffects.drawTokenJewel(
        canvas,
        pos + const Offset(0, -13),
        team.color,
        team.name.isNotEmpty ? team.name[0].toUpperCase() : '?',
      );
    }
    if (kind == 'crown') _text(canvas, '👑', pos + const Offset(-5, -22), const TextStyle(fontSize: 9));
    if (kind == 'chaos' && !active) _text(canvas, '⚡', pos + const Offset(-4, -20), const TextStyle(fontSize: 7));
    if (kind == 'bounty' && !active) _text(canvas, '★', pos + const Offset(-4, -20), const TextStyle(fontSize: 7));
  }

  String _spaceKind(int s) {
    if (s == 0) return 'hq';
    if (s == BoardPrototypeSpec.winScore) return 'crown';
    if (s == BoardPrototypeSpec.suddenDeathSpace) return 'death';
    if (BoardPrototypeSpec.chaosCheckpoints.contains(s)) return 'chaos';
    if (BoardPrototypeSpec.bountySpaces.contains(s)) return 'bounty';
    return 'loot';
  }

  Path _beamPath(BoardCorner corner, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path();
    const ins = 0.22;

    switch (corner) {
      case BoardCorner.topLeft:
        path.moveTo(size.width * ins, size.height * 0.355);
        path.quadraticBezierTo(size.width * 0.31, size.height * 0.255, cx - 50, cy - 40);
        path.quadraticBezierTo(cx - 26, cy - 16, cx - 44, cy);
      case BoardCorner.topRight:
        path.moveTo(size.width * (1 - ins), size.height * 0.355);
        path.quadraticBezierTo(size.width * 0.69, size.height * 0.255, cx + 50, cy - 40);
        path.quadraticBezierTo(cx + 26, cy - 16, cx + 44, cy);
      case BoardCorner.bottomLeft:
        path.moveTo(size.width * ins, size.height * 0.645);
        path.quadraticBezierTo(size.width * 0.31, size.height * 0.745, cx - 50, cy + 40);
        path.quadraticBezierTo(cx - 26, cy + 16, cx - 44, cy);
      case BoardCorner.bottomRight:
        path.moveTo(size.width * (1 - ins), size.height * 0.645);
        path.quadraticBezierTo(size.width * 0.69, size.height * 0.745, cx + 50, cy + 40);
        path.quadraticBezierTo(cx + 26, cy + 16, cx + 44, cy);
    }
    return path;
  }

  void _drawSvgVignette(Canvas canvas, Rect art, ui.Picture picture) {
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(art, const Radius.circular(5)));
    final sx = art.width / RaidMapBoardAssets.roomArtSize.width;
    final sy = art.height / RaidMapBoardAssets.roomArtSize.height;
    canvas.translate(art.left, art.top);
    canvas.scale(sx, sy);
    canvas.drawPicture(picture);
    canvas.restore();
    canvas.drawRRect(
      RRect.fromRectAndRadius(art, const Radius.circular(5)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = _gold.withValues(alpha: 0.35),
    );
  }

  // ─── Inlaid room estates (quad-fold quadrants) ───────────────────────

  void _drawInlaidRoomEstate(Canvas canvas, Size size, BoardTeam team) {
    final zonePath = RaidMapZoneArt.roomZonePath(team.corner, size);
    final bounds = zonePath.getBounds();

    // Carved recess shadow
    canvas.drawPath(
      zonePath.shift(const Offset(1.5, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );

    // Team-tinted felt inlay
    canvas.save();
    canvas.clipPath(zonePath);
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(_feltHi, team.color, 0.22)!,
            Color.lerp(_felt, team.color, 0.18)!,
            Color.lerp(_feltLo, team.color, 0.12)!,
          ],
        ).createShader(bounds),
    );

    // Felt weave cross-hatch
    final weave = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4
      ..color = Colors.black.withValues(alpha: 0.06);
    for (var x = bounds.left; x < bounds.right; x += 5) {
      canvas.drawLine(Offset(x, bounds.top), Offset(x, bounds.bottom), weave);
    }
    for (var y = bounds.top; y < bounds.bottom; y += 5) {
      canvas.drawLine(Offset(bounds.left, y), Offset(bounds.right, y), weave);
    }

    final art = Rect.fromLTRB(
      bounds.left + bounds.width * 0.08,
      bounds.top + bounds.height * 0.14,
      bounds.right - bounds.width * 0.08,
      bounds.bottom - bounds.height * 0.22,
    );
    final svgPic = roomArt?[team.corner];
    if (svgPic != null) {
      _drawSvgVignette(canvas, art, svgPic);
    } else {
      switch (team.corner) {
        case BoardCorner.topLeft:
          RaidMapZoneArt.drawLivingRoom(canvas, art, team.color);
        case BoardCorner.topRight:
          RaidMapZoneArt.drawStudy(canvas, art, team.color);
        case BoardCorner.bottomLeft:
          RaidMapZoneArt.drawKitchen(canvas, art, team.color);
        case BoardCorner.bottomRight:
          RaidMapZoneArt.drawGarden(canvas, art, team.color);
      }
    }
    canvas.restore();

    RaidMapZoneArt.drawFiligreeFrame(canvas, zonePath, team.color);

    // Embossed room title band
    final titleY = switch (team.corner) {
      BoardCorner.topLeft || BoardCorner.topRight => bounds.top + 6,
      BoardCorner.bottomLeft || BoardCorner.bottomRight => bounds.bottom - 38,
    };
    final titleRect = Rect.fromLTWH(bounds.left + 6, titleY, bounds.width - 12, 22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(titleRect, const Radius.circular(3)),
      Paint()..color = Colors.black.withValues(alpha: 0.28),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(titleRect, const Radius.circular(3)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            team.color.withValues(alpha: 0.85),
            Color.lerp(team.color, Colors.black, 0.35)!,
          ],
        ).createShader(titleRect),
    );
    canvas.drawLine(
      titleRect.bottomLeft,
      titleRect.bottomRight,
      Paint()..strokeWidth = 1.5..color = _goldHi.withValues(alpha: 0.9),
    );

    _text(canvas, team.roomEmoji, titleRect.topLeft + const Offset(6, 4), const TextStyle(fontSize: 13));
    _text(
      canvas,
      team.roomName.toUpperCase(),
      titleRect.topLeft + const Offset(24, 5),
      const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.1),
    );
    _text(
      canvas,
      'TEAM ${team.name.toUpperCase()}',
      Offset(bounds.left + 10, titleRect.bottom + 6),
      TextStyle(color: _goldHi, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.8),
    );
    _text(
      canvas,
      team.flavor,
      Offset(bounds.left + 10, titleRect.bottom + 17),
      TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 6.5, height: 1.2),
      maxWidth: bounds.width - 20,
    );

    _drawHqMedallion(canvas, _hqMedallionPos(team.corner, size), team);
    RaidMapZoneArt.drawFoldedSecretDeed(canvas, _secretDeedCorner(team.corner, bounds), team.corner);
    _text(
      canvas,
      '?',
      _secretDeedCorner(team.corner, bounds) + const Offset(-4, -6),
      const TextStyle(fontSize: 9, color: Color(0xFF2A1808), fontWeight: FontWeight.w900),
    );

    if ((teamScores[team.id] ?? 0) == 0) {
      RaidMapLuxuryEffects.drawTokenJewel(
        canvas,
        _hqStartPos(team.corner, size),
        team.color,
        team.name.isNotEmpty ? team.name[0].toUpperCase() : '?',
      );
    }

    // Inner rim glow
    canvas.drawPath(
      zonePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = team.color.withValues(alpha: 0.08 + math.sin(shimmerPhase * math.pi * 2) * 0.04),
    );
  }

  Offset _hqStartPos(BoardCorner corner, Size size) {
    final path = _beamPath(corner, size);
    final metrics = path.computeMetrics().first;
    return metrics.getTangentForOffset(0)!.position + const Offset(0, -14);
  }

  Offset _hqMedallionPos(BoardCorner corner, Size size) {
    final b = RaidMapZoneArt.roomZonePath(corner, size).getBounds();
    return switch (corner) {
      BoardCorner.topLeft => Offset(b.left + b.width * 0.72, b.bottom - 28),
      BoardCorner.topRight => Offset(b.left + b.width * 0.28, b.bottom - 28),
      BoardCorner.bottomLeft => Offset(b.left + b.width * 0.72, b.top + 36),
      BoardCorner.bottomRight => Offset(b.left + b.width * 0.28, b.top + 36),
    };
  }

  Offset _secretDeedCorner(BoardCorner corner, Rect bounds) => switch (corner) {
        BoardCorner.topLeft => bounds.bottomRight,
        BoardCorner.topRight => bounds.bottomLeft,
        BoardCorner.bottomLeft => bounds.topRight,
        BoardCorner.bottomRight => bounds.topLeft,
      };

  void _drawHqMedallion(Canvas canvas, Offset c, BoardTeam team) {
    canvas.drawCircle(c + const Offset(0, 2), 14, Paint()..color = Colors.black.withValues(alpha: 0.45));
    canvas.drawCircle(
      c,
      14,
      Paint()
        ..shader = RadialGradient(
          colors: [_goldHi, _gold, _goldLo],
        ).createShader(Rect.fromCircle(center: c, radius: 14)),
    );
    canvas.drawCircle(c, 14, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = _goldLo);
    for (var a = 0; a < 8; a++) {
      final ang = a * math.pi / 4;
      canvas.drawLine(
        Offset(c.dx + 10 * math.cos(ang), c.dy + 10 * math.sin(ang)),
        Offset(c.dx + 12 * math.cos(ang), c.dy + 12 * math.sin(ang)),
        Paint()..color = _goldLo..strokeWidth = 0.8,
      );
    }
    _text(
      canvas,
      'HQ',
      c + const Offset(-7, -5),
      const TextStyle(color: Color(0xFF2A1808), fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 0.5),
    );
  }

  // ─── Raid Vault (hero centerpiece) ───────────────────────────────────

  void _drawRaidVault(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width * 0.21;

    RaidMapLuxuryEffects.drawVaultAura(canvas, center, r, shimmerPhase);

    // Halo
    canvas.drawCircle(
      center,
      r + 14,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF9D7BD8).withValues(alpha: 0.25),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r + 14)),
    );

    final oct = _octagon(center, r);
    canvas.drawPath(oct.shift(const Offset(0, 4)), Paint()..color = Colors.black.withValues(alpha: 0.55));
    canvas.drawPath(
      oct,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF5A3890), const Color(0xFF2A1848), const Color(0xFF0C0614)],
          stops: const [0, 0.55, 1],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
    canvas.drawPath(
      oct,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..shader = LinearGradient(
          colors: [_goldHi, _gold, _goldLo, _goldHi],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    // Facet highlights (jewel-cut octagon)
    for (var i = 0; i < 8; i++) {
      final a1 = (i * math.pi / 4) - math.pi / 8;
      final a2 = ((i + 1) * math.pi / 4) - math.pi / 8;
      final p1 = Offset(center.dx + r * 0.55 * math.cos(a1), center.dy + r * 0.55 * math.sin(a1));
      final p2 = Offset(center.dx + r * 0.55 * math.cos(a2), center.dy + r * 0.55 * math.sin(a2));
      canvas.drawLine(p1, p2, Paint()..color = Colors.white.withValues(alpha: i.isEven ? 0.12 : 0.04)..strokeWidth = 0.8);
      final vtx = Offset(center.dx + r * math.cos(a1), center.dy + r * math.sin(a1));
      RaidMapLuxuryEffects.drawGemStud(canvas, vtx, 3.2);
    }

    // Inner velvet well
    final inner = _octagon(center, r * 0.72);
    canvas.drawPath(
      inner,
      Paint()..color = const Color(0xFF12081C).withValues(alpha: 0.85),
    );

    RaidMapLuxuryEffects.drawEmbossedLabel(
      canvas,
      'RAID VAULT',
      Offset(center.dx - 34, center.dy - r - 12),
      const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2),
    );

    _drawCardWell(canvas, center + const Offset(-48, -34), 'draw', 'ALTAR');
    _drawCardWell(canvas, center + const Offset(-16, -34), 'active', 'SPOT');
    _drawCardWell(canvas, center + const Offset(16, -34), 'discard', 'CHUTE');

    _drawCrownPedestal(canvas, center + const Offset(-4, -4));

    if (vaultEmblem != null) {
      final em = r * 0.48;
      final emblemRect = Rect.fromCenter(center: center + const Offset(0, -6), width: em, height: em);
      canvas.saveLayer(emblemRect, Paint()..color = Colors.white.withValues(alpha: 0.22));
      canvas.translate(emblemRect.left, emblemRect.top);
      canvas.scale(emblemRect.width / RaidMapBoardAssets.vaultArtSize.width);
      canvas.drawPicture(vaultEmblem!);
      canvas.restore();
    }

    _drawCrucible(canvas, center + const Offset(-22, 18), venue.raidTimerSeconds);
    _drawCompass(canvas, center + const Offset(22, 14));
    _drawVaultButton(canvas, Rect.fromCenter(center: center + const Offset(-36, 34), width: 38, height: 15), 'CHAOS');
    _drawVaultButton(canvas, Rect.fromCenter(center: center + const Offset(20, 34), width: 42, height: 15), 'BOUNTY');
  }

  Path _octagon(Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final a = (i * math.pi / 4) - math.pi / 8;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  void _drawCardWell(Canvas canvas, Offset tl, String id, String label) {
    const w = 26.0;
    const h = 34.0;
    final rect = Rect.fromLTWH(tl.dx, tl.dy, w, h);
    final hi = highlightZoneId == id;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(const Offset(0, 2)), const Radius.circular(3)),
      Paint()..color = Colors.black.withValues(alpha: 0.6),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: hi
              ? [AppColors.adventureOrange.withValues(alpha: 0.5), const Color(0xFF1A0810)]
              : [const Color(0xFF1A1420), const Color(0xFF060408)],
        ).createShader(rect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = hi ? 1.5 : 1
        ..color = hi ? AppColors.adventureOrange : _gold.withValues(alpha: 0.45),
    );
    RaidMapLuxuryEffects.drawGlassSheen(canvas, rect);
    _text(
      canvas,
      label,
      Offset(rect.center.dx - label.length * 2.2, rect.bottom + 1),
      TextStyle(
        color: hi ? AppColors.adventureOrange : _gold.withValues(alpha: 0.75),
        fontSize: 5.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    );
  }

  void _drawCrownPedestal(Canvas canvas, Offset c) {
    final hi = highlightZoneId == 'crown';
    canvas.drawOval(
      Rect.fromCenter(center: c + const Offset(0, 4), width: 28, height: 10),
      Paint()..color = const Color(0xFF4A1020).withValues(alpha: 0.7),
    );
    canvas.drawCircle(
      c,
      13,
      Paint()
        ..shader = RadialGradient(
          colors: hi
              ? [_goldHi.withValues(alpha: 0.7), _goldLo]
              : [const Color(0xFF2A1808), Colors.black],
        ).createShader(Rect.fromCircle(center: c, radius: 13)),
    );
    canvas.drawCircle(c, 13, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = _gold);
    _text(canvas, '👑', c + const Offset(-8, -9), const TextStyle(fontSize: 15));
  }

  void _drawCrucible(Canvas canvas, Offset c, int sec) {
    final hi = highlightZoneId == 'timer';
    canvas.drawCircle(c, 19, Paint()..color = const Color(0xFF1A0E08));
    canvas.drawCircle(
      c,
      19,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = hi ? 2 : 1.2
        ..shader = SweepGradient(
          colors: [const Color(0xFFFF6B00), _goldHi, const Color(0xFFFF6B00)],
        ).createShader(Rect.fromCircle(center: c, radius: 19)),
    );
    _text(canvas, '⏱', c + const Offset(-6, -7), const TextStyle(fontSize: 11));
    _text(canvas, '${sec}s', c + const Offset(-8, 22), const TextStyle(color: _goldHi, fontSize: 6.5, fontWeight: FontWeight.w900));
  }

  void _drawCompass(Canvas canvas, Offset c) {
    final hi = highlightZoneId == 'chaos';
    canvas.drawCircle(c, 22, Paint()..color = const Color(0xFF2A1848));
    canvas.drawCircle(c, 22, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = _gold);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final p1 = Offset(c.dx + 14 * math.cos(a), c.dy + 14 * math.sin(a));
      final p2 = Offset(c.dx + 18 * math.cos(a), c.dy + 18 * math.sin(a));
      canvas.drawLine(p1, p2, Paint()..color = _gold.withValues(alpha: 0.5)..strokeWidth = 1);
    }
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(chaosCompassAngle);
    canvas.drawLine(Offset.zero, const Offset(0, -16), Paint()..color = const Color(0xFFE63946)..strokeWidth = 2.5);
    canvas.drawCircle(Offset.zero, 3, Paint()..color = _goldHi);
    canvas.restore();
  }

  void _drawVaultButton(Canvas canvas, Rect r, String label) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(5)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF5C4818), const Color(0xFF2A1C08)],
        ).createShader(r),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(5)),
      Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = _gold.withValues(alpha: 0.55),
    );
    // Dome highlight
    canvas.drawLine(
      Offset(r.left + 4, r.top + 3),
      Offset(r.right - 4, r.top + 3),
      Paint()..color = Colors.white.withValues(alpha: 0.2)..strokeWidth = 1,
    );
    _text(
      canvas,
      label,
      Offset(r.center.dx - label.length * 2.3, r.center.dy - 4),
      const TextStyle(fontSize: 5.5, fontWeight: FontWeight.w900, color: _goldHi, letterSpacing: 0.6),
    );
  }

  // ─── Charter & header ─────────────────────────────────────────────────

  void _drawCharterRibbon(Canvas canvas, Size size) {
    final i = size.shortestSide * 0.058;
    final ribbon = Rect.fromLTWH(i, size.height - i - 20, size.width - i * 2, 16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(ribbon, const Radius.circular(4)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF1A1008).withValues(alpha: 0.9),
            const Color(0xFF2A1808).withValues(alpha: 0.85),
            const Color(0xFF1A1008).withValues(alpha: 0.9),
          ],
        ).createShader(ribbon),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(ribbon, const Radius.circular(4)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..shader = LinearGradient(
          colors: [_goldHi.withValues(alpha: 0.5), _gold.withValues(alpha: 0.35), _goldHi.withValues(alpha: 0.5)],
        ).createShader(ribbon),
    );
    final line = venue.vaultCharter.join('  ·  ');
    _text(
      canvas,
      line,
      Offset(ribbon.left + 8, ribbon.top + 4),
      TextStyle(color: _goldHi.withValues(alpha: 0.9), fontSize: 6.5, fontWeight: FontWeight.w800, letterSpacing: 0.3),
      maxWidth: ribbon.width - 16,
    );
  }

  void _drawBoardHeader(Canvas canvas, Size size) {
    final i = size.shortestSide * 0.058;
    final title = '${venue.emoji}  ${venue.title.toUpperCase()}';
    RaidMapLuxuryEffects.drawEmbossedLabel(
      canvas,
      title,
      Offset(size.width / 2 - title.length * 3.2, i + 2),
      const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, letterSpacing: 1.2),
    );
    _text(
      canvas,
      BoardPrototypeSpec.boardName.toUpperCase(),
      Offset(size.width / 2 - 42, i + 16),
      TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 6.5, fontWeight: FontWeight.w600, letterSpacing: 1.8),
    );
  }

  void _drawSpecLine(Canvas canvas, Size size) {
    _text(
      canvas,
      '${BoardPrototypeSpec.boardWidthMm}×${BoardPrototypeSpec.boardHeightMm}mm quad-fold · spot-UV gold beams',
      Offset(size.width / 2 - 88, size.height - 6),
      TextStyle(color: _gold.withValues(alpha: 0.45), fontSize: 6.5, fontWeight: FontWeight.w600),
    );
  }

  void _text(Canvas canvas, String text, Offset at, TextStyle style, {double? maxWidth}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: maxWidth ?? 240);
    tp.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant BoardLayoutPainter old) =>
      old.highlightZoneId != highlightZoneId ||
      old.teamScores != teamScores ||
      old.chaosCompassAngle != chaosCompassAngle ||
      old.shimmerPhase != shimmerPhase ||
      old.roomArt != roomArt ||
      old.vaultEmblem != vaultEmblem ||
      old.venue.id != venue.id;
}

/// Turn-flow diagram for manufacturer brief.
class TurnFlowPainter extends CustomPainter {
  TurnFlowPainter({this.activeStep = 1});
  final int activeStep;

  @override
  void paint(Canvas canvas, Size size) {
    final phases = BoardPrototypeSpec.turnPhases;
    final stepW = size.width / phases.length;
    for (var i = 0; i < phases.length; i++) {
      final phase = phases[i];
      final active = phase.step == activeStep;
      final cx = stepW * i + stepW / 2;
      final cy = size.height / 2;
      if (i < phases.length - 1) {
        canvas.drawLine(
          Offset(cx + 30, cy),
          Offset(cx + stepW - 30, cy),
          Paint()..color = Colors.white24..strokeWidth = 2,
        );
      }
      canvas.drawCircle(
        Offset(cx, cy),
        active ? 28 : 22,
        Paint()..color = active ? const Color(0xFFFF8A00) : const Color(0xFF6B3FA0).withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant TurnFlowPainter old) => old.activeStep != activeStep;
}