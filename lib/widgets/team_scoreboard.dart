import 'package:flutter/material.dart';
import 'package:hue_hunt/models/team_config.dart';

class TeamScoreboard extends StatelessWidget {
  const TeamScoreboard({super.key, required this.teams, this.highlightIndex});

  final List<TeamConfig> teams;
  final int? highlightIndex;

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < teams.length; i++)
          Chip(
            avatar: CircleAvatar(
              backgroundColor: _teamColor(i).withValues(alpha: 0.8),
              child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: Colors.white)),
            ),
            label: Text('${teams[i].name}: ${teams[i].score}'),
            backgroundColor: highlightIndex == i
                ? _teamColor(i).withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.08),
          ),
      ],
    );
  }

  Color _teamColor(int i) => switch (i % 4) {
        0 => Colors.cyan,
        1 => Colors.orange,
        2 => Colors.purple,
        _ => Colors.green,
      };
}
