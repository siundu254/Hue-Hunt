/// User-adjustable mission timer relative to each mode's default.
enum MissionTimerPreset {
  short,
  standard,
  long;

  double get multiplier => switch (this) {
        MissionTimerPreset.short => 0.75,
        MissionTimerPreset.standard => 1.0,
        MissionTimerPreset.long => 1.25,
      };
}
