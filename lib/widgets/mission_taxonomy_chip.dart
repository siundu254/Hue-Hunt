import 'package:flutter/material.dart';
import 'package:hue_hunt/models/hunt_category.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Visible mission taxonomy for briefing and intro (v1.5).
class MissionTaxonomyChip extends StatelessWidget {
  const MissionTaxonomyChip({
    super.key,
    required this.mission,
    this.large = false,
  });

  final MissionDefinition? mission;
  final bool large;

  @override
  Widget build(BuildContext context) {
    if (mission == null) {
      return const MissionTypeOverviewRow();
    }
    final label = missionTaxonomyLabel(mission!);
    final icon = missionTaxonomyIcon(mission!);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 10,
        vertical: large ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: large ? 20 : 16)),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: large ? 13 : 11,
              letterSpacing: 0.6,
                  color: AppColors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

/// Briefing overview of mission types in this chapter.
class MissionTypeOverviewRow extends StatelessWidget {
  const MissionTypeOverviewRow({super.key, this.types});

  final List<MissionType>? types;

  @override
  Widget build(BuildContext context) {
    final chips = types ?? MissionType.values;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((t) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            missionTypeLabel(t),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}

String missionTaxonomyLabel(MissionDefinition mission) {
  if (mission.type == MissionType.hunt) {
    return mission.huntCategory.label;
  }
  return missionTypeLabel(mission.type);
}

String missionTaxonomyIcon(MissionDefinition mission) {
  if (mission.type == MissionType.hunt) {
    return mission.huntCategory.icon;
  }
  return switch (mission.type) {
    MissionType.forge => '📦',
    MissionType.echo => '✏️',
    MissionType.relay => '🔄',
    MissionType.duel => '⚔️',
    MissionType.ritual => '✨',
    MissionType.hunt => '🔍',
  };
}
