import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/models/chapter_award.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// MVP / highlight card for social sharing.
class RaidHighlightShareCard extends StatelessWidget {
  const RaidHighlightShareCard({
    super.key,
    required this.modeTitle,
    required this.teams,
    this.mvpAward,
    this.score = 0,
    this.meter = 0,
  });

  final String modeTitle;
  final List<TeamConfig> teams;
  final ChapterAward? mvpAward;
  final int score;
  final int meter;

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
          colors: [AppColors.backgroundDark, AppColors.mysteryPurple, Color(0xFF1A1028)],
        ),
        border: Border.all(color: AppColors.adventureOrange.withValues(alpha: 0.6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/branding/room_raiders_logo.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                AppBranding.productName,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.treasureYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (mvpAward != null) ...[
            Text(
              '${mvpAward!.emoji} ${mvpAward!.title}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              mvpAward!.recipient,
              style: TextStyle(color: AppColors.adventureOrange, fontSize: 16),
            ),
            Text(mvpAward!.reason, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
          ],
          if (winner != null) ...[
            Text(
              '🏆 ${winner.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.adventureOrange,
              ),
            ),
            Text('${winner.score} pts · $modeTitle'),
          ],
          const SizedBox(height: 10),
          Text('Score $score · Raid Meter $meter%'),
          const SizedBox(height: 10),
          Text(
            AppBranding.studioName,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.45)),
          ),
        ],
      ),
    );
  }
}
