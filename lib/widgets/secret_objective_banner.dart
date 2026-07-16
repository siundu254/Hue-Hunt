import 'package:flutter/material.dart';
import 'package:hue_hunt/models/secret_objective.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';

/// Shows the current player's hidden bonus mission (pass-device only).
class SecretObjectiveBanner extends StatelessWidget {
  const SecretObjectiveBanner({
    super.key,
    required this.objective,
    required this.playerNumber,
  });

  final SecretObjective objective;
  final int playerNumber;

  @override
  Widget build(BuildContext context) {
    if (objective.completed) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.treasureYellow.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(RaidUi.radiusSm),
          border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.5)),
        ),
        child: const Row(
          children: [
            Text('🕵️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 10),
            Expanded(child: Text('Secret objective complete! +50 bonus pts')),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mysteryPurple.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(RaidUi.radiusSm),
        border: Border.all(color: AppColors.mysteryPurple.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SECRET OBJECTIVE · Player $playerNumber only',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.treasureYellow.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            objective.prompt,
            style: const TextStyle(fontWeight: FontWeight.w600, height: 1.35),
          ),
          const SizedBox(height: 4),
          Text(
            'Do not show your team — complete in secret for bonus points.',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.65)),
          ),
        ],
      ),
    );
  }
}
