import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hue_hunt/models/hunt_category.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/widgets/sudden_death_banner.dart';
import 'package:provider/provider.dart';

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
  final MissionCompleteCallback onComplete;

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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    if (_secondsLeft <= 0) {
      final expedition = context.read<ExpeditionProvider>();
      if (expedition.suddenDeathActive && _step == _HuntStep.search) {
        _timer?.cancel();
        widget.onComplete(
          meterGain: 0,
          success: false,
          teamIndex: expedition.activeTeamIndex,
          secondsElapsed: widget.seconds,
        );
      }
      return;
    }
    setState(() => _secondsLeft--);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _secondsElapsed => widget.seconds - _secondsLeft;

  void _success({required int gain}) {
    final teamIdx = context.read<ExpeditionProvider>().activeTeamIndex;
    widget.onComplete(
      meterGain: gain,
      success: true,
      teamIndex: teamIdx,
      secondsElapsed: _secondsElapsed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.mission.huntCategory;
    final expedition = context.watch<ExpeditionProvider>();
    final stageIndex = expedition.clueStageIndex;
    final prompt = widget.mission.hasClueChain
        ? widget.mission.challengeAtStage(stageIndex)
        : widget.mission.challengePrompt;
    final urgent = expedition.suddenDeathActive && _secondsLeft <= 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (expedition.suddenDeathActive)
          SuddenDeathBanner(secondsLeft: _secondsLeft),
        if (widget.mission.isDecoy)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4)),
            ),
            child: const Text(
              '🃏 Could be a decoy — confirm only if you trust the prompt!',
              textAlign: TextAlign.center,
            ),
          ),
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
            Chip(
              label: Text(
                '${_secondsLeft}s',
                style: TextStyle(
                  color: urgent ? Colors.redAccent : null,
                  fontWeight: urgent ? FontWeight.bold : null,
                ),
              ),
              backgroundColor: urgent ? Colors.red.withValues(alpha: 0.2) : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.profile.neutralCopy
              ? 'Search the space for real-world objects and textures — never colour swatches.'
              : 'Scavenger hunt — race to find the best object for this prompt!',
        ),
        if (widget.mission.hasClueChain) ...[
          const SizedBox(height: 8),
          Text(
            'Multi-stage clue ${stageIndex + 1} of ${widget.mission.clueStages.length}',
            style: TextStyle(color: AppColors.treasureYellow, fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 12),
        _scavengerCard(prompt),
        if (widget.mission.funFact != null && _step != _HuntStep.search) ...[
          const SizedBox(height: 8),
          Text(
            widget.mission.funFact!,
            style: TextStyle(color: Colors.amber.shade200, fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: 16),
        if (_step == _HuntStep.search) ...[
          if (widget.mission.hasClueChain &&
              stageIndex < widget.mission.clueStages.length - 1)
            OutlinedButton(
              onPressed: expedition.advanceClueStage,
              child: const Text('Found it — reveal next clue'),
            ),
          if (widget.mission.hasClueChain &&
              stageIndex < widget.mission.clueStages.length - 1)
            const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => setState(() => _step = _HuntStep.confirm),
            icon: const Icon(Icons.directions_run),
            label: const Text('We found it in the room!'),
          ),
        ] else if (_step == _HuntStep.confirm) ...[
          _confirmButtons(expedition),
        ],
      ],
    );
  }

  Widget _scavengerCard(String prompt) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: RaidUi.missionCard(),
      child: Column(
        children: [
          Text(widget.mission.picture, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (widget.mission.clue != prompt)
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
          widget.mission.isDecoy
              ? 'Decoy check — was this a fake mission?'
              : widget.profile.useGroupConfirm
                  ? 'Group vote: does the object match the mission?'
                  : 'Confirm your find matches the mission.',
        ),
        if (expedition.usesTeams) ...[
          const SizedBox(height: 8),
          Text('Points go to ${expedition.activeTeam?.name ?? 'your team'}.'),
        ],
        if (expedition.doublePointsActive) ...[
          const SizedBox(height: 8),
          Text(
            'Chaos bonus: double points on this confirm!',
            style: TextStyle(color: AppColors.treasureYellow, fontSize: 13),
          ),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => _success(gain: widget.mission.isDecoy ? 0 : 28),
          child: Text(widget.mission.isDecoy ? 'Yep — decoy prank!' : 'Yes — nailed it!'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => widget.onComplete(
            meterGain: 5,
            success: false,
            teamIndex: expedition.activeTeamIndex,
            secondsElapsed: _secondsElapsed,
          ),
          child: const Text('Rematch — try another object'),
        ),
      ],
    );
  }
}
