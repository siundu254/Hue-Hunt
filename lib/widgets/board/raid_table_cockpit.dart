import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/models/raid_mode_deck.dart';
import 'package:hue_hunt/models/raid_table_phase.dart';
import 'package:hue_hunt/services/unity_board_bridge.dart';
import 'package:hue_hunt/services/raid_map_board_assets.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/widgets/board/board_layout_painter.dart';
import 'package:hue_hunt/widgets/board/raid_map_unity_view.dart';
import 'package:hue_hunt/widgets/board/raid_map_play_surface.dart';

/// The Raid Table — where players actually spend the night.
/// Phase ritual · crucible timer · mission altar · passport · raid log · secret deeds.
class RaidTableCockpit extends StatefulWidget {
  const RaidTableCockpit({
    super.key,
    required this.venue,
    required this.scores,
    required this.highlightZone,
    required this.chaosAngle,
    required this.suggestedBand,
    required this.selectedBand,
    this.activeModeTitle,
    this.lastEvent,
    this.heatPenalty = 0,
    required this.onTeamTap,
    required this.onVaultTap,
    required this.onDrawMode,
    required this.onBandChanged,
    this.onReset,
    this.onBlitz,
    this.onBounty,
    this.onChaos,
    this.onConfirmRaid,
    this.onLogEvent,
  });

  final RaidMapVenueProfile venue;
  final Map<String, int> scores;
  final String? highlightZone;
  final double chaosAngle;
  final RaidModeAgeBand suggestedBand;
  final RaidModeAgeBand selectedBand;
  final String? activeModeTitle;
  final String? lastEvent;
  final int heatPenalty;
  final ValueChanged<int> onTeamTap;
  final VoidCallback onVaultTap;
  final VoidCallback onDrawMode;
  final ValueChanged<RaidModeAgeBand> onBandChanged;
  final VoidCallback? onReset;
  final VoidCallback? onBlitz;
  final VoidCallback? onBounty;
  final VoidCallback? onChaos;
  final VoidCallback? onConfirmRaid;
  final ValueChanged<String>? onLogEvent;

  @override
  State<RaidTableCockpit> createState() => _RaidTableCockpitState();
}

class _RaidTableCockpitState extends State<RaidTableCockpit> with SingleTickerProviderStateMixin {
  RaidTablePhase _phase = RaidTablePhase.brief;
  bool _tabletop = false;
  bool _director = true;
  bool _use3d = false;
  String? _mission;
  int _timerLeft = 0;
  final List<String> _log = [];
  final Set<String> _passport = {};
  late Map<String, String> _secretDeeds;
  late AnimationController _shimmerCtrl;
  bool _boardArtReady = false;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _passport.add(widget.venue.id.name);
    _secretDeeds = _buildSecretDeeds();
    _pushLog('Raid Table ready — ${widget.venue.title}');
    _loadBoardArt();
  }

  Future<void> _loadBoardArt() async {
    await RaidMapBoardAssets.instance.ensureLoaded();
    if (mounted) setState(() => _boardArtReady = true);
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RaidTableCockpit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.venue.id != widget.venue.id) {
      _passport.add(widget.venue.id.name);
      _secretDeeds = _buildSecretDeeds();
      _mission = null;
      _phase = RaidTablePhase.brief;
      _pushLog('Overlay swapped → ${widget.venue.title}');
    }
    if (widget.lastEvent != null && widget.lastEvent != oldWidget.lastEvent) {
      _pushLog(widget.lastEvent!);
    }
  }

  Map<String, String> _buildSecretDeeds() {
    return {
      for (final q in widget.venue.quadrants)
        q.toBoardTeam().id: 'Secret: find something in ${q.zoneName}',
    };
  }

  int get _effectiveTimer => (widget.venue.raidTimerSeconds - widget.heatPenalty).clamp(30, 120);

  void _pushLog(String msg) {
    setState(() => _log.insert(0, msg));
    if (_log.length > 12) _log.removeLast();
    widget.onLogEvent?.call(msg);
  }

  void _drawMission() {
    final pool = widget.venue.exampleMissions;
    if (pool.isEmpty) return;
    final m = pool[DateTime.now().millisecond % pool.length];
    setState(() {
      _mission = m;
      _phase = RaidTablePhase.raid;
      _timerLeft = _effectiveTimer;
    });
    _pushLog('📜 Brief: "$m" · ${_effectiveTimer}s');
    UnityBoardBridge.setPhase('raid');
    _startRaidTimer();
  }

  void _startRaidTimer() {
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted || _phase != RaidTablePhase.raid) return;
      if (_timerLeft <= 1) {
        setState(() {
          _timerLeft = 0;
          _phase = RaidTablePhase.reveal;
        });
        _pushLog('⏱ Time! — Reveal at your deed corners');
        UnityBoardBridge.setPhase('reveal');
        return;
      }
      setState(() => _timerLeft--);
      _startRaidTimer();
    });
  }

  void _advancePhase() {
    setState(() => _phase = _phase.next);
    _pushLog('Phase → ${_phase.label}');
    UnityBoardBridge.setPhase(_phase.name);
    if (_phase == RaidTablePhase.raid && _mission != null) {
      _timerLeft = _effectiveTimer;
      _startRaidTimer();
    }
  }

  String? _zoneForPhase() => switch (_phase) {
        RaidTablePhase.brief => 'draw',
        RaidTablePhase.raid => 'active',
        RaidTablePhase.reveal => 'crown',
        RaidTablePhase.vault => widget.highlightZone,
      };

  @override
  Widget build(BuildContext context) {
    if (_tabletop) return _tabletopView(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _phaseRail(context),
        const SizedBox(height: 8),
        _passportStrip(),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth > 760;
            final board = _boardColumn(context);
            final side = _sideRail(context);
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 12, child: board),
                  const SizedBox(width: 14),
                  Expanded(flex: 8, child: side),
                ],
              );
            }
            return Column(children: [board, const SizedBox(height: 14), side]);
          },
        ),
      ],
    );
  }

  Widget _tabletopView(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.1,
                colors: [Color(0xFF1A2838), Color(0xFF050508)],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _boardCanvas(context, Size.infinite),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: _phaseRail(context, compact: true),
        ),
        if (_phase == RaidTablePhase.raid)
          Positioned(
            top: 56,
            right: 12,
            child: _crucibleBadge(),
          ),
        if (_mission != null && _phase != RaidTablePhase.vault)
          Positioned(
            bottom: 72,
            left: 16,
            right: 16,
            child: _missionAltar(compact: true),
          ),
        Positioned(
          bottom: 12,
          right: 12,
          child: FilledButton.icon(
            onPressed: () => setState(() => _tabletop = false),
            icon: const Icon(Icons.fullscreen_exit, size: 18),
            label: const Text('Exit tabletop'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.adventureOrange, foregroundColor: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _phaseRail(BuildContext context, {bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: compact ? 6 : 10),
      decoration: RaidUi.glassPanel(accent: AppColors.mysteryPurple),
      child: Row(
        children: [
          for (final p in RaidTablePhase.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: _phase == p
                      ? AppColors.adventureOrange.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => setState(() => _phase = p),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: compact ? 6 : 8),
                      child: Column(
                        children: [
                          Text(
                            p.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: compact ? 8 : 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: _phase == p ? AppColors.treasureYellow : Colors.white54,
                            ),
                          ),
                          if (!compact)
                            Text(
                              '${p.index + 1}',
                              style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.35)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!compact) ...[
            IconButton(
              tooltip: 'Next phase',
              onPressed: _advancePhase,
              icon: const Icon(Icons.skip_next_rounded, color: AppColors.treasureYellow),
            ),
            IconButton(
              tooltip: _director ? 'Player view' : 'Director view',
              onPressed: () => setState(() => _director = !_director),
              icon: Icon(_director ? Icons.admin_panel_settings_outlined : Icons.people_outline),
              color: Colors.white70,
            ),
            IconButton(
              tooltip: 'Tabletop mode',
              onPressed: () => setState(() => _tabletop = true),
              icon: const Icon(Icons.fullscreen),
              color: Colors.white70,
            ),
            if (UnityBoardBridge.isAvailable)
              IconButton(
                tooltip: _use3d ? 'Flat board' : 'Orbit 3D board',
                onPressed: () => setState(() => _use3d = !_use3d),
                icon: Icon(_use3d ? Icons.view_in_ar : Icons.threed_rotation),
                color: AppColors.adventureOrange,
              ),
          ],
        ],
      ),
    );
  }

  Widget _passportStrip() {
    final stamps = _passport.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.3)),
        color: AppColors.treasureYellow.withValues(alpha: 0.06),
      ),
      child: Row(
        children: [
          const Text('📘', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            'Raid Passport · $stamps venue${stamps == 1 ? '' : 's'} stamped',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.treasureYellow),
          ),
          const Spacer(),
          ..._passport.take(8).map((id) {
            final v = RaidMapVenues.all.where((x) => x.id.name == id).firstOrNull;
            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(v?.emoji ?? '🏷️', style: const TextStyle(fontSize: 14)),
            );
          }),
        ],
      ),
    );
  }

  Widget _boardColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_phase == RaidTablePhase.brief || _mission != null) _missionAltar(),
        const SizedBox(height: 10),
        AspectRatio(aspectRatio: 1, child: _boardCanvas(context, const Size(400, 400))),
        if (_director) ...[
          const SizedBox(height: 10),
          _directorControls(),
        ],
      ],
    );
  }

  Widget _directorControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: RaidUi.glassPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DIRECTOR', style: RaidUi.sectionLabel().copyWith(fontSize: 9)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              for (final band in RaidModeAgeBand.values)
                FilterChip(
                  label: Text('${band.emoji} ${band.label.split(' ').first}', style: const TextStyle(fontSize: 10)),
                  selected: widget.selectedBand == band,
                  onSelected: (_) => widget.onBandChanged(band),
                  selectedColor: band.color.withValues(alpha: 0.35),
                  checkmarkColor: Colors.white,
                  side: BorderSide(color: band.color.withValues(alpha: 0.6)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ActionChip(label: const Text('Reset', style: TextStyle(fontSize: 10)), onPressed: widget.onReset),
              ActionChip(label: const Text('Blitz +2', style: TextStyle(fontSize: 10)), onPressed: widget.onBlitz),
              ActionChip(label: const Text('Bounty', style: TextStyle(fontSize: 10)), onPressed: widget.onBounty),
              ActionChip(label: const Text('Spin', style: TextStyle(fontSize: 10)), onPressed: widget.onChaos),
              FilledButton(
                onPressed: widget.onDrawMode,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.adventureOrange,
                  foregroundColor: Colors.black,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Draw mode', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _boardCanvas(BuildContext context, Size size) {
    final child = _use3d
        ? RaidMapUnityView(
            venue: widget.venue,
            scores: widget.scores,
            highlightZone: _zoneForPhase() ?? widget.highlightZone,
            chaosAngle: widget.chaosAngle,
            onTeamTap: widget.onTeamTap,
            onVaultTap: widget.onVaultTap,
          )
        : AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (context, _) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0014)
                ..rotateX(-0.14),
              child: CustomPaint(
                painter: BoardLayoutPainter(
                  venue: widget.venue,
                  highlightZoneId: _zoneForPhase() ?? widget.highlightZone,
                  teamScores: widget.scores,
                  chaosCompassAngle: widget.chaosAngle,
                  shimmerPhase: _shimmerCtrl.value,
                  roomArt: _boardArtReady ? RaidMapBoardAssets.instance.rooms : null,
                  vaultEmblem: _boardArtReady ? RaidMapBoardAssets.instance.vault : null,
                ),
              ),
            ),
          );

    return GestureDetector(
      onTapUp: (d) {
        if (_use3d) return;
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(d.globalPosition);
        final s = box.size;
        _handleBoardTap(local, s);
      },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1008),
          ),
        child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
      ),
    );
  }

  void _handleBoardTap(Offset pos, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    if ((pos - Offset(cx, cy)).distance < size.width * 0.14) {
      widget.onVaultTap();
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
        if (_phase == RaidTablePhase.vault) widget.onTeamTap(i);
        else _pushLog('Tap corner in Vault phase to advance tokens');
        return;
      }
    }
  }

  Widget _missionAltar({bool compact = false}) {
    return Container(
      padding: EdgeInsets.all(compact ? 10 : 14),
      decoration: RaidUi.glassPanel(accent: AppColors.adventureOrange),
      child: Row(
        children: [
          if (_phase == RaidTablePhase.raid) _crucibleBadge(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MISSION ALTAR', style: RaidUi.sectionLabel().copyWith(fontSize: 9)),
                const SizedBox(height: 4),
                Text(
                  _mission ?? 'Draw a brief card to start the raid',
                  style: TextStyle(
                    fontSize: compact ? 13 : 15,
                    fontWeight: FontWeight.w800,
                    color: _mission != null ? Colors.white : Colors.white54,
                  ),
                ),
                if (widget.heatPenalty > 0)
                  Text(
                    '🔥 Heat crucible −${widget.heatPenalty}s',
                    style: const TextStyle(fontSize: 10, color: AppColors.adventureOrange),
                  ),
              ],
            ),
          ),
          if (_phase == RaidTablePhase.brief)
            FilledButton(
              onPressed: _drawMission,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.adventureOrange,
                foregroundColor: Colors.black,
              ),
              child: const Text('Draw'),
            ),
          if (_phase == RaidTablePhase.reveal)
            FilledButton(
              onPressed: () {
                widget.onConfirmRaid?.call();
                setState(() => _phase = RaidTablePhase.vault);
                _pushLog('✓ Raid confirmed — advance on the beam');
              },
              child: const Text('Confirm'),
            ),
        ],
      ),
    );
  }

  Widget _crucibleBadge() {
    final t = _phase == RaidTablePhase.raid ? _timerLeft : _effectiveTimer;
    return Container(
      width: 52,
      height: 52,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.adventureOrange, width: 2),
        gradient: RadialGradient(
          colors: [
            AppColors.adventureOrange.withValues(alpha: 0.25),
            const Color(0xFF0A0810),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$t', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.treasureYellow)),
          const Text('SEC', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _sideRail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_phase.hint, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.55), height: 1.35)),
        const SizedBox(height: 10),
        _PanelBlock(
          title: 'Secret deeds',
          child: Column(
            children: [
              for (final team in widget.venue.teams)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(team.emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _secretDeeds[team.id] ?? '',
                          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _PanelBlock(
          title: 'Raid log',
          child: SizedBox(
            height: 140,
            child: ListView(
              children: [
                for (final e in _log)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(e, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.75), height: 1.3)),
                  ),
              ],
            ),
          ),
        ),
        if (widget.lastEvent != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.treasureYellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.35)),
            ),
            child: Text(widget.lastEvent!, style: const TextStyle(color: AppColors.treasureYellow, fontSize: 11)),
          ),
        ],
      ],
    );
  }
}

class _PanelBlock extends StatelessWidget {
  const _PanelBlock({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: RaidUi.glassPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: RaidUi.sectionLabel().copyWith(fontSize: 9, letterSpacing: 1.1)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
