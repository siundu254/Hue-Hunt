import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/models/venue_archetype.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/screens/chapter_session_screen.dart';
import 'package:hue_hunt/screens/expedition_lobby_screen.dart';
import 'package:hue_hunt/screens/join_expedition_screen.dart';
import 'package:hue_hunt/services/spirit_forge_service.dart';
import 'package:hue_hunt/services/spirit_tts_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:provider/provider.dart';

/// Core Hue Hunt flow — Spirit Forge for app + Hunt-Hue Box tabletop.
class SpiritForgeScreen extends StatefulWidget {
  const SpiritForgeScreen({super.key, this.initialFormat});

  final ExpeditionFormat? initialFormat;

  @override
  State<SpiritForgeScreen> createState() => _SpiritForgeScreenState();
}

class _SpiritForgeScreenState extends State<SpiritForgeScreen>
    with SingleTickerProviderStateMixin {
  ExpeditionFormat _format = ExpeditionFormat.digitalForge;
  VenueArchetype _venue = VenueArchetype.livingRoom;
  final _roomController = TextEditingController();
  final _teamAController = TextEditingController(text: 'Aurora');
  final _teamBController = TextEditingController(text: 'Ember');
  bool _openRoom = true;
  bool _defaultsLoaded = false;
  bool _forging = false;
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    if (widget.initialFormat != null) _format = widget.initialFormat!;
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_defaultsLoaded) {
      final s = context.read<SettingsProvider>();
      _openRoom = s.defaultOpenRoom;
      _defaultsLoaded = true;
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    _roomController.dispose();
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  SessionMode _modeForVenue() => switch (_venue) {
        VenueArchetype.office || VenueArchetype.hotel => SessionMode.team,
        VenueArchetype.classroom => SessionMode.kids,
        VenueArchetype.party || VenueArchetype.restaurant => SessionMode.party,
        _ => SessionMode.friends,
      };

  Future<void> _forge() async {
    if (_forging) return;
    setState(() => _forging = true);
    HapticFeedback.mediumImpact();

    final settings = context.read<SettingsProvider>();
    final expedition = context.read<ExpeditionProvider>();
    final narration = SpiritForgeService.forgeNarration(
      _venue,
      roomNickname: _roomController.text,
      box: _format == ExpeditionFormat.huntHueBox,
    );

    await SpiritTtsService.instance.speak(
      narration,
      enabled: settings.soundEffects,
      mode: _modeForVenue(),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1800));

    await expedition.configureForgeSession(
      venue: _venue,
      mode: _modeForVenue(),
      playerCount: 6,
      teamCount: 2,
      teamNames: [_teamAController.text.trim(), _teamBController.text.trim()],
      roomNickname: _roomController.text.trim().isEmpty ? null : _roomController.text.trim(),
      missionSecondsOverride: settings.effectiveMissionSeconds(60),
      gameShowReveals: settings.defaultGameShowReveals,
      format: _format,
      openRoom: _openRoom,
    );

    if (!mounted) return;
    setState(() => _forging = false);

    final next = _openRoom
        ? const ExpeditionLobbyScreen()
        : const ChapterSessionScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spirit Forge'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const JoinExpeditionScreen()),
            ),
            child: const Text('Join room'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glow,
              builder: (context, _) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.35),
                    radius: 1.2,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.1 + _glow.value * 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _venue.gradient),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 48)),
                      const Text(
                        'Spirit Forge',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'The AI host invents your game — app, phones, or Hunt-Hue Box.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.35),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Format', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<ExpeditionFormat>(
                  segments: ExpeditionFormat.values
                      .map(
                        (f) => ButtonSegment(
                          value: f,
                          label: Text('${f.emoji} ${f == ExpeditionFormat.digitalForge ? 'App' : 'Box'}'),
                        ),
                      )
                      .toList(),
                  selected: {_format},
                  onSelectionChanged: (s) => setState(() => _format = s.first),
                ),
                const SizedBox(height: 8),
                Text(_format.description, style: const TextStyle(height: 1.35, fontSize: 13)),
                const SizedBox(height: 20),
                const Text('What room are we in?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: VenueArchetype.values.map((v) {
                    return FilterChip(
                      selected: v == _venue,
                      avatar: Text(v.emoji),
                      label: Text(v.label),
                      onSelected: (_) => setState(() => _venue = v),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room nickname',
                    hintText: 'Kevin\'s living room · Acme retreat',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _teamAController,
                        decoration: const InputDecoration(
                          labelText: 'Team 1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _teamBController,
                        decoration: const InputDecoration(
                          labelText: 'Team 2',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text('Open expedition room'),
                  subtitle: const Text(
                    'Other phones join on same Wi‑Fi — team views + spectator voting.',
                  ),
                  value: _openRoom,
                  onChanged: (v) => setState(() => _openRoom = v),
                ),
                Text(_venue.pitchLine, style: TextStyle(color: Colors.white.withValues(alpha: 0.75))),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _forging ? null : _forge,
                  icon: _forging
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(_forging ? 'Forging…' : 'Forge & launch expedition'),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.backgroundDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
