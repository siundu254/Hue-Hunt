import 'package:flutter/material.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Visual expedition card for social / Kickstarter clips.
class ExpeditionShareCard extends StatelessWidget {
  const ExpeditionShareCard({
    super.key,
    required this.modeTitle,
    required this.score,
    required this.meter,
    required this.teams,
    this.spiritQuote = 'The Chroma Expedition continues!',
  });

  final String modeTitle;
  final int score;
  final int meter;
  final List<TeamConfig> teams;
  final String spiritQuote;

  @override
  Widget build(BuildContext context) {
    final winner = teams.isEmpty
        ? null
        : teams.reduce((a, b) => a.score >= b.score ? a : b);

    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141424), Color(0xFF2D1B69), Color(0xFF0D1B2A)],
        ),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.25),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Text('✨', style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Text(
                'Hue Hunt',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Chapter Complete',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          Text(
            modeTitle,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(label: 'Score', value: '$score'),
              const SizedBox(width: 10),
              _StatChip(label: 'Chroma', value: '$meter%'),
            ],
          ),
          if (winner != null) ...[
            const SizedBox(height: 14),
            Text(
              '🏆 ${winner.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.accent,
              ),
            ),
            Text('${winner.score} pts', style: const TextStyle(color: Colors.white70)),
          ],
          const SizedBox(height: 14),
          Text(
            '"$spiritQuote"',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.amber.shade100.withValues(alpha: 0.9),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'NovaLumina Studio · novaluminastudio.com',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.45)),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
