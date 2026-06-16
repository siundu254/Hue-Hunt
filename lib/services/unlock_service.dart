import 'package:shared_preferences/shared_preferences.dart';

/// QR / deep-link unlock state (v1.5).
class UnlockService {
  static const bonusChapterKey = 'bonus_chapter_unlocked';
  static const boxQrPrefix = 'huehunt://unlock/bonus';
  static const altPrefix = 'novalumina://hue-hunt/bonus';

  static Future<bool> isBonusChapterUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(bonusChapterKey) ?? false;
  }

  static Future<bool> tryUnlockFromPayload(String raw) async {
    final normalized = raw.trim().toLowerCase();
    final valid = normalized.contains('bonus') ||
        normalized == boxQrPrefix ||
        normalized.startsWith(altPrefix);
    if (!valid) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(bonusChapterKey, true);
    return true;
  }

  static Future<void> unlockBonusForDemo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(bonusChapterKey, true);
  }
}
