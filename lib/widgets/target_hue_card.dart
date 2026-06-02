import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/services/color_math.dart';

class TargetHueCard extends StatelessWidget {
  const TargetHueCard({
    super.key,
    required this.mission,
    required this.profile,
  });

  final MissionDefinition mission;
  final ModeProfile profile;

  @override
  Widget build(BuildContext context) {
    final color = mission.targetColor;
    final on = ColorMath.onColor(color);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (profile.usePictureClues) ...[
          Center(
            child: Text(mission.picture, style: const TextStyle(fontSize: 56)),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: profile.usePictureClues ? 72 : 96,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            profile.usePictureClues
                ? mission.hueName
                : '${mission.hueName}\n${ColorMath.toHex(color)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: on,
              fontWeight: FontWeight.bold,
              fontSize: profile.usePictureClues ? 18 : 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profile.usePictureClues ? 'Picture clue: ${mission.clue}' : 'Clue: ${mission.clue}',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
        ),
        const SizedBox(height: 4),
        Text(
          missionTypeLabel(mission.type),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
