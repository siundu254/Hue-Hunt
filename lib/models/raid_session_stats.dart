/// Tracks stats for end-game awards and highlight cards.
class RaidSessionStats {
  int fastestMissionSeconds = 999;
  int fastestMissionPlayer = 0;
  final Map<int, int> playerMissionWins = {};
  int bestEchoStars = 0;
  int bestEchoPlayer = 0;
  int chaosMissionsWon = 0;
  int decoysTriggered = 0;
  int secretObjectivesCompleted = 0;
  final Map<int, int> missionSecondsUsed = {};

  void recordMissionWin({
    required int playerIndex,
    required int secondsUsed,
    required bool duringChaos,
    required bool wasDecoy,
  }) {
    playerMissionWins[playerIndex] = (playerMissionWins[playerIndex] ?? 0) + 1;
    missionSecondsUsed[playerIndex] =
        (missionSecondsUsed[playerIndex] ?? 0) + secondsUsed;
    if (secondsUsed < fastestMissionSeconds) {
      fastestMissionSeconds = secondsUsed;
      fastestMissionPlayer = playerIndex;
    }
    if (duringChaos) chaosMissionsWon++;
    if (wasDecoy) decoysTriggered++;
  }

  void recordEcho({required int playerIndex, required int stars}) {
    if (stars > bestEchoStars) {
      bestEchoStars = stars;
      bestEchoPlayer = playerIndex;
    }
  }
}
