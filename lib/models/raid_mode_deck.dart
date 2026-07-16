import 'package:flutter/material.dart';

/// Age band for the Raid Mode Deck — one tuck box, four colour stripes.
enum RaidModeAgeBand {
  family('family', 'Family Raid', '6+', '🟢', Color(0xFF81C784)),
  party('party', 'Party Raid', '13+', '🟠', Color(0xFFFF8A00)),
  expert('expert', 'Expert Raid', 'Adults', '🟣', Color(0xFF9D7BD8)),
  gentle('gentle', 'Gentle Raid', '55+ / Care', '💛', Color(0xFFE8C547));

  const RaidModeAgeBand(this.id, this.label, this.ages, this.emoji, this.color);

  final String id;
  final String label;
  final String ages;
  final String emoji;
  final Color color;

  String get pullRule => switch (this) {
        RaidModeAgeBand.family =>
          'Shuffle green cards only. On ⚡, optionally draw one green twist.',
        RaidModeAgeBand.party =>
          'Shuffle orange cards. Expect noise, blitz timers, and comebacks.',
        RaidModeAgeBand.expert =>
          'Shuffle purple cards. Add Rival Warden for 5+ players.',
        RaidModeAgeBand.gentle =>
          'Use gold cards OR green only. Never pull orange/purple unless group asks.',
      };

  String get bestFor => switch (this) {
        RaidModeAgeBand.family => 'Home · School · Community · mixed-age tables',
        RaidModeAgeBand.party => 'Party · Gym · Retail · teen birthdays',
        RaidModeAgeBand.expert => 'Office · Museum · Library · Airport · HR retreats',
        RaidModeAgeBand.gentle => 'Care · Sunrise · hospital wellness · memory cafés',
      };
}

class RaidModeDeckCard {
  const RaidModeDeckCard({
    required this.id,
    required this.band,
    required this.emoji,
    required this.title,
    required this.setup,
    required this.rule,
    required this.facilitatorTip,
  });

  final String id;
  final RaidModeAgeBand band;
  final String emoji;
  final String title;
  final String setup;
  final String rule;
  final String facilitatorTip;
}

/// 24-card Raid Mode Deck — 6 cards per age band, one tuck box.
abstract final class RaidModeDeck {
  static const sku = 'HHB-MODE-24';
  static const title = 'Raid Mode Deck';
  static const cardCount = 24;

  static const setupSteps = [
    'Look at the table — pick ONE age band (green / orange / purple / gold).',
    'Shuffle only that band (6 cards).',
    'Draw ONE mode at game start — OR draw when any team hits ⚡.',
    'Play that mode for one round (or whole game if marked).',
  ];

  static const mixedAgeRule =
      'Youngest player sets the band — OR green modes for rounds 1–3, one orange finale if everyone is 13+.';

  static const notInDeck =
      'Who Raided? ceremony · Crown Snap · venue rules on overlay · Seasonal Breach packs';

  static const cards = [
    RaidModeDeckCard(
      id: 'fam_combo',
      band: RaidModeAgeBand.family,
      emoji: '🔗',
      title: 'Combo Crew',
      setup: 'Pick one team to track streaks.',
      rule: 'Three successful raids in a row → that team moves +1 (once per game).',
      facilitatorTip: 'Celebrate streaks loudly — no stealing spaces at this band.',
    ),
    RaidModeDeckCard(
      id: 'fam_mashup',
      band: RaidModeAgeBand.family,
      emoji: '🧩',
      title: 'Mashup Map',
      setup: 'Name four corners from any venues you own.',
      rule: 'Same rules, silly geography — Kitchen + Gym + Library + Patio.',
      facilitatorTip: 'Kids love picking impossible rooms; keep boundaries clear.',
    ),
    RaidModeDeckCard(
      id: 'fam_reverse',
      band: RaidModeAgeBand.family,
      emoji: '🔄',
      title: 'Hide & Seek Raid',
      setup: 'One round only.',
      rule: 'Hide object in zone; one guess per rival — wrong guess = no penalty.',
      facilitatorTip: 'Use for round 3 when energy dips.',
    ),
    RaidModeDeckCard(
      id: 'fam_cheer',
      band: RaidModeAgeBand.family,
      emoji: '📣',
      title: 'Cheer Squad',
      setup: 'Non-players are commentators.',
      rule: 'Each spectator may shout ONE hint to one team during a raid.',
      facilitatorTip: 'Grandparents become instant facilitators.',
    ),
    RaidModeDeckCard(
      id: 'fam_wild',
      band: RaidModeAgeBand.family,
      emoji: '🌈',
      title: 'Wild Zone',
      setup: 'Announce before the raid.',
      rule: 'Any room counts as home turf for this mission only.',
      facilitatorTip: 'Great when someone is stuck in last place early.',
    ),
    RaidModeDeckCard(
      id: 'fam_relic',
      band: RaidModeAgeBand.family,
      emoji: '💎',
      title: 'Sticker Relic',
      setup: 'Needs Raid Passport or sheet.',
      rule: 'First to space 5 earns a stamp — +1 on next Bounty draw.',
      facilitatorTip: 'Physical sticker = trophy kids can show off.',
    ),
    RaidModeDeckCard(
      id: 'pty_breach',
      band: RaidModeAgeBand.party,
      emoji: '💥',
      title: 'Vault Breach',
      setup: 'All teams to the starting line.',
      rule: 'Everyone hunts same object; first back +2, second +1.',
      facilitatorTip: 'Trigger on ⚡ or when the table feels flat.',
    ),
    RaidModeDeckCard(
      id: 'pty_heat',
      band: RaidModeAgeBand.party,
      emoji: '🔥',
      title: 'Heat Crucible',
      setup: 'Mark starting timer on charter.',
      rule: 'Each confirmed raid shaves 5s off the timer for the rest of the game.',
      facilitatorTip: 'By space 8 the whole room is sprinting.',
    ),
    RaidModeDeckCard(
      id: 'pty_blitz',
      band: RaidModeAgeBand.party,
      emoji: '⚡',
      title: 'Blitz Round',
      setup: 'Read one object to ALL teams.',
      rule: 'First back advances +2; no one else moves.',
      facilitatorTip: 'Assign a neutral judge at the door.',
    ),
    RaidModeDeckCard(
      id: 'pty_blackout',
      band: RaidModeAgeBand.party,
      emoji: '🌑',
      title: 'Blackout Brief',
      setup: 'Captain reads mission once.',
      rule: 'Flip face-down — no repeats during the raid.',
      facilitatorTip: 'Pairs well with Party overlay.',
    ),
    RaidModeDeckCard(
      id: 'pty_heist',
      band: RaidModeAgeBand.party,
      emoji: '👑',
      title: 'Crown Heist',
      setup: 'Check beam positions.',
      rule: 'Space 9 challenges leader at 10 with DUEL card; winner crowns.',
      facilitatorTip: 'Only when two teams are within 2 spaces.',
    ),
    RaidModeDeckCard(
      id: 'pty_laststand',
      band: RaidModeAgeBand.party,
      emoji: '🛡️',
      title: 'Last Stand',
      setup: 'Find last-place team.',
      rule: 'Once per game: 2 Bounties OR reroll Chaos OR move +2.',
      facilitatorTip: 'Announce dramatically — keeps losers in the hunt.',
    ),
    RaidModeDeckCard(
      id: 'exp_echo',
      band: RaidModeAgeBand.expert,
      emoji: '📡',
      title: 'Echo Mission',
      setup: 'Scan app QR or recall last session.',
      rule: 'Rhyme, texture match, or same zone as last win → +1.',
      facilitatorTip: 'Links board nights into a campaign.',
    ),
    RaidModeDeckCard(
      id: 'exp_warden',
      band: RaidModeAgeBand.expert,
      emoji: '⚖️',
      title: 'Rival Warden',
      setup: 'Add fifth player with gavel.',
      rule: 'Once per round veto one advance — justify in character.',
      facilitatorTip: 'Perfect for Office Raid HR offsites.',
    ),
    RaidModeDeckCard(
      id: 'exp_syndicate',
      band: RaidModeAgeBand.expert,
      emoji: '🎰',
      title: 'Spectator Syndicate',
      setup: 'Guests get one Bounty card each.',
      rule: 'Wager on who finishes first; winners play their card.',
      facilitatorTip: 'Conference lobby energy.',
    ),
    RaidModeDeckCard(
      id: 'exp_silent',
      band: RaidModeAgeBand.expert,
      emoji: '🤫',
      title: 'Silent Gallery',
      setup: 'Whisper mode for whole round.',
      rule: 'No talking from Brief until Reveal.',
      facilitatorTip: 'Default for Museum/Library.',
    ),
    RaidModeDeckCard(
      id: 'exp_combo',
      band: RaidModeAgeBand.expert,
      emoji: '🔗',
      title: 'Expert Combo',
      setup: 'Track one rival pair.',
      rule: 'Three wins → Relic stamp, Bounty, or +2 (pick one).',
      facilitatorTip: 'Resets on failed reveal.',
    ),
    RaidModeDeckCard(
      id: 'exp_wildcard',
      band: RaidModeAgeBand.expert,
      emoji: '🃏',
      title: 'Facilitator Wild',
      setup: 'Facilitator picks lower-band card.',
      rule: 'Play that mode this round.',
      facilitatorTip: 'Safety valve when purple feels too stiff.',
    ),
    RaidModeDeckCard(
      id: 'gen_calm',
      band: RaidModeAgeBand.gentle,
      emoji: '🛋️',
      title: 'Seated Raid',
      setup: 'All finds within arm\'s reach.',
      rule: 'Objects reachable from a chair — facilitator approves.',
      facilitatorTip: 'Default for Care and Sunrise.',
    ),
    RaidModeDeckCard(
      id: 'gen_story',
      band: RaidModeAgeBand.gentle,
      emoji: '📖',
      title: 'Story Object',
      setup: 'One round.',
      rule: 'Find something that sparks a 30s memory; group votes favourite.',
      facilitatorTip: 'Movement optional — connection required.',
    ),
    RaidModeDeckCard(
      id: 'gen_buddy',
      band: RaidModeAgeBand.gentle,
      emoji: '🤝',
      title: 'Buddy Raid',
      setup: 'Pair teams.',
      rule: 'Two corners share one find — both advance +1.',
      facilitatorTip: 'Good for memory cafés.',
    ),
    RaidModeDeckCard(
      id: 'gen_slow',
      band: RaidModeAgeBand.gentle,
      emoji: '🌻',
      title: 'Slow Crucible',
      setup: 'Add 10s to timer once.',
      rule: 'Extend timer 10s for next two raids.',
      facilitatorTip: 'Never stack with Heat Crucible.',
    ),
    RaidModeDeckCard(
      id: 'gen_warm',
      band: RaidModeAgeBand.gentle,
      emoji: '💛',
      title: 'Warm Bounty',
      setup: 'Green Bounties only.',
      rule: 'Bounty draws give compliments or +1 only — no steals.',
      facilitatorTip: 'Swap steal cards out before Care sessions.',
    ),
    RaidModeDeckCard(
      id: 'gen_passport',
      band: RaidModeAgeBand.gentle,
      emoji: '🎖️',
      title: 'Gentle Stamp',
      setup: 'Passport on table.',
      rule: 'Every confirmed raid earns a stamp — five = group photo at crown.',
      facilitatorTip: 'Collective win; no single champion required.',
    ),
  ];

  static List<RaidModeDeckCard> forBand(RaidModeAgeBand band) =>
      cards.where((c) => c.band == band).toList();
}
