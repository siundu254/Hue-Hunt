import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hue_hunt/models/hunt_category.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:provider/provider.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';

enum _HuntStep { search, confirm }

class HuntMissionPanel extends StatefulWidget {
  const HuntMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.seconds,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final int seconds;
  final void Function({required int meterGain, required bool success, int? teamIndex}) onComplete;

  @override
  State<HuntMissionPanel> createState() => _HuntMissionPanelState();
}

class _HuntMissionPanelState extends State<HuntMissionPanel> {
  _HuntStep _step = _HuntStep.search;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 0 || !mounted) return;
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _success({required int gain}) {
    final teamIdx = context.read<ExpeditionProvider>().activeTeamIndex;
    widget.onComplete(meterGain: gain, success: true, teamIndex: teamIdx);
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.mission.huntCategory;
    final expedition = context.watch<ExpeditionProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 6),
                Text(
                  category.label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            Chip(label: Text('${_secondsLeft}s')),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.profile.neutralCopy
              ? 'Search the space for real-world objects and textures that fit the mission.'
              : 'Scavenger hunt — race to find the best object for this prompt.',
        ),
        const SizedBox(height: 12),
        _scavengerCard(),
        if (widget.mission.funFact != null && _step != _HuntStep.search) ...[
          const SizedBox(height: 8),
          Text(widget.mission.funFact!, style: TextStyle(color: Colors.amber.shade200, fontStyle: FontStyle.italic)),
        ],
        const SizedBox(height: 16),
        if (_step == _HuntStep.search) ...[
          FilledButton.icon(
            onPressed: () => setState(() {
              _step = _HuntStep.confirm;
            }),
            icon: const Icon(Icons.directions_run),
            label: Text(
              'We found it in the room!',
            ),
          ),
        ] else if (_step == _HuntStep.confirm) ...[
          _confirmButtons(expedition),
        ],
      ],
    );
  }

  Widget _scavengerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B263B), Color(0xFF3D5A80)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(widget.mission.picture, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            widget.mission.huntHeadline,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.mission.clue,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _confirmButtons(ExpeditionProvider expedition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.profile.useGroupConfirm
              ? 'Group vote: does the object match the mission?'
              : 'Confirm your find matches the mission.',
        ),
        if (expedition.usesTeams) ...[
          const SizedBox(height: 8),
          Text('Points go to ${expedition.activeTeam?.name ?? 'your team'}.'),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => _success(gain: widget.mission.isScavengerHunt ? 28 : 22),
          child: const Text('Yes — nailed it!'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => widget.onComplete(meterGain: 5, success: false, teamIndex: expedition.activeTeamIndex),
          child: const Text('Rematch — try another object'),
        ),
      ],
    );
  }
}
