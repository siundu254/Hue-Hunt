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

enum PlaySource { digital, huntHueBox }

class MissionDefinition {
  const MissionDefinition({
    required this.type,
    required this.hueName,
    required this.hex,
    required this.clue,
    required this.picture,
    this.huntCategory = HuntCategory.color,
    this.objectPrompt,
    this.funFact,
    this.boxCardId,
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

  bool get isColourHunt => false; // hunts in app use objects/textures, colour handled in Forge/Echo
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
          ? HuntCategory.color
          : HuntCategory.values.byName(categoryRaw),
      objectPrompt: json['objectPrompt'] as String?,
      funFact: json['funFact'] as String?,
      boxCardId: json['boxCardId'] as String?,
    );
  }
}

String missionTypeLabel(MissionType type) => switch (type) {
      MissionType.hunt => 'HUNT',
      MissionType.forge => 'FORGE',
      MissionType.echo => 'ECHO',
      MissionType.relay => 'RELAY',
      MissionType.duel => 'DUEL',
      MissionType.ritual => 'RITUAL',
    };

String missionTypeDescription(MissionType type, {required bool neutral}) {
  if (neutral) {
    return switch (type) {
      MissionType.hunt => 'Search the space for real-world objects and textures that fit the mission prompt.',
      MissionType.forge => 'Blend the digital palette until it matches the target.',
      MissionType.echo => 'Sketch the shade; teammates rate the match.',
      MissionType.relay => 'Each participant contributes before the timer ends.',
      MissionType.duel => 'Teams compete on the same objective.',
      MissionType.ritual => 'Finale: find a glow-friendly colour together.',
    };
  }
  return switch (type) {
    MissionType.hunt => 'Scavenger hunt — race to find the best object for the prompt!',
    MissionType.forge => 'Mini art studio — mix paints on screen.',
    MissionType.echo => 'Pictionary meets colour — draw and guess.',
    MissionType.relay => 'Game-show relay — pass the device!',
    MissionType.duel => 'Team vs team race!',
    MissionType.ritual => 'Finale ritual — lights low, hunt the glow.',
  };
}
