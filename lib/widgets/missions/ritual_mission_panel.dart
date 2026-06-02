import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/target_hue_card.dart';

class RitualMissionPanel extends StatelessWidget {
  const RitualMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final void Function({required int meterGain, required bool success, int? teamIndex}) onComplete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('RITUAL FINALE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(missionTypeDescription(MissionType.ritual, neutral: profile.neutralCopy)),
            const SizedBox(height: 12),
            TargetHueCard(mission: mission, profile: profile),
            const SizedBox(height: 16),
            const Text(
              'Dim the lights. Everyone hunts a glow-friendly colour in the room, then confirm together.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => onComplete(meterGain: 35, success: true),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Ritual complete — chapter glow!'),
            ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                  radius: 1.1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
