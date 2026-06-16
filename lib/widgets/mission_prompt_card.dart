import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';

/// Object-first mission card — no colour swatches or hex codes.
class MissionPromptCard extends StatelessWidget {
  const MissionPromptCard({
    super.key,
    required this.mission,
    required this.profile,
    this.showTypeBadge = true,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final bool showTypeBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B263B), Color(0xFF3D5A80)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(mission.picture, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 10),
          Text(
            mission.hueName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: profile.usePictureClues ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mission.challengePrompt,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35),
          ),
          if (mission.clue.isNotEmpty &&
              mission.clue != mission.challengePrompt) ...[
            const SizedBox(height: 8),
            Text(
              mission.clue,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.78), height: 1.35),
            ),
          ],
          if (showTypeBadge) ...[
            const SizedBox(height: 10),
            Text(
              missionTypeLabel(mission.type),
              style: TextStyle(
                color: Colors.amber.shade200,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
