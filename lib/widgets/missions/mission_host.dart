import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/missions/duel_mission_panel.dart';
import 'package:hue_hunt/widgets/missions/echo_mission_panel.dart';
import 'package:hue_hunt/widgets/missions/forge_mission_panel.dart';
import 'package:hue_hunt/widgets/missions/hunt_mission_panel.dart';
import 'package:hue_hunt/widgets/missions/relay_mission_panel.dart';
import 'package:hue_hunt/widgets/missions/ritual_mission_panel.dart';

class MissionHost extends StatelessWidget {
  const MissionHost({
    super.key,
    required this.mission,
    required this.profile,
    required this.seconds,
    required this.playerCount,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final int seconds;
  final int playerCount;
  final MissionCompleteCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return switch (mission.type) {
      MissionType.hunt => HuntMissionPanel(
          mission: mission,
          profile: profile,
          seconds: seconds,
          onComplete: onComplete,
        ),
      MissionType.forge => ForgeMissionPanel(
          mission: mission,
          profile: profile,
          onComplete: onComplete,
        ),
      MissionType.echo => EchoMissionPanel(
          mission: mission,
          profile: profile,
          onComplete: onComplete,
        ),
      MissionType.relay => RelayMissionPanel(
          mission: mission,
          profile: profile,
          seconds: 20,
          playerCount: playerCount,
          onComplete: onComplete,
        ),
      MissionType.duel => DuelMissionPanel(
          mission: mission,
          profile: profile,
          onComplete: onComplete,
        ),
      MissionType.ritual => RitualMissionPanel(
          mission: mission,
          profile: profile,
          onComplete: onComplete,
        ),
    };
  }
}
