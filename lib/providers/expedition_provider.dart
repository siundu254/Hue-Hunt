import 'package:flutter/foundation.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/l10n/app_localizations.dart';
import 'package:hue_hunt/models/chaos_twist.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/models/spirit_mood.dart';
import 'package:hue_hunt/models/venue_archetype.dart';
import 'package:hue_hunt/l10n/spirit_l10n.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/services/expedition_room_service.dart';
import 'package:hue_hunt/models/chapter_award.dart';
import 'package:hue_hunt/models/raid_session_stats.dart';
import 'package:hue_hunt/models/secret_objective.dart';
import 'package:hue_hunt/services/raid_engine_service.dart';
import 'package:hue_hunt/services/spirit_forge_service.dart';
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
  bool _gameShowReveals = false;
  bool _awaitingGameShowReveal = false;
  VenueArchetype? _forgeVenue;
  ExpeditionFormat? _forgeFormat;
  bool _roomHosting = false;
  ChaosTwist? _activeChaos;
  bool _chaosTriggered = false;
  String? _spiritCustomLine;
  SpiritMessageKind _spiritKind = SpiritMessageKind.profileIntro;
  String? _spiritTeamName;
  SpiritMood _spiritMood = SpiritMood.neutral;
  int _effectiveMissionSeconds = 60;
  final RaidSessionStats _raidStats = RaidSessionStats();
  List<SecretObjective> _secretObjectives = [];
  List<ChapterAward> _chapterAwards = [];
  bool _suddenDeathActive = false;
  int _suddenDeathSeconds = 45;
  bool _doublePointsActive = false;
  int _clueStageIndex = 0;
  int _missionSecondsAtStart = 60;
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
  bool get gameShowReveals => _gameShowReveals;
  bool get awaitingGameShowReveal => _awaitingGameShowReveal;
  VenueArchetype? get forgeVenue => _forgeVenue;
  ExpeditionFormat? get forgeFormat => _forgeFormat;
  bool get roomHosting => _roomHosting;
  ChaosTwist? get activeChaos => _activeChaos;
  bool get isSpiritForge =>
      _playSource == PlaySource.spiritForge || _forgeFormat != null;
  SpiritMessageKind get spiritKind => _spiritKind;
  String? get spiritTeamName => _spiritTeamName;
  SpiritMood get spiritMood => _spiritMood;
  int get effectiveMissionSeconds =>
      _suddenDeathActive ? _suddenDeathSeconds : _effectiveMissionSeconds;
  bool get suddenDeathActive => _suddenDeathActive;
  bool get doublePointsActive => _doublePointsActive;
  int get clueStageIndex => _clueStageIndex;
  List<SecretObjective> get secretObjectives => List.unmodifiable(_secretObjectives);
  List<ChapterAward> get chapterAwards => List.unmodifiable(_chapterAwards);
  RaidSessionStats get raidStats => _raidStats;

  SecretObjective? secretObjectiveForPlayer(int playerIndex) {
    if (playerIndex < 0 || playerIndex >= _secretObjectives.length) return null;
    return _secretObjectives[playerIndex];
  }

  SpiritL10n get spiritLine => SpiritL10n(
        kind: _spiritKind,
        missionNumber: _missionIndex + 1,
        teamName: _spiritTeamName,
        mode: _profile?.mode,
      );

  String resolveSpiritText(AppLocalizations l) =>
      _spiritCustomLine ?? spiritLine.resolve(l);
  Set<String> get stickers => Set.unmodifiable(_stickers);
  Set<String> get mapNodes => Set.unmodifiable(_mapNodes);
  bool get usesTeams => _teams.length >= 2;
  bool get needsPassDevice =>
      _profile?.useGroupConfirm == true ||
      _playSource == PlaySource.huntHueBox ||
      _forgeFormat == ExpeditionFormat.huntHueBox;

  void syncRoomIfHosting() {
    if (!_roomHosting || _forgeFormat == null) return;
    ExpeditionRoomService.instance.publish(this, format: _forgeFormat!);
  }

  void setRoomHosting(bool hosting) {
    _roomHosting = hosting;
    notifyListeners();
  }

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

  Future<void> configureForgeSession({
    required VenueArchetype venue,
    required SessionMode mode,
    required int playerCount,
    int teamCount = 2,
    List<String>? teamNames,
    String? roomNickname,
    int? missionSecondsOverride,
    bool gameShowReveals = true,
    ExpeditionFormat format = ExpeditionFormat.digitalForge,
    bool openRoom = false,
  }) async {
    _profile = ModeProfile.forMode(mode);
    await _recordLastMode(mode);
    _playerCount = playerCount.clamp(1, 12);
    _forgeVenue = venue;
    _forgeFormat = format;
    _roomHosting = openRoom;
    _gameShowReveals = gameShowReveals;
    _chaosTriggered = false;
    _activeChaos = null;
    _effectiveMissionSeconds =
        missionSecondsOverride ?? _profile!.missionSeconds;
    _cameraEnabled = false;

    if (format == ExpeditionFormat.huntHueBox) {
      final box = await _missions.boxChapter(count: _profile!.chapterLength);
      _chapter = SpiritForgeService.forgeFromBoxDeck(
        box,
        count: _profile!.chapterLength,
      );
      _playSource = PlaySource.huntHueBox;
    } else {
      _chapter = SpiritForgeService.forge(
        venue: venue,
        roomNickname: roomNickname,
        count: _profile!.chapterLength,
      );
      _playSource = PlaySource.spiritForge;
    }

    _chapter = RaidEngineService.prepareChapter(_chapter);
    _initRaidSession();

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
    _spiritKind = SpiritMessageKind.profileIntro;
    _spiritCustomLine = SpiritForgeService.forgeNarration(
      venue,
      roomNickname: roomNickname,
      box: format == ExpeditionFormat.huntHueBox,
    );
    _spiritTeamName = null;
    _spiritMood = SpiritMood.celebrating;
    _awaitingGameShowReveal = false;
    notifyListeners();
    syncRoomIfHosting();
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
    _forgeVenue = null;
    _forgeFormat = null;
    _roomHosting = false;
    _gameShowReveals = false;
    _chaosTriggered = false;
    _activeChaos = null;
    _spiritCustomLine = null;
    _awaitingGameShowReveal = false;
    _effectiveMissionSeconds =
        missionSecondsOverride ?? _profile!.missionSeconds;
    _cameraEnabled = cameraEnabled ?? _profile!.cameraDefault;
    if (!_profile!.cameraAllowed) _cameraEnabled = false;

    _chapter = playSource == PlaySource.huntHueBox
        ? await _missions.boxChapter(count: _profile!.chapterLength)
        : playSource == PlaySource.bonusChapter
            ? await _missions.bonusChapter(count: _profile!.chapterLength)
            : await _missions.chapterFor(mode);

    _chapter = RaidEngineService.prepareChapter(_chapter);
    _initRaidSession();

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
        : playSource == PlaySource.bonusChapter
            ? SpiritMessageKind.mapUnlock
            : SpiritMessageKind.profileIntro;
    _spiritTeamName = null;
    _spiritMood = SpiritMood.excited;
    notifyListeners();
  }

  void startChapter() {
    _spiritCustomLine = null;
    _goToMissionIntro();
  }

  void _goToMissionIntro() {
    _phase = SessionPhase.missionIntro;
    _spiritMood = SpiritMood.excited;
    _spiritTeamName =
        _teams.isNotEmpty ? _teams[_activeTeamIndex].name : null;
    _clueStageIndex = 0;
    _missionSecondsAtStart = effectiveMissionSeconds;
    _suddenDeathActive = false;
    _doublePointsActive = false;

    if (_missionIndex == 1 && !_chaosTriggered) {
      _activeChaos = ChaosTwist.random();
      _chaosTriggered = true;
      _spiritCustomLine = _activeChaos!.spiritLine;
      _spiritKind = SpiritMessageKind.missionReady;
      if (_activeChaos!.forcesSuddenDeath) {
        _suddenDeathActive = true;
        _suddenDeathSeconds = _activeChaos!.suddenDeathSeconds;
      }
    } else if (RaidEngineService.rollSuddenDeath(_missionIndex)) {
      _suddenDeathActive = true;
      _suddenDeathSeconds = 45;
      _spiritCustomLine =
          'Sudden death! All teams have $_suddenDeathSeconds seconds — go!';
      _spiritKind = SpiritMessageKind.missionReady;
    } else {
      _spiritCustomLine = null;
      _spiritKind = SpiritMessageKind.missionReady;
    }

    if (_activeChaos?.title == 'DOUBLE POINTS') {
      _doublePointsActive = true;
    }

    if (_gameShowReveals) _awaitingGameShowReveal = true;
    notifyListeners();
  }

  void completeGameShowReveal() {
    _awaitingGameShowReveal = false;
    if (_activeChaos != null && _missionIndex == 1) {
      _spiritCustomLine = null;
    }
    beginMissionPlay();
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

  void completeMission({
    required int meterGain,
    required bool success,
    int? teamIndex,
    int? secondsElapsed,
  }) {
    final mission = currentMission;
    var gain = mission?.isDecoy == true && success ? 0 : meterGain;
    if (success && _doublePointsActive) gain *= 2;

    if (success && mission != null) {
      _raidStats.recordMissionWin(
        playerIndex: _passPlayerIndex,
        secondsUsed: secondsElapsed ?? _missionSecondsAtStart,
        duringChaos: _activeChaos != null,
        wasDecoy: mission.isDecoy,
      );
      if (mission.type == MissionType.echo) {
        _raidStats.recordEcho(playerIndex: _passPlayerIndex, stars: gain ~/ 10);
      }
    }

    if (success && _roomHosting) {
      gain += ExpeditionRoomService.instance.spectatorBonus();
      ExpeditionRoomService.instance.clearVotesForMission();
    }
    if (success) {
      _streak++;
      _chromaMeter = (_chromaMeter + gain).clamp(0, 100);
      _sessionScore += gain * 10;
      if (teamIndex != null && teamIndex < _teams.length) {
        _teams[teamIndex].score += gain;
      } else if (_teams.isNotEmpty) {
        _teams[_activeTeamIndex].score += gain;
      }
      _spiritMood = gain >= 25 ? SpiritMood.celebrating : SpiritMood.excited;
      _spiritKind =
          gain >= 25 ? SpiritMessageKind.huntGreat : SpiritMessageKind.huntGood;
    } else {
      _streak = 0;
      _spiritMood = SpiritMood.rematch;
      _spiritKind = SpiritMessageKind.rematch;
    }
    _phase = SessionPhase.meterSync;
    notifyListeners();
    syncRoomIfHosting();
  }

  void advanceAfterMeter() {
    _phase = SessionPhase.spiritReaction;
    _spiritMood = _chromaMeter >= 70 ? SpiritMood.celebrating : SpiritMood.neutral;
    _spiritKind = _chromaMeter >= 70
        ? SpiritMessageKind.mapUnlock
        : SpiritMessageKind.mapProgress;
    notifyListeners();
    syncRoomIfHosting();
  }

  void advanceAfterSpirit() {
    _mapNodes.add('node_${_profile!.mode.name}_${_missionIndex + 1}');
    _missionIndex++;
    _passPlayerIndex = (_passPlayerIndex + 1) % _playerCount;
    _activeTeamIndex = (_activeTeamIndex + 1) % _teams.length;

    if (_missionIndex >= _chapter.length) {
      _phase = SessionPhase.chapterComplete;
      _chapterAwards = RaidEngineService.computeAwards(
        stats: _raidStats,
        playerCount: _playerCount,
        teamNames: _teams.map((t) => t.name).toList(),
        secretObjectivesCompleted: _raidStats.secretObjectivesCompleted,
      );
      _stickers.add(_profile!.mode.name);
      if (_playSource == PlaySource.huntHueBox) _stickers.add('hunt_hue_box');
      if (_playSource == PlaySource.spiritForge) _stickers.add('spirit_forge');
      _persist();
    } else {
      _goToMissionIntro();
    }
    notifyListeners();
    syncRoomIfHosting();
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

  void advanceClueStage() {
    final mission = currentMission;
    if (mission == null || !mission.hasClueChain) return;
    if (_clueStageIndex < mission.clueStages.length - 1) {
      _clueStageIndex++;
      notifyListeners();
    }
  }

  void completeSecretObjective(int playerIndex) {
    if (playerIndex < 0 || playerIndex >= _secretObjectives.length) return;
    if (_secretObjectives[playerIndex].completed) return;
    _secretObjectives[playerIndex] =
        _secretObjectives[playerIndex].copyWith(completed: true);
    _raidStats.secretObjectivesCompleted++;
    _sessionScore += 50;
    notifyListeners();
  }

  void _initRaidSession() {
    _raidStats
      ..fastestMissionSeconds = 999
      ..fastestMissionPlayer = 0
      ..bestEchoStars = 0
      ..bestEchoPlayer = 0
      ..chaosMissionsWon = 0
      ..decoysTriggered = 0
      ..secretObjectivesCompleted = 0
      ..playerMissionWins.clear()
      ..missionSecondsUsed.clear();
    _secretObjectives = RaidEngineService.assignSecretObjectives(_playerCount);
    _chapterAwards = [];
    _suddenDeathActive = false;
    _doublePointsActive = false;
    _clueStageIndex = 0;
  }

  void resetToHome() {
    _profile = null;
    _chapter = [];
    _teams = [];
    _phase = SessionPhase.briefing;
    _missionIndex = 0;
    _forgeVenue = null;
    _activeChaos = null;
    _chaosTriggered = false;
    _spiritCustomLine = null;
    _forgeFormat = null;
    _roomHosting = false;
    _secretObjectives = [];
    _chapterAwards = [];
    _suddenDeathActive = false;
    notifyListeners();
  }
}
