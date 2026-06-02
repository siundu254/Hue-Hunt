enum SpiritMood { neutral, excited, celebrating, rematch }

extension SpiritMoodX on SpiritMood {
  String get emoji => switch (this) {
        SpiritMood.neutral => '✨',
        SpiritMood.excited => '👻',
        SpiritMood.celebrating => '🌈',
        SpiritMood.rematch => '💫',
      };
}
