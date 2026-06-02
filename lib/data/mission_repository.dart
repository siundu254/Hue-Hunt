import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';

class MissionRepository {
  Map<SessionMode, List<MissionDefinition>>? _cache;
  List<MissionDefinition>? _boxDeck;
  String? _boxTagline;

  Future<List<MissionDefinition>> chapterFor(SessionMode mode) async {
    await _ensureLoaded();
    final deck = List<MissionDefinition>.from(_cache![mode]!);
    deck.shuffle();
    final length = ModeProfile.forMode(mode).chapterLength;
    return deck.take(length).toList();
  }

  Future<List<MissionDefinition>> boxChapter({int count = 5}) async {
    await _ensureBoxLoaded();
    final deck = List<MissionDefinition>.from(_boxDeck!);
    deck.shuffle();
    return deck.take(count).toList();
  }

  String get boxTagline => _boxTagline ?? 'Device-optional Hunt-Hue Box play';

  int get boxCardCount => _boxDeck?.length ?? 0;

  Future<List<MissionDefinition>> allBoxCards() async {
    await _ensureBoxLoaded();
    return List.unmodifiable(_boxDeck!);
  }

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final raw = await rootBundle.loadString('assets/missions/mission_decks.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cache = {
      for (final mode in SessionMode.values)
        mode: (json[mode.name] as List<dynamic>)
            .map((e) => MissionDefinition.fromJson(e as Map<String, dynamic>))
            .toList(),
    };
  }

  Future<void> _ensureBoxLoaded() async {
    if (_boxDeck != null) return;
    final raw = await rootBundle.loadString('assets/missions/hunt_hue_box_deck.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _boxTagline = json['tagline'] as String?;
    _boxDeck = (json['cards'] as List<dynamic>)
        .map((e) => MissionDefinition.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
