import 'package:flutter/material.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:share_plus/share_plus.dart';

class ChapterCompletePanel extends StatelessWidget {
  const ChapterCompletePanel({
    super.key,
    required this.score,
    required this.meter,
    required this.modeTitle,
    required this.teams,
    required this.onViewMap,
    required this.onDone,
  });

  final int score;
  final int meter;
  final String modeTitle;
  final List<TeamConfig> teams;
  final VoidCallback onViewMap;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final winner = teams.isEmpty
        ? null
        : teams.reduce((a, b) => a.score >= b.score ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Chapter complete!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('$modeTitle — great hunt, explorers.'),
        const SizedBox(height: 12),
        Text('Session score: $score · Chroma Meter: $meter%'),
        if (winner != null) ...[
          const SizedBox(height: 12),
          Text(
            'Leading team: ${winner.name} (${winner.score} pts)',
            style: TextStyle(color: Colors.amber.shade200, fontWeight: FontWeight.w600),
          ),
        ],
        if (teams.length > 1) ...[
          const SizedBox(height: 12),
          ...teams.map((t) => ListTile(
                dense: true,
                title: Text(t.name),
                trailing: Text('${t.score} pts'),
              )),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onViewMap,
          icon: const Icon(Icons.map_outlined),
          label: const Text('View Chroma Map'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => Share.share(
            'We finished a Hue Hunt $modeTitle chapter! Chroma Meter $meter%'
            '${winner != null ? " — ${winner.name} led the teams." : ""}',
            subject: 'Hue Hunt Expedition',
          ),
          icon: const Icon(Icons.ios_share),
          label: const Text('Share expedition card'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onDone, child: const Text('Back to home')),
      ],
    );
  }
}
