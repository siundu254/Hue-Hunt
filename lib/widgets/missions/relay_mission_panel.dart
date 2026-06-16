import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/mission_prompt_card.dart';
import 'package:provider/provider.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';

class RelayMissionPanel extends StatefulWidget {
  const RelayMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.seconds,
    required this.playerCount,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final int seconds;
  final int playerCount;
  final void Function({required int meterGain, required bool success, int? teamIndex}) onComplete;

  @override
  State<RelayMissionPanel> createState() => _RelayMissionPanelState();
}

class _RelayMissionPanelState extends State<RelayMissionPanel> {
  int _secondsLeft = 20;
  int _contributions = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft <= 0) {
        _finish();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _finish() {
    _timer?.cancel();
    final success = _contributions >= widget.playerCount.clamp(1, 4);
    widget.onComplete(meterGain: success ? 28 : 8, success: success);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expedition = context.watch<ExpeditionProvider>();
    final playerNum = expedition.relayPlayer + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('RELAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Chip(label: Text('${_secondsLeft}s')),
          ],
        ),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.relay, neutral: widget.profile.neutralCopy)),
        const SizedBox(height: 12),
        MissionPromptCard(mission: widget.mission, profile: widget.profile),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              const Icon(Icons.swap_horiz, size: 36),
              const SizedBox(height: 8),
              Text(
                'Pass device to Player $playerNum',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Contributions: $_contributions / ${widget.playerCount}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            setState(() => _contributions++);
            expedition.nextRelayPlayer();
            if (_contributions >= widget.playerCount) _finish();
          },
          child: const Text('I found my object — pass it on'),
        ),
      ],
    );
  }
}
