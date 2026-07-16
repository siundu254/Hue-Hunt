import 'dart:math';
import 'package:hue_hunt/models/chapter_award.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/raid_session_stats.dart';
import 'package:hue_hunt/models/secret_objective.dart';

/// Room Raiders mechanics: secret objectives, decoys, clue chains, sudden death.
class RaidEngineService {
  static final _rng = Random();

  static const _secretPool = [
    'Touch 3 bumpy objects without telling your team',
    'Find something with a handle before the next mission ends',
    'Whisper one clue to a teammate during the next hunt',
    'High-five a teammate before your team confirms the next find',
    'Collect 2 soft objects without anyone noticing',
    'Point at 3 different textures in the room in secret',
    'Swap seats with someone before the chapter ends',
  ];

  static const _decoyPool = [
    (
      name: 'TOP SECRET Stapler',
      prompt: 'Find a stapler marked TOP SECRET',
      clue: 'Decoy mission — worth 0 points. Good luck, Raiders!',
      picture: '📎',
    ),
    (
      name: 'Legendary Left Sock',
      prompt: 'Find the legendary left sock',
      clue: 'Fake mission! Laugh, then hunt the real prompt next round.',
      picture: '🧦',
    ),
    (
      name: 'Invisible Trophy',
      prompt: 'Find the invisible trophy on the shelf',
      clue: 'Spirit prank — zero points if you fall for it.',
      picture: '🏆',
    ),
    (
      name: 'Golden Paperclip',
      prompt: 'Find a golden paperclip of destiny',
      clue: 'Decoy! Your team earns nothing — but the room will remember.',
      picture: '📎',
    ),
  ];

  static const _clueChains = [
    ['Find a book in the room', 'Open it — note the first word you see', 'Find an object that matches that word'],
    ['Find something that makes sound', 'Tap it twice', 'Find something quieter nearby'],
    ['Find something round', 'Roll it gently', 'Find something square within arm\'s reach'],
    ['Find something from a drawer', 'Read any text on it', 'Find a second object with similar text'],
  ];

  static List<SecretObjective> assignSecretObjectives(int playerCount) {
    final pool = List<String>.from(_secretPool)..shuffle(_rng);
    return List.generate(
      playerCount.clamp(1, 8),
      (i) => SecretObjective(
        playerIndex: i,
        prompt: pool[i % pool.length],
      ),
    );
  }

  /// Injects one decoy and enriches ~1 hunt with a multi-stage clue chain.
  static List<MissionDefinition> prepareChapter(List<MissionDefinition> source) {
    final chapter = List<MissionDefinition>.from(source);
    if (chapter.isEmpty) return chapter;

    final decoy = _decoyPool[_rng.nextInt(_decoyPool.length)];
    final insertAt = _rng.nextInt(chapter.length);
    chapter.insert(
      insertAt,
      MissionDefinition(
        type: MissionType.hunt,
        hueName: decoy.name,
        hex: '#888888',
        clue: decoy.clue,
        picture: decoy.picture,
        objectPrompt: decoy.prompt,
        isDecoy: true,
      ),
    );

    final huntIndices = <int>[];
    for (var i = 0; i < chapter.length; i++) {
      if (chapter[i].type == MissionType.hunt && !chapter[i].isDecoy) {
        huntIndices.add(i);
      }
    }
    if (huntIndices.isNotEmpty) {
      final chain = _clueChains[_rng.nextInt(_clueChains.length)];
      final target = huntIndices[_rng.nextInt(huntIndices.length)];
      final m = chapter[target];
      chapter[target] = MissionDefinition(
        type: m.type,
        hueName: m.hueName,
        hex: m.hex,
        clue: m.clue,
        picture: m.picture,
        huntCategory: m.huntCategory,
        objectPrompt: chain.first,
        funFact: m.funFact,
        boxCardId: m.boxCardId,
        clueStages: chain,
      );
    }

    return chapter;
  }

  /// ~35% chance per mission (after first) to force a sudden-death countdown.
  static bool rollSuddenDeath(int missionIndex) =>
      missionIndex > 0 && _rng.nextDouble() < 0.35;

  static List<ChapterAward> computeAwards({
    required RaidSessionStats stats,
    required int playerCount,
    required List<String> teamNames,
    required int secretObjectivesCompleted,
  }) {
    final awards = <ChapterAward>[];

    if (stats.playerMissionWins.isNotEmpty) {
      final top = stats.playerMissionWins.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );
      awards.add(ChapterAward(
        title: 'Explorer',
        emoji: '🔍',
        recipient: 'Player ${top.key + 1}',
        reason: '${top.value} mission wins',
      ));
    }

    if (stats.fastestMissionSeconds < 999) {
      awards.add(ChapterAward(
        title: 'Speed Demon',
        emoji: '⚡',
        recipient: 'Player ${stats.fastestMissionPlayer + 1}',
        reason: 'Fastest find in ${stats.fastestMissionSeconds}s',
      ));
    }

    if (stats.bestEchoStars >= 2) {
      awards.add(ChapterAward(
        title: 'Clue Master',
        emoji: '🧩',
        recipient: 'Player ${stats.bestEchoPlayer + 1}',
        reason: 'Echo guessed ${'★' * stats.bestEchoStars}',
      ));
    }

    if (stats.chaosMissionsWon > 0) {
      awards.add(ChapterAward(
        title: 'Chaos Champion',
        emoji: '🌪️',
        recipient: teamNames.isNotEmpty ? teamNames.first : 'The room',
        reason: 'Won ${stats.chaosMissionsWon} mission(s) during chaos',
      ));
    }

    if (secretObjectivesCompleted > 0) {
      awards.add(ChapterAward(
        title: 'Sneak Raider',
        emoji: '🕵️',
        recipient: '$secretObjectivesCompleted player(s)',
        reason: 'Completed secret objectives',
      ));
    }

    if (stats.decoysTriggered > 0) {
      awards.add(ChapterAward(
        title: 'Prank Survivor',
        emoji: '😂',
        recipient: 'Everyone',
        reason: 'Survived ${stats.decoysTriggered} decoy mission(s)',
      ));
    }

    if (teamNames.length >= 2) {
      awards.add(ChapterAward(
        title: 'Raid Squad',
        emoji: '🏅',
        recipient: teamNames.join(' · '),
        reason: 'Finished the chapter together',
      ));
    }

    return awards;
  }
}
