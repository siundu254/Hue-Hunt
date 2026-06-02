/// What players search for in the room — not colour-only.
enum HuntCategory {
  color,
  object,
  texture,
  combo,
}

extension HuntCategoryX on HuntCategory {
  String get label => switch (this) {
        HuntCategory.color => 'Colour hunt',
        HuntCategory.object => 'Object hunt',
        HuntCategory.texture => 'Texture hunt',
        HuntCategory.combo => 'Combo hunt',
      };

  String get icon => switch (this) {
        HuntCategory.color => '🎨',
        HuntCategory.object => '🔍',
        HuntCategory.texture => '✋',
        HuntCategory.combo => '🎯',
      };
}
