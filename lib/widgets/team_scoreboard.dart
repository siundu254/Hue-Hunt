import 'package:flutter/material.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/theme/app_colors.dart';

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: highlightIndex == i
                  ? _teamColor(i).withValues(alpha: 0.28)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: highlightIndex == i
                    ? _teamColor(i).withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.1),
                width: highlightIndex == i ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: _teamColor(i),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  teams[i].name,
                  style: TextStyle(
                    fontWeight: highlightIndex == i ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${teams[i].score}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: highlightIndex == i ? AppColors.treasureYellow : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _teamColor(int i) => switch (i % 4) {
        0 => AppColors.adventureOrange,
        1 => AppColors.mysteryPurple,
        2 => AppColors.treasureYellow,
        _ => const Color(0xFF4ECDC4),
      };
}
