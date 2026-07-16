import 'package:flutter/material.dart';
import 'package:hue_hunt/models/raid_mode_deck.dart';
import 'package:hue_hunt/models/board_innovation.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/services/board_prototype_pdf.dart';
import 'package:hue_hunt/services/raid_feedback_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/widgets/board/raid_map_venue_picker.dart';
import 'package:hue_hunt/widgets/board/brief_card_preview.dart';
import 'package:hue_hunt/services/unity_board_bridge.dart';
import 'package:hue_hunt/widgets/board/raid_map_play_surface.dart' show suggestBandForVenue;
import 'package:hue_hunt/widgets/board/raid_table_cockpit.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

/// Interactive board prototype for Hunt-Hue Box — hand off to manufacturers / focus groups.
class BoardPrototypeScreen extends StatefulWidget {
  const BoardPrototypeScreen({super.key, this.initialVenue});

  final RaidMapVenueId? initialVenue;

  @override
  State<BoardPrototypeScreen> createState() => _BoardPrototypeScreenState();
}

class _BoardPrototypeScreenState extends State<BoardPrototypeScreen>
    with SingleTickerProviderStateMixin {
  int _tab = 0;
  int _activePhase = 1;
  String? _highlightZone;
  RaidMapVenueId _venue = BoardPrototypeSpec.defaultVenue;
  RaidMapExpansionTier? _tierFilter;
  late final AnimationController _compass;
  late Map<String, int> _scores;
  RaidModeAgeBand _modeBand = RaidModeAgeBand.family;
  String? _activeModeTitle;
  String? _lastEvent;
  int _heatPenalty = 0;

  @override
  void initState() {
    super.initState();
    _compass = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    if (widget.initialVenue != null) _venue = widget.initialVenue!;
    _modeBand = suggestBandForVenue(_venue);
    _resetScores();
    UnityBoardBridge.loadVenue(_venueProfile);
  }

  void _resetScores() {
    _scores = {for (final t in _venueProfile.teams) t.id: 0};
  }

  RaidMapVenueProfile get _venueProfile => BoardPrototypeSpec.venueProfile(_venue);

  void _setVenue(RaidMapVenueId id) {
    setState(() {
      _venue = id;
      _resetScores();
      _activePhase = 1;
      _highlightZone = null;
      _modeBand = suggestBandForVenue(id);
      _activeModeTitle = null;
      _lastEvent = null;
      _heatPenalty = 0;
    });
    UnityBoardBridge.loadVenue(_venueProfile);
  }

  void _advanceTeam(int teamIndex) {
    final teams = _venueProfile.teams;
    if (teamIndex < 0 || teamIndex >= teams.length) return;
    final team = teams[teamIndex];
    final settings = context.read<SettingsProvider>();
    setState(() {
      final v = _scores[team.id] ?? 0;
      if (v < BoardPrototypeSpec.winScore) {
        _scores[team.id] = v + 1;
        _heatPenalty = (_heatPenalty + 5).clamp(0, 30);
        _lastEvent = '${team.emoji} Team ${team.name} → space ${_scores[team.id]}';
        if (_scores[team.id] == BoardPrototypeSpec.winScore) {
          _lastEvent = 'Who Raided? — "${team.name} Raided!" 👑';
          _highlightZone = 'crown';
          UnityBoardBridge.playCrownCeremony(team.name);
          RaidFeedbackService.playCrownWin(
            teamName: team.name,
            soundEnabled: settings.soundEffects,
            hapticsEnabled: settings.haptics,
          );
        }
      }
      UnityBoardBridge.setScores(_scores);
    });
  }

  void _drawModeCard() {
    final pool = RaidModeDeck.forBand(_modeBand);
    if (pool.isEmpty) return;
    final card = pool[DateTime.now().millisecond % pool.length];
    final settings = context.read<SettingsProvider>();
    setState(() {
      _activeModeTitle = card.title;
      _lastEvent = '${_modeBand.emoji} ${card.title} — ${card.rule}';
    });
    RaidFeedbackService.playModeDraw(hapticsEnabled: settings.haptics);
    UnityBoardBridge.drawModeCard(card);
  }

  @override
  void dispose() {
    _compass.dispose();
    super.dispose();
  }

  void _advanceDemo() {
    setState(() {
      _activePhase = _activePhase >= 4 ? 1 : _activePhase + 1;
      if (_activePhase == 4) {
        _compass.forward(from: 0);
        final leader = _scores.entries.reduce((a, b) => a.value >= b.value ? a : b);
        if (leader.value < BoardPrototypeSpec.winScore) {
          _scores[leader.key] = leader.value + 1;
        }
      }
      _highlightZone = switch (_activePhase) {
        1 => 'draw',
        2 => 'active',
        3 => 'crown',
        4 => 'chaos',
        _ => null,
      };
    });
  }

  Future<void> _exportPdf() async {
    final bytes = await BoardPrototypePdf.build(
      venue: _venue,
      teamScores: _scores,
      activePhase: _activePhase,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'hunt_hue_box_board_prototype.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Raid Map'),
        actions: [
          IconButton(
            tooltip: 'Export PDF brief',
            onPressed: _exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              BoardPrototypeSpec.version,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Map'), icon: Icon(Icons.map, size: 18)),
                ButtonSegment(value: 1, label: Text('Cards'), icon: Icon(Icons.style, size: 18)),
                ButtonSegment(value: 2, label: Text('Vision'), icon: Icon(Icons.auto_awesome, size: 18)),
                ButtonSegment(value: 3, label: Text('Turns'), icon: Icon(Icons.route, size: 18)),
                ButtonSegment(value: 4, label: Text('Kit'), icon: Icon(Icons.inventory_2, size: 18)),
                ButtonSegment(value: 5, label: Text('Brief'), icon: Icon(Icons.assignment_outlined, size: 18)),
              ],
              selected: {_tab},
              onSelectionChanged: (s) => setState(() => _tab = s.first),
            ),
          ),
          Expanded(child: _buildTab()),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: _advanceDemo,
              icon: const Icon(Icons.play_arrow),
              label: Text('Step $_activePhase · demo turn'),
            )
          : null,
    );
  }

  Widget _buildTab() {
    return switch (_tab) {
      0 => _boardTab(),
      1 => _cardsTab(),
      2 => _visionTab(),
      3 => _turnFlowTab(),
      4 => _componentsTab(),
      _ => _briefTab(),
    };
  }

  Widget _boardTab() {
    final profile = _venueProfile;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RaidMapVenuePicker(
          selected: _venue,
          tierFilter: _tierFilter,
          onTierFilterChanged: (t) => setState(() => _tierFilter = t),
          onSelected: _setVenue,
        ),
        const SizedBox(height: 14),
        RaidTableCockpit(
          venue: profile,
          scores: _scores,
          highlightZone: _highlightZone,
          chaosAngle: _compass.value * 6.28,
          suggestedBand: suggestBandForVenue(_venue),
          selectedBand: _modeBand,
          activeModeTitle: _activeModeTitle,
          lastEvent: _lastEvent,
          heatPenalty: _heatPenalty,
          onTeamTap: _advanceTeam,
          onVaultTap: () => setState(() => _highlightZone = 'crown'),
          onBandChanged: (b) => setState(() => _modeBand = b),
          onDrawMode: _drawModeCard,
          onConfirmRaid: () => _advanceTeam(0),
          onReset: () => setState(() {
            _resetScores();
            _heatPenalty = 0;
            _lastEvent = 'Track reset — race to 👑';
            _activeModeTitle = null;
          }),
          onBlitz: () {
            final t = profile.teams.first;
            _advanceTeam(0);
            setState(() => _lastEvent = '⚡ Blitz round — ${t.name} +2');
          },
          onBounty: () => setState(() => _lastEvent = '★ Draw Raid Bounty — bonus space or steal'),
          onChaos: () {
            final settings = context.read<SettingsProvider>();
            _compass.forward(from: 0);
            RaidFeedbackService.playChaosSpin(hapticsEnabled: settings.haptics);
            setState(() => _lastEvent = '🧭 Chaos Compass spun — sudden twist!');
          },
        ),
        const SizedBox(height: 12),
        Text(
          UnityBoardBridge.isAvailable
              ? 'Unity 3D board active'
              : 'Flutter preview · embed Unity for 3D board (unity/RaidMap/README.md)',
          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.45)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _cardsTab() {
    final profile = _venueProfile;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RaidMapVenuePicker(
          selected: _venue,
          tierFilter: _tierFilter,
          onTierFilterChanged: (t) => setState(() => _tierFilter = t),
          onSelected: _setVenue,
        ),
        const SizedBox(height: 16),
        BriefCardDeckPreview(venue: profile),
        const SizedBox(height: 20),
        BriefCardShowcase(venue: profile),
        const SizedBox(height: 20),
        _VaultCharterPanel(venue: profile),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: RaidUi.glassPanel(accent: AppColors.mysteryPurple),
          child: Text(
            'Timer on card = venue base (${profile.raidTimerSeconds}s) × mission type. '
            'Relay & duel cards print shorter times. No rulebook lookup.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), height: 1.4, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),
        Text('All venue timers', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        for (final v in RaidMapVenues.all)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 28, child: Text(v.emoji, style: const TextStyle(fontSize: 16))),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.title, style: const TextStyle(fontSize: 12)),
                      Text(
                        '${v.difficultyDisplay} · ${v.recommendedTeamSize} · ${v.ruleModifier}',
                        style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.45)),
                      ),
                    ],
                  ),
                ),
                Text('${v.raidTimerSeconds}s', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.treasureYellow)),
                const SizedBox(width: 8),
                Text(v.pace.label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _visionTab() {
    final profile = _venueProfile;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: RaidUi.heroPanel(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Expandable venue platform', style: RaidUi.title(context)),
              const SizedBox(height: 8),
              Text(
                RaidMapVenues.expansionModel,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: RaidUi.glassPanel(accent: AppColors.treasureYellow),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${profile.emoji} ${profile.title}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              Text(profile.useCase, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
              const SizedBox(height: 8),
              Text('Facilitator: ${profile.facilitatorTip}', style: const TextStyle(fontSize: 12, height: 1.35)),
              if (profile.packSku != null)
                Text('SKU: ${profile.packSku}', style: const TextStyle(fontSize: 11, color: AppColors.adventureOrange)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Example missions', style: RaidUi.sectionLabel()),
        for (final m in profile.exampleMissions)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('• $m', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          ),
        const SizedBox(height: 16),
        Text('All venue overlays', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        for (final v in RaidMapVenues.all)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Text(v.emoji, style: const TextStyle(fontSize: 22)),
            title: Text(v.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(v.useCase, style: const TextStyle(fontSize: 12)),
            trailing: _tierChip(v.tier),
          ),
        const SizedBox(height: 16),
        Text('Outside-the-box modes', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        for (final cat in BoardInnovationCategory.values) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(cat.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.adventureOrange)),
          ),
          for (final mode in BoardInnovation.forCategory(cat))
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: RaidUi.glassPanel(accent: AppColors.mysteryPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${mode.emoji} ${mode.title}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  Text(mode.hook, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 4),
                  Text(mode.howItWorks, style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 12, height: 1.35)),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
        Text('Raid Mode Deck', style: RaidUi.sectionLabel()),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: RaidUi.glassPanel(accent: AppColors.treasureYellow),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${RaidModeDeck.title} · ${RaidModeDeck.sku}', style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                '${RaidModeDeck.cardCount} cards · one tuck box · 6 per age band',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
              ),
              const SizedBox(height: 10),
              for (final step in RaidModeDeck.setupSteps)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $step', style: const TextStyle(fontSize: 12, height: 1.35)),
                ),
              const SizedBox(height: 8),
              Text(RaidModeDeck.mixedAgeRule, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.55), fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final band in RaidModeAgeBand.values) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(band.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text('${band.label} (${band.ages})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: band.color)),
              ],
            ),
          ),
          Text(band.bestFor, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.45))),
          const SizedBox(height: 6),
          for (final card in RaidModeDeck.forBand(band))
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border(left: BorderSide(color: band.color, width: 3)),
                color: Colors.black.withValues(alpha: 0.25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${card.emoji} ${card.title}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text(card.rule, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.75), height: 1.3)),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
        Text('Expansion model', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        for (final d in BoardPrototypeSpec.expansionDeliverables)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.layers_outlined, size: 16, color: AppColors.adventureOrange),
                const SizedBox(width: 8),
                Expanded(child: Text(d, style: const TextStyle(height: 1.3))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _tierChip(RaidMapExpansionTier tier) {
    final (label, color) = switch (tier) {
      RaidMapExpansionTier.core => ('CORE', AppColors.treasureYellow),
      RaidMapExpansionTier.expansionPack => ('PACK', AppColors.adventureOrange),
      RaidMapExpansionTier.digital => ('DIGITAL', AppColors.mysteryPurple),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color)),
    );
  }

  Widget _turnFlowTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: CustomPaint(painter: TurnFlowPainter(activeStep: _activePhase)),
        ),
        const SizedBox(height: 20),
        for (final phase in BoardPrototypeSpec.turnPhases)
          _PhaseCard(
            phase: phase,
            active: phase.step == _activePhase,
            onTap: () => setState(() {
              _activePhase = phase.step;
              _highlightZone = switch (phase.step) {
                1 => 'draw',
                2 => 'active',
                3 => 'crown',
                _ => 'chaos',
              };
            }),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: RaidUi.glassPanel(accent: AppColors.treasureYellow),
          child: const Text(
            'Win: first raider to the 👑 on their Raid Beam claims the Raid Crown on the pedestal.',
            style: TextStyle(height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _componentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Bill of materials', style: RaidUi.sectionLabel()),
        const SizedBox(height: 12),
        for (final c in BoardPrototypeSpec.components)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: RaidUi.statTile(),
            child: Row(
              children: [
                Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: Text(c.qty, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(c.spec, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        Text('Card mix (48 total)', style: RaidUi.sectionLabel()),
        const SizedBox(height: 12),
        for (final mix in BoardPrototypeSpec.cardMix)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: mix.count / BoardPrototypeSpec.totalCards,
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      color: mix.color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: Text('${mix.label} (${mix.count})', style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: RaidUi.heroPanel(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Retail box', style: RaidUi.sectionLabel()),
              const SizedBox(height: 8),
              Text(
                '${BoardPrototypeSpec.boxWidthMm} × ${BoardPrototypeSpec.boxHeightMm} × '
                '${BoardPrototypeSpec.boxDepthMm} mm · fits board folded + cards + timer',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _briefTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: RaidUi.heroPanel(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Manufacturer brief', style: RaidUi.title(context)),
              const SizedBox(height: 8),
              Text(
                'Use this prototype to build a sample ${BoardPrototypeSpec.productName} '
                'for market research focus groups.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Deliverables', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        const _BriefBullet('1× full-color Raid Control Mat proof (480×480mm unfolded)'),
        const _BriefBullet('1× poker-size card sheet proof (48 cards, 63×88mm)'),
        const _BriefBullet('1× box flat with insert tray layout'),
        const _BriefBullet('1× sand timer + 4 team tokens sample'),
        const SizedBox(height: 16),
        Text('Presentation deck (Google Slides)', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        const _BriefBullet(
          'PPTX: documents/Hunt-Hue-Box-Board-Deck-NovaLumina-FY2026-27.pptx — upload to Google Drive → Open with Google Slides',
        ),
        const _BriefBullet('HTML: Board-Deck.html — open in browser · M map · D mode deck · P present'),
        const _BriefBullet('Regenerate PPTX: python3 documents/generate_board_deck.py'),
        const SizedBox(height: 16),
        Text('Prototype notes', style: RaidUi.sectionLabel()),
        const SizedBox(height: 8),
        for (final note in BoardPrototypeSpec.prototypeNotes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppColors.adventureOrange)),
                Expanded(child: Text(note, style: const TextStyle(height: 1.35))),
              ],
            ),
          ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _exportPdf,
          icon: const Icon(Icons.download_outlined),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Download PDF brief for your team'),
          ),
        ),
      ],
    );
  }
}

class _VaultCharterPanel extends StatelessWidget {
  const _VaultCharterPanel({required this.venue});
  final RaidMapVenueProfile venue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RaidUi.glassPanel(accent: AppColors.treasureYellow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vault charter (printed on board)', style: RaidUi.sectionLabel()),
          const SizedBox(height: 6),
          Text(
            'Swaps with venue overlay — facilitators never write this down.',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 10),
          for (final line in venue.vaultCharter)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ),
          const SizedBox(height: 6),
          Text(
            'Boundaries: ${venue.boardBoundaries}',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75)),
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.team, required this.score, required this.label, required this.onIncrement});

  final BoardTeam team;
  final int score;
  final String label;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: CircleAvatar(backgroundColor: team.color, radius: 10, child: Text(team.roomEmoji, style: const TextStyle(fontSize: 10))),
      label: Text('$label · $score/${BoardPrototypeSpec.winScore}'),
      onPressed: onIncrement,
    );
  }
}

class _ZoneDetailCard extends StatelessWidget {
  const _ZoneDetailCard({required this.zone});
  final BoardZone zone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RaidUi.glassPanel(accent: AppColors.adventureOrange),
      child: Row(
        children: [
          Icon(zone.icon, color: AppColors.adventureOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(zone.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(zone.subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                Text('${zone.widthMm}×${zone.heightMm}mm', style: const TextStyle(fontSize: 11, color: AppColors.treasureYellow)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.phase, required this.active, required this.onTap});

  final BoardTurnPhase phase;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RaidUi.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: active
                ? RaidUi.glassPanel(accent: AppColors.adventureOrange)
                : RaidUi.statTile(),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: active ? AppColors.adventureOrange : AppColors.mysteryPurple,
                  child: Text('${phase.step}', style: TextStyle(color: active ? AppColors.backgroundDark : Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(phase.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(phase.body, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.75), height: 1.35)),
                    ],
                  ),
                ),
                Icon(phase.icon, color: active ? AppColors.adventureOrange : Colors.white38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BriefBullet extends StatelessWidget {
  const _BriefBullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: AppColors.treasureYellow),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
