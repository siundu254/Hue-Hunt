import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/services/spirit_forge_service.dart';
import 'package:hue_hunt/services/unlock_service.dart';

class MissionRepository {
  Map<SessionMode, List<MissionDefinition>>? _cache;
  List<MissionDefinition>? _boxDeck;
  List<MissionDefinition>? _bonusChapter;
  String? _boxTagline;

  Future<List<MissionDefinition>> chapterFor(SessionMode mode) async {
    await _ensureLoaded();
    final deck = List<MissionDefinition>.from(_cache![mode]!);
    deck.shuffle();
    final length = ModeProfile.forMode(mode).chapterLength;
    return deck.take(length).toList();
  }

  Future<List<MissionDefinition>> bonusChapter({int count = 4}) async {
    await _ensureBonusLoaded();
    final deck = List<MissionDefinition>.from(_bonusChapter!);
    deck.shuffle();
    return deck.take(count).toList();
  }

  Future<bool> canPlayBonusChapter() => UnlockService.isBonusChapterUnlocked();

  Future<List<MissionDefinition>> boxChapter({int count = 5}) async {
    await _ensureBoxLoaded();
    return SpiritForgeService.forgeFromBoxDeck(_boxDeck!, count: count);
  }

  String get boxTagline => _boxTagline ?? 'Device-optional Hunt-Hue Box play';

  int get boxCardCount => _boxDeck?.length ?? 0;

  Future<List<MissionDefinition>> allBoxCards() async {
    await _ensureBoxLoaded();
    return List.unmodifiable(_boxDeck!);
  }

  Set<MissionType> typesInChapter(List<MissionDefinition> chapter) =>
      chapter.map((m) => m.type).toSet();

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

  Future<void> _ensureBonusLoaded() async {
    if (_bonusChapter != null) return;
    final raw = await rootBundle.loadString('assets/missions/bonus_chapter.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _bonusChapter = (json['missions'] as List<dynamic>)
        .map((e) => MissionDefinition.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
