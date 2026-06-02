import 'package:flutter/material.dart';
import 'package:hue_hunt/l10n/mode_l10n.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/screens/chapter_session_screen.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:provider/provider.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({
    super.key,
    required this.mode,
    this.playSource = PlaySource.digital,
  });

  final SessionMode mode;
  final PlaySource playSource;

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  late ModeProfile _profile;
  int _players = 4;
  int _teams = 2;
  bool _camera = false;
  late List<TextEditingController> _teamNameControllers;

  @override
  void initState() {
    super.initState();
    _profile = ModeProfile.forMode(widget.mode);
    final settings = context.read<SettingsProvider>();
    _players = switch (widget.mode) {
      SessionMode.family => 3,
      SessionMode.kids => 6,
      SessionMode.party => 6,
      SessionMode.team => 8,
      SessionMode.friends => 4,
    };
    _teams = switch (widget.mode) {
      SessionMode.party => 2,
      SessionMode.team => 4,
      SessionMode.friends => 2,
      _ => 2,
    };
    _camera = settings.defaultCameraBonus && _profile.cameraAllowed
        ? true
        : _profile.cameraDefault;
    _teamNameControllers = defaultTeams(_teams)
        .map((t) => TextEditingController(text: t.name))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _teamNameControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTeamsChanged(int count) {
    setState(() {
      _teams = count;
      for (final c in _teamNameControllers) {
        c.dispose();
      }
      _teamNameControllers = defaultTeams(_teams)
          .map((t) => TextEditingController(text: t.name))
          .toList();
    });
  }

  Future<void> _start() async {
    final expedition = context.read<ExpeditionProvider>();
    final settings = context.read<SettingsProvider>();
    final seconds = settings.effectiveMissionSeconds(_profile.missionSeconds);
    await expedition.configureSession(
      mode: widget.mode,
      playerCount: _players,
      teamCount: _teams,
      cameraEnabled: _camera,
      playSource: widget.playSource,
      teamNames: _teamNameControllers.map((c) => c.text.trim()).toList(),
      missionSecondsOverride: seconds,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ChapterSessionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.playSource == PlaySource.huntHueBox
              ? l.sessionSetupBox
              : _profile.localizedTitle(l),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_profile.localizedSubtitle(l), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(_profile.localizedAudience(l)),
            const SizedBox(height: 20),
            Text(l.sessionPlayers, style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _players.toDouble(),
              min: 1,
              max: 12,
              divisions: 11,
              label: '$_players',
              onChanged: (v) => setState(() => _players = v.round()),
            ),
            Text(l.sessionTeams, style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _teams.toDouble(),
              min: 2,
              max: 4,
              divisions: 2,
              label: '$_teams',
              onChanged: (v) => _onTeamsChanged(v.round()),
            ),
            for (var i = 0; i < _teamNameControllers.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _teamNameControllers[i],
                  decoration: InputDecoration(
                    labelText: l.sessionTeamName(i + 1),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            Text(
              l.sessionSummary(_players, _teams, _profile.chapterLength),
            ),
            const SizedBox(height: 16),
            if (_profile.cameraAllowed)
              SwitchListTile(
                title: Text(l.sessionCameraOptional),
                subtitle: Text(l.sessionCameraOptionalSub),
                value: _camera,
                onChanged: (v) => setState(() => _camera = v),
              )
            else
              ListTile(
                leading: const Icon(Icons.no_photography_outlined),
                title: Text(l.sessionCameraDisabled),
                subtitle: Text(l.sessionCameraDisabledSub),
              ),
            const SizedBox(height: 8),
            _FeatureRow(icon: Icons.search, text: l.sessionFeatureHunts),
            _FeatureRow(
              icon: Icons.swap_horiz,
              text: _profile.useGroupConfirm ? l.sessionFeaturePass : l.sessionFeatureTurns,
            ),
            _FeatureRow(icon: Icons.emoji_events_outlined, text: l.sessionFeatureScoreboard),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _start,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(l.sessionBeginBriefing),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
