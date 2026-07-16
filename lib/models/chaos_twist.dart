import 'dart:math';

/// Mid-chapter plot twist — Spirit rewrites the rules live.
class ChaosTwist {
  const ChaosTwist({
    required this.title,
    required this.rule,
    required this.spiritLine,
    required this.emoji,
    this.forcesSuddenDeath = false,
    this.suddenDeathSeconds = 45,
  });

  final String title;
  final String rule;
  final String spiritLine;
  final String emoji;
  final bool forcesSuddenDeath;
  final int suddenDeathSeconds;

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
    ChaosTwist(
      title: 'NO TALKING 30s',
      rule: 'Absolute silence for 30 seconds — gestures only.',
      spiritLine: 'Chaos! No talking for thirty seconds. Mime your way to victory!',
      emoji: '🤐',
    ),
    ChaosTwist(
      title: 'SUDDEN DEATH 45',
      rule: 'Everyone has 45 seconds — when time is up, the mission ends.',
      spiritLine: 'Emergency timer! Forty-five seconds. Sudden death — go!',
      emoji: '⏱️',
      forcesSuddenDeath: true,
      suddenDeathSeconds: 45,
    ),
    ChaosTwist(
      title: 'FREEZE FRAME',
      rule: 'Stand frozen until someone holds up a valid find.',
      spiritLine: 'Freeze! Nobody moves until the object is in the air!',
      emoji: '🧊',
    ),
    ChaosTwist(
      title: 'REVERSE ROLES',
      rule: 'Youngest player hunts; everyone else can only give clues.',
      spiritLine: 'Role swap! Youngest Raiders hunt — adults whisper clues only.',
      emoji: '🔁',
    ),
    ChaosTwist(
      title: 'DOUBLE POINTS',
      rule: 'The next confirmed find is worth double points.',
      spiritLine: 'Bonus chaos! Next confirmed find counts double!',
      emoji: '✖️2',
    ),
    ChaosTwist(
      title: 'MUTE CAPTAIN',
      rule: 'Team captain cannot speak this mission — teammates lead.',
      spiritLine: 'Captain\'s muted! Teammates, you\'re in charge now.',
      emoji: '🔇',
    ),
    ChaosTwist(
      title: 'BLINDFOLD HINT',
      rule: 'Hunter closes eyes — team describes objects nearby.',
      spiritLine: 'Blindfold hunt! Eyes closed, ears open. Trust your squad.',
      emoji: '👁️',
    ),
  ];

  static ChaosTwist random([Random? rng]) =>
      _pool[(rng ?? Random()).nextInt(_pool.length)];
}
