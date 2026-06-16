/// How this expedition is played — one JSON pipeline, two surfaces.
enum ExpeditionFormat {
  digitalForge,
  huntHueBox,
}

extension ExpeditionFormatX on ExpeditionFormat {
  String get label => switch (this) {
        ExpeditionFormat.digitalForge => 'Spirit Forge (app)',
        ExpeditionFormat.huntHueBox => 'Hunt-Hue Box (tabletop)',
      };

  String get emoji => switch (this) {
        ExpeditionFormat.digitalForge => '📱',
        ExpeditionFormat.huntHueBox => '📦',
      };

  String get description => switch (this) {
        ExpeditionFormat.digitalForge =>
          'Hue Spirit forges missions for your room. Phones optional — one device can host the whole group.',
        ExpeditionFormat.huntHueBox =>
          'Draw physical cards from the Hunt-Hue Box deck. This app is the AI host + scorekeeper.',
      };
}
