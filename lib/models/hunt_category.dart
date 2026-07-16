/// What players search for in the room — object, texture, or combo (never colour-only).
enum HuntCategory {
  object,
  texture,
  combo,
}

extension HuntCategoryX on HuntCategory {
  String get label => switch (this) {
        HuntCategory.object => 'Object hunt',
        HuntCategory.texture => 'Texture hunt',
        HuntCategory.combo => 'Combo hunt',
      };

  String get icon => switch (this) {
        HuntCategory.object => '🔍',
        HuntCategory.texture => '✋',
        HuntCategory.combo => '🎯',
      };
}
