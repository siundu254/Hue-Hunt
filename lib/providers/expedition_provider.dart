import 'package:flutter/foundation.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/models/spirit_mood.dart';
import 'package:hue_hunt/l10n/spirit_l10n.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpeditionProvider extends ChangeNotifier {
  ExpeditionProvider(this._missions);

  final MissionRepository _missions;

  ModeProfile? _profile;
  List<MissionDefinition> _chapter = [];
  SessionPhase _phase = SessionPhase.briefing;
  PlaySource _playSource = PlaySource.digital;
  int _missionIndex = 0;
  int _chromaMeter = 0;
  int _sessionScore = 0;
  int _bestScore = 0;
  int _streak = 0;
  int _playerCount = 2;
  int _relayPlayer = 0;
  int _passPlayerIndex = 0;
  int _teamAWins = 0;
  int _teamBWins = 0;
  List<TeamConfig> _teams = [];
  int _activeTeamIndex = 0;
  bool _cameraEnabled = false;
  SpiritMessageKind _spiritKind = SpiritMessageKind.profileIntro;
  String? _spiritTeamName;
  SpiritMood _spiritMood = SpiritMood.neutral;
  int _effectiveMissionSeconds = 60;
  final Set<String> _stickers = {};
  final Set<String> _mapNodes = {};
  bool _onboardingComplete = false;
  SessionMode _lastMode = SessionMode.family;

  ModeProfile? get profile => _profile;
  bool get onboardingComplete => _onboardingComplete;
  SessionMode get lastMode => _lastMode;
  PlaySource get playSource => _playSource;
  List<MissionDefinition> get chapter => _chapter;
  SessionPhase get phase => _phase;
  int get missionIndex => _missionIndex;
  MissionDefinition? get currentMission =>
      _chapter.isEmpty || _missionIndex >= _chapter.length ? null : _chapter[_missionIndex];
  int get chromaMeter => _chromaMeter;
  int get sessionScore => _sessionScore;
  int get bestScore => _bestScore;
  int get streak => _streak;
  int get playerCount => _playerCount;
  int get relayPlayer => _relayPlayer;
  int get passPlayerIndex => _passPlayerIndex;
  int get teamAWins => _teamAWins;
  int get teamBWins => _teamBWins;
  List<TeamConfig> get teams => List.unmodifiable(_teams);
  int get activeTeamIndex => _activeTeamIndex;
  TeamConfig? get activeTeam => _teams.isEmpty ? null : _teams[_activeTeamIndex];
  bool get cameraEnabled => _cameraEnabled;
  SpiritMessageKind get spiritKind => _spiritKind;
  String? get spiritTeamName => _spiritTeamName;
  SpiritMood get spiritMood => _spiritMood;
  int get effectiveMissionSeconds => _effectiveMissionSeconds;

  SpiritL10n get spiritLine => SpiritL10n(
        kind: _spiritKind,
        missionNumber: _missionIndex + 1,
        teamName: _spiritTeamName,
        mode: _profile?.mode,
      );
  Set<String> get stickers => Set.unmodifiable(_stickers);
  Set<String> get mapNodes => Set.unmodifiable(_mapNodes);
  bool get usesTeams => _teams.length >= 2;
  bool get needsPassDevice =>
      _profile?.useGroupConfirm == true || _playSource == PlaySource.huntHueBox;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _stickers
      ..clear()
      ..addAll(prefs.getStringList('journal_stickers') ?? []);
    _mapNodes
      ..clear()
      ..addAll(prefs.getStringList('map_nodes') ?? []);
    _bestScore = prefs.getInt('best_score') ?? 0;
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    final last = prefs.getString('last_mode');
    if (last != null) {
      _lastMode = SessionMode.values.firstWhere(
        (m) => m.name == last,
        orElse: () => SessionMode.family,
      );
    }
    notifyListeners();
  }

  Future<void> clearOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
    _onboardingComplete = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> _recordLastMode(SessionMode mode) async {
    _lastMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_mode', mode.name);
  }

  Future<void> configureSession({
    required SessionMode mode,
    required int playerCount,
    int teamCount = 2,
    bool? cameraEnabled,
    PlaySource playSource = PlaySource.digital,
    List<String>? teamNames,
    int? missionSecondsOverride,
  }) async {
    _profile = ModeProfile.forMode(mode);
    await _recordLastMode(mode);
    _playerCount = playerCount.clamp(1, 12);
    _playSource = playSource;
    _effectiveMissionSeconds =
        missionSecondsOverride ?? _profile!.missionSeconds;
    _cameraEnabled = cameraEnabled ?? _profile!.cameraDefault;
    if (!_profile!.cameraAllowed) _cameraEnabled = false;

    _chapter = playSource == PlaySource.huntHueBox
        ? await _missions.boxChapter(count: _profile!.chapterLength)
        : await _missions.chapterFor(mode);

    _teams = List.generate(
      teamCount.clamp(2, 4),
      (i) => TeamConfig(
        name: teamNames != null && i < teamNames.length
            ? teamNames[i]
            : defaultTeams(teamCount)[i].name,
      ),
    );

    _missionIndex = 0;
    _chromaMeter = 0;
    _sessionScore = 0;
    _streak = 0;
    _relayPlayer = 0;
    _passPlayerIndex = 0;
    _activeTeamIndex = 0;
    _teamAWins = 0;
    _teamBWins = 0;
    _phase = SessionPhase.briefing;
    _spiritKind = playSource == PlaySource.huntHueBox
        ? SpiritMessageKind.boxIntro
        : SpiritMessageKind.profileIntro;
    _spiritTeamName = null;
    _spiritMood = SpiritMood.excited;
    notifyListeners();
  }

  void startChapter() {
    _goToMissionIntro();
  }

  void _goToMissionIntro() {
    _phase = SessionPhase.missionIntro;
    _spiritMood = SpiritMood.excited;
    _spiritKind = SpiritMessageKind.missionReady;
    _spiritTeamName =
        _teams.isNotEmpty ? _teams[_activeTeamIndex].name : null;
    notifyListeners();
  }

  void acknowledgePassDevice() {
    _phase = SessionPhase.missionPlay;
    notifyListeners();
  }

  void beginMissionPlay() {
    if (needsPassDevice) {
      _phase = SessionPhase.passDevice;
    } else {
      _phase = SessionPhase.missionPlay;
    }
    notifyListeners();
  }

  void completeMission({required int meterGain, required bool success, int? teamIndex}) {
    if (success) {
      _streak++;
      _chromaMeter = (_chromaMeter + meterGain).clamp(0, 100);
      _sessionScore += meterGain * 10;
      if (teamIndex != null && teamIndex < _teams.length) {
        _teams[teamIndex].score += meterGain;
      } else if (_teams.isNotEmpty) {
        _teams[_activeTeamIndex].score += meterGain;
      }
      _spiritMood = meterGain >= 25 ? SpiritMood.celebrating : SpiritMood.excited;
      _spiritKind =
          meterGain >= 25 ? SpiritMessageKind.huntGreat : SpiritMessageKind.huntGood;
    } else {
      _streak = 0;
      _spiritMood = SpiritMood.rematch;
      _spiritKind = SpiritMessageKind.rematch;
    }
    _phase = SessionPhase.meterSync;
    notifyListeners();
  }

  void advanceAfterMeter() {
    _phase = SessionPhase.spiritReaction;
    _spiritMood = _chromaMeter >= 70 ? SpiritMood.celebrating : SpiritMood.neutral;
    _spiritKind = _chromaMeter >= 70
        ? SpiritMessageKind.mapUnlock
        : SpiritMessageKind.mapProgress;
    notifyListeners();
  }

  void advanceAfterSpirit() {
    _mapNodes.add('node_${_profile!.mode.name}_${_missionIndex + 1}');
    _missionIndex++;
    _passPlayerIndex = (_passPlayerIndex + 1) % _playerCount;
    _activeTeamIndex = (_activeTeamIndex + 1) % _teams.length;

    if (_missionIndex >= _chapter.length) {
      _phase = SessionPhase.chapterComplete;
      _stickers.add(_profile!.mode.name);
      if (_playSource == PlaySource.huntHueBox) _stickers.add('hunt_hue_box');
      _persist();
    } else {
      _goToMissionIntro();
    }
    notifyListeners();
  }

  void nextRelayPlayer() {
    _relayPlayer = (_relayPlayer + 1) % _playerCount;
    notifyListeners();
  }

  void recordDuelWin({required bool teamA}) {
    if (teamA) {
      _teamAWins++;
      if (_teams.isNotEmpty) _teams[0].score += 15;
    } else {
      _teamBWins++;
      if (_teams.length > 1) _teams[1].score += 15;
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('journal_stickers', _stickers.toList());
    await prefs.setStringList('map_nodes', _mapNodes.toList());
    final best = prefs.getInt('best_score') ?? 0;
    if (_sessionScore > best) {
      _bestScore = _sessionScore;
      await prefs.setInt('best_score', _bestScore);
    }
  }

  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _stickers.clear();
    _mapNodes.clear();
    _bestScore = 0;
    _onboardingComplete = false;
    await prefs.remove('journal_stickers');
    await prefs.remove('map_nodes');
    await prefs.remove('best_score');
    await prefs.remove('onboarding_complete');
    notifyListeners();
  }

  void resetToHome() {
    _profile = null;
    _chapter = [];
    _teams = [];
    _phase = SessionPhase.briefing;
    _missionIndex = 0;
    notifyListeners();
  }
}
