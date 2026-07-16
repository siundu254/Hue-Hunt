import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/mission_prompt_card.dart';

class RitualMissionPanel extends StatelessWidget {
  const RitualMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final MissionCompleteCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('RITUAL FINALE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.ritual, neutral: profile.neutralCopy)),
        const SizedBox(height: 12),
        MissionPromptCard(mission: mission, profile: profile),
        const SizedBox(height: 16),
        const Text(
          'Everyone reveals their favorite find from this chapter. '
          'Group vote: which object wins? No camera required.',
          style: TextStyle(height: 1.4),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => onComplete(meterGain: 35, success: true),
          icon: const Icon(Icons.emoji_events_outlined),
          label: const Text('Finale complete — chapter done!'),
        ),
      ],
    );
  }
}
