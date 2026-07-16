import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_brief_card.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';

/// Manufacturer / pitch preview of a printed mission brief card.
class BriefCardPreview extends StatelessWidget {
  const BriefCardPreview({
    super.key,
    required this.venue,
    required this.missionText,
    this.type = BoardBriefCardType.object,
    this.cardIndex = 1,
    this.showBack = false,
    this.elevated = true,
  });

  final RaidMapVenueProfile venue;
  final String missionText;
  final BoardBriefCardType type;
  final int cardIndex;
  final bool showBack;
  final bool elevated;

  static const _aspect = BoardBriefCardDesign.widthMm / BoardBriefCardDesign.heightMm;

  @override
  Widget build(BuildContext context) {
    final seconds = BoardBriefCardDesign.timerFor(venue, type);
    final code = BoardBriefCardDesign.deckCode(venue, cardIndex);
    final total = venue.isCore ? BoardBriefCardDesign.coreDeckCount : BoardBriefCardDesign.expansionPackCount;

    return AspectRatio(
      aspectRatio: _aspect,
      child: _CardShell(
        elevated: elevated,
        accent: showBack ? venue.quadrants.first.color : type.color,
        child: showBack ? _CardBack(venue: venue, code: code, index: cardIndex, total: total) : _CardFront(
          venue: venue,
          missionText: missionText,
          type: type,
          seconds: seconds,
          code: code,
          index: cardIndex,
          total: total,
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, required this.accent, this.elevated = true});

  final Widget child;
  final Color accent;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: elevated
            ? [
                BoxShadow(color: Colors.black.withValues(alpha: 0.55), blurRadius: 16, offset: const Offset(0, 8)),
                BoxShadow(color: accent.withValues(alpha: 0.22), blurRadius: 20, spreadRadius: -4),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _CardFramePainter(accent: accent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    required this.venue,
    required this.missionText,
    required this.type,
    required this.seconds,
    required this.code,
    required this.index,
    required this.total,
  });

  final RaidMapVenueProfile venue;
  final String missionText;
  final BoardBriefCardType type;
  final int seconds;
  final String code;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1428), Color(0xFF120E1A), Color(0xFF0F0A14)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TypeHeader(type: type, venue: venue),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: Column(
                children: [
                  Text(
                    'BRIEF',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.2,
                      color: type.color.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: Text(
                        missionText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.28,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  type.color.withValues(alpha: 0.45),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _TimerSeal(seconds: seconds, accent: type.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${venue.pace.label} · ${venue.ageBand}',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.55),
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.38),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                _CardIndexBadge(index: index, total: total),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeHeader extends StatelessWidget {
  const _TypeHeader({required this.type, required this.venue});

  final BoardBriefCardType type;
  final RaidMapVenueProfile venue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            type.color,
            Color.lerp(type.color, Colors.black, 0.35)!,
          ],
        ),
        boxShadow: [
          BoxShadow(color: type.color.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(type.icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            type.label,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.6,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(venue.emoji, style: const TextStyle(fontSize: 10)),
                const SizedBox(width: 4),
                Text(
                  venue.title.replaceAll(' Raid', '').toUpperCase(),
                  style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerSeal extends StatelessWidget {
  const _TimerSeal({required this.seconds, required this.accent});

  final int seconds;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            accent.withValues(alpha: 0.25),
            const Color(0xFF0A0810),
          ],
        ),
        border: Border.all(color: accent, width: 2),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$seconds',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              height: 1,
              color: AppColors.treasureYellow,
            ),
          ),
          Text(
            'SEC',
            style: TextStyle(
              fontSize: 6.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardIndexBadge extends StatelessWidget {
  const _CardIndexBadge({required this.index, required this.total});

  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.35)),
      ),
      child: Text(
        '${index.toString().padLeft(2, '0')}/$total',
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.treasureYellow),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    required this.venue,
    required this.code,
    required this.index,
    required this.total,
  });

  final RaidMapVenueProfile venue;
  final String code;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final band = venue.quadrants.first.color;
    return Container(
      color: const Color(0xFF0A0A0F),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [band, Color.lerp(band, Colors.black, 0.4)!],
              ),
            ),
            child: Column(
              children: [
                Text(venue.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 2),
                Text(
                  venue.title.toUpperCase(),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.adventureOrange.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Icon(Icons.flashlight_on, size: 40, color: AppColors.treasureYellow.withValues(alpha: 0.85)),
                Positioned(
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.adventureOrange.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'THE RAID MAP',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: AppColors.adventureOrange.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.black.withValues(alpha: 0.35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(code, style: TextStyle(fontSize: 7.5, color: Colors.white.withValues(alpha: 0.45))),
                Text(
                  venue.tier.name.toUpperCase(),
                  style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: band.withValues(alpha: 0.9)),
                ),
                Text(
                  '${index.toString().padLeft(2, '0')}/$total',
                  style: const TextStyle(fontSize: 7.5, color: AppColors.treasureYellow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFramePainter extends CustomPainter {
  _CardFramePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 5.0;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = accent.withValues(alpha: 0.35),
    );

    final corner = Paint()
      ..color = accent.withValues(alpha: 0.55)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const len = 10.0;
    for (final origin in [
      Offset(inset + 2, inset + 2),
      Offset(size.width - inset - 2, inset + 2),
      Offset(inset + 2, size.height - inset - 2),
      Offset(size.width - inset - 2, size.height - inset - 2),
    ]) {
      final flipX = origin.dx > size.width / 2;
      final flipY = origin.dy > size.height / 2;
      canvas.drawLine(
        origin,
        origin + Offset(flipX ? -len : len, 0),
        corner,
      );
      canvas.drawLine(
        origin,
        origin + Offset(0, flipY ? -len : len),
        corner,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CardFramePainter old) => old.accent != accent;
}

/// Horizontal fan of sample cards for a venue deck.
class BriefCardDeckPreview extends StatelessWidget {
  const BriefCardDeckPreview({super.key, required this.venue});

  final RaidMapVenueProfile venue;

  @override
  Widget build(BuildContext context) {
    final samples = venue.exampleMissions.take(3).toList();
    const types = [BoardBriefCardType.object, BoardBriefCardType.combo, BoardBriefCardType.texture];
    const tilts = [-0.06, 0.0, 0.06];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mission brief cards', style: RaidUi.sectionLabel()),
        const SizedBox(height: 4),
        Text(
          'Read from Spotlight · ${venue.raidTimerSeconds}s base · timer printed on every card',
          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < samples.length; i++)
                Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : 4, bottom: i == 1 ? 0 : 8),
                  child: Transform.rotate(
                    angle: tilts[i],
                    child: SizedBox(
                      width: 132,
                      child: BriefCardPreview(
                        venue: venue,
                        missionText: samples[i],
                        type: types[i],
                        cardIndex: i + 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Large front + back showcase for the Cards tab.
class BriefCardShowcase extends StatelessWidget {
  const BriefCardShowcase({super.key, required this.venue});

  final RaidMapVenueProfile venue;

  @override
  Widget build(BuildContext context) {
    final mission = venue.exampleMissions.first;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: RaidUi.glassPanel(accent: AppColors.mysteryPurple),
      child: Column(
        children: [
          Text('PRINT SPECIMEN', style: RaidUi.sectionLabel()),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('FRONT', style: _labelStyle()),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: math.max(220, MediaQuery.sizeOf(context).width * 0.38),
                      child: BriefCardPreview(
                        venue: venue,
                        missionText: mission,
                        cardIndex: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text('BACK', style: _labelStyle()),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: math.max(220, MediaQuery.sizeOf(context).width * 0.38),
                      child: BriefCardPreview(
                        venue: venue,
                        missionText: mission,
                        cardIndex: 1,
                        showBack: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: Colors.white.withValues(alpha: 0.5),
      );
}
