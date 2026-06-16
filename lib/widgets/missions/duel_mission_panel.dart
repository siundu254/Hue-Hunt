import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/mission_prompt_card.dart';
import 'package:provider/provider.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';

class DuelMissionPanel extends StatelessWidget {
  const DuelMissionPanel({
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
    final expedition = context.watch<ExpeditionProvider>();
    final needed = 2;

    void tapTeam({required bool teamA}) {
      expedition.recordDuelWin(teamA: teamA);
      final wins = teamA ? expedition.teamAWins : expedition.teamBWins;
      if (wins >= needed) {
        onComplete(meterGain: 30, success: true);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('DUEL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.duel, neutral: profile.neutralCopy)),
        const SizedBox(height: 12),
        MissionPromptCard(mission: mission, profile: profile),
        const SizedBox(height: 12),
        const Text(
          'Both teams hunt the same prompt in the room. Tap when your team has a match.',
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.35),
        ),
        const SizedBox(height: 8),
        Text(
          'First team to $needed wins takes the duel.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TeamCard(
                label: profile.neutralCopy ? 'Team A' : 'Squad Aurora',
                wins: expedition.teamAWins,
                color: Colors.cyan,
                onTap: () => tapTeam(teamA: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TeamCard(
                label: profile.neutralCopy ? 'Team B' : 'Squad Ember',
                wins: expedition.teamBWins,
                color: Colors.orange,
                onTap: () => tapTeam(teamA: false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.label,
    required this.wins,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int wins;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$wins wins', style: TextStyle(color: color, fontSize: 20)),
              const SizedBox(height: 4),
              const Text('Tap when your team finishes', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
