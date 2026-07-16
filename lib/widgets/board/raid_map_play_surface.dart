import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/models/raid_mode_deck.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/widgets/board/board_layout_painter.dart';

/// Immersive play surface — premium layout matching the board deck demo.
class RaidMapPlaySurface extends StatelessWidget {
  const RaidMapPlaySurface({
    super.key,
    required this.venue,
    required this.scores,
    required this.highlightZone,
    required this.chaosAngle,
    required this.suggestedBand,
    this.activeModeTitle,
    this.lastEvent,
    required this.onTeamTap,
    required this.onVaultTap,
    required this.onDrawMode,
    required this.selectedBand,
    required this.onBandChanged,
    this.onReset,
    this.onBlitz,
    this.onBounty,
    this.onChaos,
  });

  final RaidMapVenueProfile venue;
  final Map<String, int> scores;
  final String? highlightZone;
  final double chaosAngle;
  final RaidModeAgeBand suggestedBand;
  final String? activeModeTitle;
  final String? lastEvent;
  final ValueChanged<int> onTeamTap;
  final VoidCallback onVaultTap;
  final VoidCallback onDrawMode;
  final RaidModeAgeBand selectedBand;
  final ValueChanged<RaidModeAgeBand> onBandChanged;
  final VoidCallback? onReset;
  final VoidCallback? onBlitz;
  final VoidCallback? onBounty;
  final VoidCallback? onChaos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 720;
        final board = _BoardStage(
          venue: venue,
          scores: scores,
          highlightZone: highlightZone,
          chaosAngle: chaosAngle,
          onTeamTap: onTeamTap,
          onVaultTap: onVaultTap,
          onReset: onReset,
          onBlitz: onBlitz,
          onBounty: onBounty,
          onChaos: onChaos,
          selectedBand: selectedBand,
          onBandChanged: onBandChanged,
          onDrawMode: onDrawMode,
        );
        final panel = _MissionPanel(
          venue: venue,
          scores: scores,
          suggestedBand: suggestedBand,
          selectedBand: selectedBand,
          activeModeTitle: activeModeTitle,
          lastEvent: lastEvent,
        );

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: board),
              const SizedBox(width: 16),
              Expanded(flex: 9, child: panel),
            ],
          );
        }
        return Column(
          children: [
            board,
            const SizedBox(height: 16),
            panel,
          ],
        );
      },
    );
  }
}

class _BoardStage extends StatelessWidget {
  const _BoardStage({
    required this.venue,
    required this.scores,
    required this.highlightZone,
    required this.chaosAngle,
    required this.onTeamTap,
    required this.onVaultTap,
    required this.onReset,
    required this.onBlitz,
    required this.onBounty,
    required this.onChaos,
    required this.selectedBand,
    required this.onBandChanged,
    required this.onDrawMode,
  });

  final RaidMapVenueProfile venue;
  final Map<String, int> scores;
  final String? highlightZone;
  final double chaosAngle;
  final ValueChanged<int> onTeamTap;
  final VoidCallback onVaultTap;
  final VoidCallback? onReset;
  final VoidCallback? onBlitz;
  final VoidCallback? onBounty;
  final VoidCallback? onChaos;
  final RaidModeAgeBand selectedBand;
  final ValueChanged<RaidModeAgeBand> onBandChanged;
  final VoidCallback onDrawMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.adventureOrange.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColoredBox(
          color: const Color(0xFF08060E),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final size = Size(c.maxWidth, c.maxHeight);
                      return GestureDetector(
                        onTapUp: (d) => _handleTap(d.localPosition, size),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0012)
                            ..rotateX(-0.12),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mysteryPurple.withValues(alpha: 0.35),
                                  blurRadius: 32,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CustomPaint(
                                size: size,
                                painter: BoardLayoutPainter(
                                  venue: venue,
                                  highlightZoneId: highlightZone,
                                  teamScores: scores,
                                  chaosCompassAngle: chaosAngle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _SpecChip('480×480mm', gold: true),
                    _SpecChip('spot-UV beams', gold: true),
                    _SpecChip('11 spaces'),
                    _SpecChip(venue.packSku ?? 'HHB-CORE-MAP', sku: true),
                  ],
                ),
                const SizedBox(height: 12),
                Text('MODE BAND', style: RaidUi.sectionLabel().copyWith(fontSize: 10)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final band in RaidModeAgeBand.values)
                      FilterChip(
                        label: Text('${band.emoji} ${band.label.split(' ').first}', style: const TextStyle(fontSize: 11)),
                        selected: selectedBand == band,
                        onSelected: (_) => onBandChanged(band),
                        selectedColor: band.color.withValues(alpha: 0.35),
                        checkmarkColor: Colors.white,
                        side: BorderSide(color: band.color.withValues(alpha: 0.6)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                _ControlRow(label: 'Track', children: [
                  _ActionChip(label: 'Reset', icon: Icons.refresh, onTap: onReset),
                  _ActionChip(label: 'Blitz +2', icon: Icons.bolt, onTap: onBlitz),
                  _ActionChip(label: 'Bounty', icon: Icons.star_outline, onTap: onBounty),
                ]),
                _ControlRow(label: 'Chaos', children: [
                  _ActionChip(label: 'Spin compass', icon: Icons.explore, onTap: onChaos),
                ]),
                _ControlRow(label: 'Mode deck', children: [
                  FilledButton.icon(
                    onPressed: onDrawMode,
                    icon: const Icon(Icons.style, size: 16),
                    label: const Text('Draw mode card'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.adventureOrange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset pos, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    if ((pos - Offset(cx, cy)).distance < size.width * 0.14) {
      onVaultTap();
      return;
    }
    const pad = 0.055;
    const rw = 0.42;
    const rh = 0.42;
    final corners = [
      Rect.fromLTWH(size.width * pad, size.height * pad, size.width * rw, size.height * rh),
      Rect.fromLTWH(size.width * (1 - pad - rw), size.height * pad, size.width * rw, size.height * rh),
      Rect.fromLTWH(size.width * pad, size.height * (1 - pad - rh), size.width * rw, size.height * rh),
      Rect.fromLTWH(size.width * (1 - pad - rw), size.height * (1 - pad - rh), size.width * rw, size.height * rh),
    ];
    for (var i = 0; i < corners.length; i++) {
      if (corners[i].contains(pos)) {
        onTeamTap(i);
        return;
      }
    }
  }
}

class _MissionPanel extends StatelessWidget {
  const _MissionPanel({
    required this.venue,
    required this.scores,
    required this.suggestedBand,
    required this.selectedBand,
    this.activeModeTitle,
    this.lastEvent,
  });

  final RaidMapVenueProfile venue;
  final Map<String, int> scores;
  final RaidModeAgeBand suggestedBand;
  final RaidModeAgeBand selectedBand;
  final String? activeModeTitle;
  final String? lastEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1028).withValues(alpha: 0.95),
            const Color(0xFF0D0A14).withValues(alpha: 0.98),
          ],
        ),
        border: Border.all(color: AppColors.adventureOrange.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(venue.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(venue.title, style: RaidUi.title(context).copyWith(fontSize: 20)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _MetaChip(venue.tier.name.toUpperCase()),
                        _MetaChip('${venue.raidTimerSeconds}s'),
                        _MetaChip(venue.difficultyDisplay),
                        _MetaChip(venue.recommendedTeamSize),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _PanelSection(
            title: 'Mode deck',
            child: Text(
              'Suggested: ${suggestedBand.emoji} ${suggestedBand.label}'
              '${activeModeTitle != null ? '\nActive: $activeModeTitle' : ''}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, height: 1.4),
            ),
          ),
          _PanelSection(
            title: 'Lore & achievement',
            child: Text(
              '${venue.loreBrief}\n🏅 ${venue.achievementTitle}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, height: 1.4),
            ),
          ),
          _PanelSection(
            title: 'Vault charter',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in venue.vaultCharter)
                  Text(line, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.4)),
              ],
            ),
          ),
          _PanelSection(
            title: 'Raid track',
            child: Column(
              children: [
                for (final team in venue.teams)
                  _TeamProgressBar(
                    label: '${team.emoji} ${team.name}',
                    color: team.color,
                    score: scores[team.id] ?? 0,
                    max: BoardPrototypeSpec.winScore,
                  ),
              ],
            ),
          ),
          if (lastEvent != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.treasureYellow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.35)),
              ),
              child: Text(lastEvent!, style: const TextStyle(color: AppColors.treasureYellow, fontSize: 11, height: 1.35)),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            'Sample brief: "${venue.exampleMissions.first}" · ${venue.raidTimerSeconds}s',
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5), fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _TeamProgressBar extends StatelessWidget {
  const _TeamProgressBar({
    required this.label,
    required this.color,
    required this.score,
    required this.max,
  });

  final String label;
  final Color color;
  final int score;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              Text('$score/$max', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / max,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelSection extends StatelessWidget {
  const _PanelSection({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: RaidUi.sectionLabel().copyWith(fontSize: 9, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip(this.label, {this.gold = false, this.sku = false});
  final String label;
  final bool gold;
  final bool sku;

  @override
  Widget build(BuildContext context) {
    final color = gold
        ? AppColors.treasureYellow
        : sku
            ? AppColors.adventureOrange
            : Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color)),
    );
  }
}

class _ControlRow extends StatelessWidget {
  const _ControlRow({required this.label, required this.children});
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: children),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon, this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: AppColors.adventureOrange),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: onTap,
      backgroundColor: Colors.white.withValues(alpha: 0.06),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
    );
  }
}

RaidModeAgeBand suggestBandForVenue(RaidMapVenueId id) {
  return switch (id) {
    RaidMapVenueId.hospital || RaidMapVenueId.seniorLiving => RaidModeAgeBand.gentle,
    RaidMapVenueId.party || RaidMapVenueId.gym || RaidMapVenueId.retail => RaidModeAgeBand.party,
    RaidMapVenueId.office ||
    RaidMapVenueId.museum ||
    RaidMapVenueId.library ||
    RaidMapVenueId.airport =>
      RaidModeAgeBand.expert,
    _ => RaidModeAgeBand.family,
  };
}
