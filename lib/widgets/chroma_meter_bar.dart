import 'package:flutter/material.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';

class ChromaMeterBar extends StatelessWidget {
  const ChromaMeterBar({super.key, required this.value, this.streak});

  final int value;
  final int? streak;

  @override
  Widget build(BuildContext context) {
    final progress = value / 100;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RaidUi.glassPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.bolt_rounded, size: 18, color: AppColors.treasureYellow.withValues(alpha: 0.9)),
                  const SizedBox(width: 6),
                  const Text('Raid Meter', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                ],
              ),
              if (streak != null && streak! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: RaidUi.featurePill(),
                  child: Text(
                    'Streak ×$streak',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(height: 14, color: Colors.white.withValues(alpha: 0.08)),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mysteryPurple,
                          RaidUi.raidMeterColor(progress),
                          AppColors.treasureYellow,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.adventureOrange.withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$value%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}
