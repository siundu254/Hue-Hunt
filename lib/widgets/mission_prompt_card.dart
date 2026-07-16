import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';

/// Object-first mission card — Room Raiders flashlight panel.
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
      padding: const EdgeInsets.all(22),
      decoration: RaidUi.missionCard(),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.adventureOrange.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(mission.picture, style: const TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 8),
          Text(
            mission.hueName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: profile.usePictureClues ? 17 : 19,
              fontWeight: FontWeight.w800,
              color: AppColors.treasureYellow.withValues(alpha: 0.95),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mission.challengePrompt,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35),
          ),
          if (mission.clue.isNotEmpty && mission.clue != mission.challengePrompt) ...[
            const SizedBox(height: 8),
            Text(
              mission.clue,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.72), height: 1.35, fontSize: 14),
            ),
          ],
          if (showTypeBadge) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: RaidUi.featurePill(),
              child: Text(
                missionTypeLabel(mission.type),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  fontSize: 11,
                ),
              ),
            ),
          ],
          if (mission.isDecoy) ...[
            const SizedBox(height: 10),
            Text(
              '${AppBranding.productName} · possible decoy',
              style: TextStyle(fontSize: 11, color: Colors.purple.shade200),
            ),
          ],
        ],
      ),
    );
  }
}
