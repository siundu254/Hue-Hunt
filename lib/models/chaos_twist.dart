import 'dart:math';

/// Mid-chapter plot twist — Spirit rewrites the rules live.
class ChaosTwist {
  const ChaosTwist({
    required this.title,
    required this.rule,
    required this.spiritLine,
    required this.emoji,
  });

  final String title;
  final String rule;
  final String spiritLine;
  final String emoji;

  static final _pool = [
    ChaosTwist(
      title: 'SILENT HUNT',
      rule: 'No talking until someone holds up a valid find.',
      spiritLine: 'Plot twist! Silent hunt — not a word until the object is in the air!',
      emoji: '🤫',
    ),
    ChaosTwist(
      title: 'ONE HAND BEHIND',
      rule: 'Everyone hunts with one hand behind their back.',
      spiritLine: 'Chaos unlocked! One hand behind your back. Go!',
      emoji: '🙌',
    ),
    ChaosTwist(
      title: 'YOUNGEST PICKS',
      rule: 'The youngest player names the object category before you hunt.',
      spiritLine: 'Twist! Youngest in the room picks the category. Hurry!',
      emoji: '👶',
    ),
    ChaosTwist(
      title: 'BLIND POINT',
      rule: 'Eyes closed — teammates point you toward the find.',
      spiritLine: 'Madness mode! Close your eyes. Your team points. Trust them.',
      emoji: '🙈',
    ),
    ChaosTwist(
      title: 'HOP TO CONFIRM',
      rule: 'Everyone must hop once before the group can confirm a find.',
      spiritLine: 'Spirit rule! Hop once before you confirm. I want to see energy!',
      emoji: '🦘',
    ),
    ChaosTwist(
      title: 'OPPOSITE HAND',
      rule: 'Pass and hunt using only your non-dominant hand.',
      spiritLine: 'Chaos! Non-dominant hand only. Awkward is allowed.',
      emoji: '✋',
    ),
    ChaosTwist(
      title: 'WHISPER CLUES',
      rule: 'Clues can only be whispered — no shouting.',
      spiritLine: 'Twist! Whisper clues only. This room just got tense.',
      emoji: '🗣️',
    ),
    ChaosTwist(
      title: 'CELEBRITY JUDGE',
      rule: 'One person who is NOT playing picks the winner of this mission.',
      spiritLine: 'Plot twist! Grab a spectator — they are the judge now.',
      emoji: '⭐',
    ),
  ];

  static ChaosTwist random([Random? rng]) =>
      _pool[(rng ?? Random()).nextInt(_pool.length)];
}
