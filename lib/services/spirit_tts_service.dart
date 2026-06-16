import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hue_hunt/models/session_mode.dart';

/// On-device Hue Spirit voice (v1.5).
class SpiritTtsService {
  SpiritTtsService._();
  static final SpiritTtsService instance = SpiritTtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  String? _lastSpoken;

  Future<void> init() async {
    if (_ready) return;
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);
    _ready = true;
  }

  Future<void> speak(
    String text, {
    SessionMode? mode,
    bool enabled = true,
  }) async {
    if (!enabled || text.trim().isEmpty) return;
    if (text == _lastSpoken) return;
    _lastSpoken = text;
    try {
      await init();
      await _applyTone(mode);
      await _tts.stop();
      await _tts.speak(text);
    } catch (e, st) {
      debugPrint('[SpiritTts] speak failed: $e\n$st');
    }
  }

  Future<void> stop() async {
    _lastSpoken = null;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> _applyTone(SessionMode? mode) async {
    final pitch = switch (mode) {
      SessionMode.party => 1.15,
      SessionMode.team => 0.95,
      SessionMode.kids => 1.2,
      SessionMode.friends => 1.08,
      _ => 1.0,
    };
    final rate = switch (mode) {
      SessionMode.party => 0.52,
      SessionMode.team => 0.44,
      _ => 0.48,
    };
    await _tts.setPitch(pitch);
    await _tts.setSpeechRate(rate);
  }
}
