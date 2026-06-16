import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/services/expedition_room_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// iPad / presenter layout (HH-04) — large type, live room stats.
class HostModePanel extends StatelessWidget {
  const HostModePanel({
    super.key,
    required this.expedition,
    required this.mission,
  });

  final ExpeditionProvider expedition;
  final MissionDefinition? mission;

  @override
  Widget build(BuildContext context) {
    final snap = ExpeditionRoomService.instance.latestSnapshot;
    final m = mission;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.5),
            AppColors.backgroundMid.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'HOST MODE',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 11),
          ),
          if (m != null) ...[
            const SizedBox(height: 8),
            Text(
              m.picture,
              style: const TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Text(
              m.challengePrompt,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.25),
            ),
          ],
          if (snap != null && snap.spectatorVoteCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Spectators: ${snap.spectatorVoteAvg.toStringAsFixed(1)} ★ avg (${snap.spectatorVoteCount} votes) → +${ExpeditionRoomService.instance.spectatorBonus()} bonus',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.amber.shade200),
            ),
          ],
          if (snap != null)
            Text(
              '${snap.participants.length} connected devices',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
        ],
      ),
    );
  }
}
