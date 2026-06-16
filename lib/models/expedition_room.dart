import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/venue_archetype.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';

enum PlayerRole { host, team, spectator }

class RoomParticipant {
  const RoomParticipant({
    required this.id,
    required this.name,
    required this.role,
    this.teamIndex,
  });

  final String id;
  final String name;
  final PlayerRole role;
  final int? teamIndex;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'teamIndex': teamIndex,
      };

  factory RoomParticipant.fromJson(Map<String, dynamic> json) => RoomParticipant(
        id: json['id'] as String,
        name: json['name'] as String,
        role: PlayerRole.values.byName(json['role'] as String),
        teamIndex: json['teamIndex'] as int?,
      );
}

/// LAN-synced expedition state for team phones + spectator voters.
class ExpeditionRoomSnapshot {
  const ExpeditionRoomSnapshot({
    required this.roomCode,
    required this.format,
    required this.venue,
    required this.phase,
    required this.missionIndex,
    required this.chapterLength,
    required this.challengePrompt,
    required this.missionPicture,
    required this.missionType,
    required this.teams,
    required this.chromaMeter,
    required this.participants,
    required this.spectatorVoteAvg,
    required this.spectatorVoteCount,
    this.chaosTitle,
    this.activeTeamName,
  });

  final String roomCode;
  final ExpeditionFormat format;
  final String venue;
  final String phase;
  final int missionIndex;
  final int chapterLength;
  final String challengePrompt;
  final String missionPicture;
  final String missionType;
  final List<Map<String, dynamic>> teams;
  final int chromaMeter;
  final List<RoomParticipant> participants;
  final double spectatorVoteAvg;
  final int spectatorVoteCount;
  final String? chaosTitle;
  final String? activeTeamName;

  factory ExpeditionRoomSnapshot.fromProvider(
    ExpeditionProvider expedition, {
    required String roomCode,
    required ExpeditionFormat format,
    required List<RoomParticipant> participants,
    double spectatorVoteAvg = 0,
    int spectatorVoteCount = 0,
  }) {
    final mission = expedition.currentMission;
    return ExpeditionRoomSnapshot(
      roomCode: roomCode,
      format: format,
      venue: expedition.forgeVenue?.label ?? 'Expedition',
      phase: expedition.phase.name,
      missionIndex: expedition.missionIndex,
      chapterLength: expedition.chapter.length,
      challengePrompt: mission?.challengePrompt ?? 'Briefing…',
      missionPicture: mission?.picture ?? '✨',
      missionType: mission != null ? missionTypeLabel(mission.type) : 'BRIEF',
      teams: expedition.teams
          .map((t) => {'name': t.name, 'score': t.score})
          .toList(),
      chromaMeter: expedition.chromaMeter,
      participants: participants,
      spectatorVoteAvg: spectatorVoteAvg,
      spectatorVoteCount: spectatorVoteCount,
      chaosTitle: expedition.activeChaos?.title,
      activeTeamName: expedition.activeTeam?.name,
    );
  }

  Map<String, dynamic> toJson() => {
        'roomCode': roomCode,
        'format': format.name,
        'venue': venue,
        'phase': phase,
        'missionIndex': missionIndex,
        'chapterLength': chapterLength,
        'challengePrompt': challengePrompt,
        'missionPicture': missionPicture,
        'missionType': missionType,
        'teams': teams,
        'chromaMeter': chromaMeter,
        'participants': participants.map((p) => p.toJson()).toList(),
        'spectatorVoteAvg': spectatorVoteAvg,
        'spectatorVoteCount': spectatorVoteCount,
        'chaosTitle': chaosTitle,
        'activeTeamName': activeTeamName,
      };

  factory ExpeditionRoomSnapshot.fromJson(Map<String, dynamic> json) =>
      ExpeditionRoomSnapshot(
        roomCode: json['roomCode'] as String,
        format: ExpeditionFormat.values.byName(json['format'] as String),
        venue: json['venue'] as String,
        phase: json['phase'] as String,
        missionIndex: json['missionIndex'] as int,
        chapterLength: json['chapterLength'] as int,
        challengePrompt: json['challengePrompt'] as String,
        missionPicture: json['missionPicture'] as String,
        missionType: json['missionType'] as String,
        teams: (json['teams'] as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
        chromaMeter: json['chromaMeter'] as int,
        participants: (json['participants'] as List<dynamic>)
            .map((e) => RoomParticipant.fromJson(e as Map<String, dynamic>))
            .toList(),
        spectatorVoteAvg: (json['spectatorVoteAvg'] as num?)?.toDouble() ?? 0,
        spectatorVoteCount: json['spectatorVoteCount'] as int? ?? 0,
        chaosTitle: json['chaosTitle'] as String?,
        activeTeamName: json['activeTeamName'] as String?,
      );
}
