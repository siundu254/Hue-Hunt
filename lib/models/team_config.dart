class TeamConfig {
  TeamConfig({required this.name, this.score = 0});

  final String name;
  int score;

  TeamConfig copyWith({String? name, int? score}) => TeamConfig(
        name: name ?? this.name,
        score: score ?? this.score,
      );
}

List<TeamConfig> defaultTeams(int count) {
  const names = ['Aurora', 'Ember', 'Tide', 'Fern'];
  return List.generate(
    count.clamp(2, 4),
    (i) => TeamConfig(name: names[i]),
  );
}
