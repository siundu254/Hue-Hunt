import 'package:flutter/services.dart';
import 'package:hue_hunt/services/spirit_tts_service.dart';

/// Crown ceremony + board event feedback (haptics + voice).
abstract final class RaidFeedbackService {
  static Future<void> playCrownWin({
    required String teamName,
    bool soundEnabled = true,
    bool hapticsEnabled = true,
  }) async {
    if (hapticsEnabled) {
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.heavyImpact();
    }
    await SpiritTtsService.instance.speak(
      'Who Raided? $teamName Raided!',
      enabled: soundEnabled,
    );
  }

  static Future<void> playChaosSpin({bool hapticsEnabled = true}) async {
    if (hapticsEnabled) await HapticFeedback.lightImpact();
  }

  static Future<void> playModeDraw({bool hapticsEnabled = true}) async {
    if (hapticsEnabled) await HapticFeedback.selectionClick();
  }
}
