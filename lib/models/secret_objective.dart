/// Hidden per-player bonus mission — never shown to the whole team.
class SecretObjective {
  const SecretObjective({
    required this.playerIndex,
    required this.prompt,
    this.completed = false,
  });

  final int playerIndex;
  final String prompt;
  final bool completed;

  SecretObjective copyWith({bool? completed}) => SecretObjective(
        playerIndex: playerIndex,
        prompt: prompt,
        completed: completed ?? this.completed,
      );
}
