import 'package:flutter/material.dart';
import 'package:hue_hunt/models/chaos_twist.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';

class ChaosTwistBanner extends StatelessWidget {
  const ChaosTwistBanner({super.key, required this.twist});

  final ChaosTwist twist;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RaidUi.radiusMd),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.adventureOrange.withValues(alpha: 0.85),
            AppColors.mysteryPurple.withValues(alpha: 0.75),
          ],
        ),
        border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.55), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.adventureOrange.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(twist.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'CHAOS TWIST · ${twist.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            twist.rule,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.35),
          ),
        ],
      ),
    );
  }
}
