import 'package:flutter/material.dart';
import 'package:hue_hunt/theme/app_colors.dart';

class SuddenDeathBanner extends StatelessWidget {
  const SuddenDeathBanner({
    super.key,
    required this.secondsLeft,
  });

  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    final urgent = secondsLeft <= 15;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: (urgent ? Colors.red : AppColors.adventureOrange).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgent ? Colors.redAccent : AppColors.adventureOrange,
          width: urgent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(urgent ? '💀' : '⏱️', style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              urgent
                  ? 'SUDDEN DEATH — ${secondsLeft}s left!'
                  : 'Sudden death timer — $secondsLeft seconds remaining',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: urgent ? Colors.redAccent : AppColors.adventureOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
