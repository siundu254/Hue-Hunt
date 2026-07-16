import 'package:flutter/material.dart';
import 'package:hue_hunt/models/hunt_category.dart';

enum MissionType { hunt, forge, echo, relay, duel, ritual }

enum SessionPhase {
  briefing,
  missionIntro,
  passDevice,
  missionPlay,
  meterSync,
  spiritReaction,
  chapterComplete,
}

enum PlaySource { digital, huntHueBox, bonusChapter, spiritForge }

class MissionDefinition {
  const MissionDefinition({
    required this.type,
    required this.hueName,
    required this.hex,
    required this.clue,
    required this.picture,
    this.huntCategory = HuntCategory.object,
    this.objectPrompt,
    this.funFact,
    this.boxCardId,
    this.isDecoy = false,
    this.clueStages = const [],
  });

  final MissionType type;
  final String hueName;
  final String hex;
  final String clue;
  final String picture;
  final HuntCategory huntCategory;
  final String? objectPrompt;
  final String? funFact;
  final String? boxCardId;
  final bool isDecoy;
  final List<String> clueStages;

  /// Primary player-facing instruction — always object/scene led.
  String get challengePrompt {
    if (objectPrompt != null && objectPrompt!.trim().isNotEmpty) {
      return objectPrompt!.trim();
    }
    return clue;
  }

  /// Multi-stage clue chain — current stage text for [stageIndex].
  String challengeAtStage(int stageIndex) {
    if (clueStages.isEmpty) return challengePrompt;
    final idx = stageIndex.clamp(0, clueStages.length - 1);
    return clueStages[idx];
  }

  bool get hasClueChain => clueStages.length > 1;
  bool get isScavengerHunt => type == MissionType.hunt;

  String get huntHeadline {
    if (objectPrompt != null && objectPrompt!.isNotEmpty) return objectPrompt!;
    return hueName;
  }

  Color get targetColor {
    final value = hex.replaceFirst('#', '');
    if (value.length != 6) return Colors.grey;
    final rgb = int.parse(value, radix: 16);
    return Color(0xFF000000 | rgb);
  }

  factory MissionDefinition.fromJson(Map<String, dynamic> json) {
    final categoryRaw = json['huntCategory'] as String?;
    return MissionDefinition(
      type: MissionType.values.byName(json['type'] as String),
      hueName: json['hueName'] as String,
      hex: json['hex'] as String? ?? '#888888',
      clue: json['clue'] as String,
      picture: json['picture'] as String? ?? '🎨',
      huntCategory: categoryRaw == null
          ? HuntCategory.object
          : HuntCategory.values.byName(categoryRaw),
      objectPrompt: json['objectPrompt'] as String?,
      funFact: json['funFact'] as String?,
      boxCardId: json['boxCardId'] as String?,
      isDecoy: json['isDecoy'] as bool? ?? false,
      clueStages: (json['clueStages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}

String missionTypeLabel(MissionType type) => switch (type) {
      MissionType.hunt => 'HUNT',
      MissionType.forge => 'TRIO',
      MissionType.echo => 'ECHO',
      MissionType.relay => 'RELAY',
      MissionType.duel => 'DUEL',
      MissionType.ritual => 'RITUAL',
    };

String missionTypeDescription(MissionType type, {required bool neutral}) {
  if (neutral) {
    return switch (type) {
      MissionType.hunt => 'Search the space for real-world objects and textures that fit the mission prompt.',
      MissionType.forge => 'Collect three real objects from the room that match the theme.',
      MissionType.echo => 'Find a real object that fits the prompt, then teammates guess your pick.',
      MissionType.relay => 'Each participant finds one object, then passes the device.',
      MissionType.duel => 'Teams race to find the same object prompt first.',
      MissionType.ritual => 'Finale: group vote on the best find from the chapter.',
    };
  }
  return switch (type) {
    MissionType.hunt => 'Scavenger hunt — race to find the best object for the prompt!',
    MissionType.forge => 'Trio hunt — gather 3 objects from the room!',
    MissionType.echo => 'Echo challenge — reveal an object and let the group guess your logic!',
    MissionType.relay => 'Game-show relay — pass the device, add your find!',
    MissionType.duel => 'Team vs team object race!',
    MissionType.ritual => 'Finale ritual — showcase your best find!',
  };
}

typedef MissionCompleteCallback = void Function({
  required int meterGain,
  required bool success,
  int? teamIndex,
  int? secondsElapsed,
});
