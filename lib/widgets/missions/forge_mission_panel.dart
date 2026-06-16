import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/mission_prompt_card.dart';

class ForgeMissionPanel extends StatefulWidget {
  const ForgeMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final void Function({required int meterGain, required bool success, int? teamIndex}) onComplete;

  @override
  State<ForgeMissionPanel> createState() => _ForgeMissionPanelState();
}

class _ForgeMissionPanelState extends State<ForgeMissionPanel> {
  final _found = [false, false, false];

  int get _foundCount => _found.where((f) => f).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('TRIO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.forge, neutral: widget.profile.neutralCopy)),
        const SizedBox(height: 12),
        MissionPromptCard(mission: widget.mission, profile: widget.profile),
        const SizedBox(height: 16),
        const Text(
          'Hunt the room — tap each slot when your group has a real object.',
          style: TextStyle(height: 1.35),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _found.length; i++) ...[
          CheckboxListTile(
            value: _found[i],
            onChanged: (v) => setState(() => _found[i] = v ?? false),
            title: Text('Object ${i + 1} found in the room'),
            subtitle: Text(_found[i] ? 'Nice — keep hunting!' : 'Still looking…'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _foundCount == 3
              ? () => widget.onComplete(meterGain: 30, success: true)
              : _foundCount >= 1
                  ? () => widget.onComplete(meterGain: 12 + _foundCount * 4, success: true)
                  : null,
          child: Text(
            _foundCount == 3
                ? 'Trio complete!'
                : _foundCount > 0
                    ? 'Submit $_foundCount/3 finds'
                    : 'Find objects in the room first',
          ),
        ),
      ],
    );
  }
}
