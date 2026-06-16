import 'package:flutter/material.dart';
import 'package:hue_hunt/models/game_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh'),
  ];

  Locale? _locale;
  bool _soundEffects = true;
  bool _haptics = true;
  bool _spiritHints = true;
  bool _passDeviceReminders = true;
  bool _defaultCameraBonus = false;
  bool _defaultOpenRoom = true;
  bool _defaultGameShowReveals = true;
  MissionTimerPreset _timerPreset = MissionTimerPreset.standard;

  Locale? get locale => _locale;
  bool get soundEffects => _soundEffects;
  bool get haptics => _haptics;
  bool get spiritHints => _spiritHints;
  bool get passDeviceReminders => _passDeviceReminders;
  bool get defaultCameraBonus => _defaultCameraBonus;
  bool get defaultOpenRoom => _defaultOpenRoom;
  bool get defaultGameShowReveals => _defaultGameShowReveals;
  MissionTimerPreset get timerPreset => _timerPreset;

  bool get useSystemLocale => _locale == null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale_code');
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    } else {
      _locale = null;
    }
    _soundEffects = prefs.getBool('sound_effects') ?? true;
    _haptics = prefs.getBool('haptics') ?? true;
    _spiritHints = prefs.getBool('spirit_hints') ?? true;
    _passDeviceReminders = prefs.getBool('pass_device_reminders') ?? true;
    _defaultCameraBonus = prefs.getBool('default_camera_bonus') ?? false;
    _defaultOpenRoom = prefs.getBool('default_open_room') ?? true;
    _defaultGameShowReveals = prefs.getBool('default_game_show_reveals') ?? true;
    final timerIndex = prefs.getInt('timer_preset') ?? 1;
    _timerPreset = MissionTimerPreset.values[timerIndex.clamp(0, 2)];
    notifyListeners();
  }

  int effectiveMissionSeconds(int baseSeconds) {
    return (baseSeconds * _timerPreset.multiplier).round().clamp(20, 180);
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove('locale_code');
    } else {
      await prefs.setString('locale_code', locale.languageCode);
    }
    notifyListeners();
  }

  Future<void> setSoundEffects(bool value) async {
    _soundEffects = value;
    await _saveBool('sound_effects', value);
  }

  Future<void> setHaptics(bool value) async {
    _haptics = value;
    await _saveBool('haptics', value);
  }

  Future<void> setSpiritHints(bool value) async {
    _spiritHints = value;
    await _saveBool('spirit_hints', value);
  }

  Future<void> setPassDeviceReminders(bool value) async {
    _passDeviceReminders = value;
    await _saveBool('pass_device_reminders', value);
  }

  Future<void> setDefaultCameraBonus(bool value) async {
    _defaultCameraBonus = value;
    await _saveBool('default_camera_bonus', value);
  }

  Future<void> setDefaultGameShowReveals(bool value) async {
    _defaultGameShowReveals = value;
    await _saveBool('default_game_show_reveals', value);
  }

  Future<void> setDefaultOpenRoom(bool value) async {
    _defaultOpenRoom = value;
    await _saveBool('default_open_room', value);
  }

  Future<void> setTimerPreset(MissionTimerPreset preset) async {
    _timerPreset = preset;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timer_preset', preset.index);
    notifyListeners();
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    notifyListeners();
  }
}
