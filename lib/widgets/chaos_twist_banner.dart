import 'package:flutter/material.dart';
import 'package:hue_hunt/models/chaos_twist.dart';
import 'package:hue_hunt/theme/app_colors.dart';

class ChaosTwistBanner extends StatelessWidget {
  const ChaosTwistBanner({super.key, required this.twist});

  final ChaosTwist twist;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C2D12),
            AppColors.accent.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 1,
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
