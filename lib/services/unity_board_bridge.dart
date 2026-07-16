import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/models/raid_mode_deck.dart';

typedef UnityBoardMessageHandler = void Function(String event, Map<String, dynamic> payload);
typedef UnityPostMessage = void Function(String gameObject, String method, String message);

/// Bridge to Unity 3D board — attach after [UnityWidget] is created.
///
/// Enable: `flutter pub add flutter_unity_widget`, export Unity, then set [useUnity] = true
/// and uncomment [RaidMapUnityNative.embed].
abstract final class UnityBoardBridge {
  static const bool useUnity = false;

  static bool get isAvailable => useUnity && !kIsWeb;

  static UnityPostMessage? _postMessage;
  static UnityBoardMessageHandler? onUnityMessage;

  static void attachPostMessage(UnityPostMessage postMessage) {
    _postMessage = postMessage;
  }

  static void detachController() {
    _postMessage = null;
  }

  static void handleUnityMessage(dynamic raw) {
    final text = raw is String ? raw : raw.toString();
    final pipe = text.indexOf('|');
    final event = pipe < 0 ? text : text.substring(0, pipe);
    final body = pipe < 0 ? '{}' : text.substring(pipe + 1);
    try {
      final map = jsonDecode(body) as Map<String, dynamic>;
      onUnityMessage?.call(event, map);
    } catch (_) {
      onUnityMessage?.call(event, const {});
    }
  }

  static void _send(String method, [Map<String, dynamic>? payload]) {
    if (!isAvailable || _postMessage == null) return;
    _postMessage!('RaidMapController', method, jsonEncode(payload ?? {}));
  }

  static Future<void> loadVenue(RaidMapVenueProfile venue) async {
    _send('loadVenue', {
      'venueId': venue.id.name,
      'teams': venue.teams.map((t) => {'id': t.id, 'name': t.name, 'emoji': t.emoji}).toList(),
      'charter': venue.vaultCharter,
    });
  }

  static Future<void> setScores(Map<String, int> scores) async {
    _send('setScores', {'scores': scores.values.toList()});
  }

  static Future<void> spinCompass() async => _send('spinCompass');

  static Future<void> drawModeCard(RaidModeDeckCard card) async {
    _send('drawModeCard', {'band': card.band.name, 'title': card.title, 'rule': card.rule});
  }

  static Future<void> playCrownCeremony(String teamName) async {
    _send('crownWin', {'teamName': teamName});
  }

  static Future<void> setPhase(String phase) async => _send('setPhase', {'phase': phase});
}
