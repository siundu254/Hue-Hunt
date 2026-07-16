/// Bold, outside-the-box mechanics for The Raid Map tabletop platform.
abstract final class BoardInnovation {
  static const heatCrucible = BoardInnovationSpec(
    id: 'heat_crucible',
    emoji: '🔥',
    title: 'Heat Crucible',
    hook: 'The room gets faster every round.',
    howItWorks:
        'Each confirmed raid shaves 5s off the printed timer for the rest of the game. '
        'By space 8 the whole table is sprinting.',
    category: BoardInnovationCategory.track,
  );

  static const comboStreak = BoardInnovationSpec(
    id: 'combo_streak',
    emoji: '🔗',
    title: 'Raid Combo Streak',
    hook: 'Momentum rewards consistency.',
    howItWorks:
        'Three successful raids in a row → choose +1 beam, draw Bounty, or stamp a Relic on the Raid Passport. '
        'One failed reveal resets the chain.',
    category: BoardInnovationCategory.track,
  );

  static const lastStand = BoardInnovationSpec(
    id: 'last_stand',
    emoji: '🛡️',
    title: 'Last Stand',
    hook: 'Nobody checks out early.',
    howItWorks:
        'Last-place team gets one comeback per game: Crown Heist duel, flood of Bounty draws, or reroll a Chaos outcome.',
    category: BoardInnovationCategory.track,
  );

  static const crownHeist = BoardInnovationSpec(
    id: 'crown_heist',
    emoji: '👑',
    title: 'Crown Heist',
    hook: 'Steal the finish line.',
    howItWorks:
        'Team at space 9 may challenge the leader at 10 to a DUEL card. Winner takes the crown attempt this round.',
    category: BoardInnovationCategory.track,
  );

  static const reverseRaid = BoardInnovationSpec(
    id: 'reverse_raid',
    emoji: '🔄',
    title: 'Reverse Raid',
    hook: 'Hide instead of hunt.',
    howItWorks:
        'Teams stash an object in their zone. Rivals get one guess each — wrong guess costs a beam space.',
    category: BoardInnovationCategory.mission,
  );

  static const vaultBreach = BoardInnovationSpec(
    id: 'vault_breach',
    emoji: '💥',
    title: 'Vault Breach',
    hook: 'Chaos goes table-wide.',
    howItWorks:
        'When any team lands on ⚡, ALL teams hunt the same object. First back +2; others +0 or −1.',
    category: BoardInnovationCategory.mission,
  );

  static const blackoutBrief = BoardInnovationSpec(
    id: 'blackout_brief',
    emoji: '🌑',
    title: 'Blackout Brief',
    hook: 'Read it once. Remember it.',
    howItWorks:
        'Captain reads the mission once, then flips face-down. No repeats during the raid.',
    category: BoardInnovationCategory.mission,
  );

  static const echoMission = BoardInnovationSpec(
    id: 'echo_mission',
    emoji: '📡',
    title: 'Echo Mission',
    hook: 'Your last raid haunts this one.',
    howItWorks:
        'App QR recalls a prior winning find. Rhyme, texture match, or same zone → bonus space.',
    category: BoardInnovationCategory.mission,
  );

  static const spectatorSyndicate = BoardInnovationSpec(
    id: 'spectator_syndicate',
    emoji: '🎰',
    title: 'Spectator Syndicate',
    hook: 'Guests bet on the chaos.',
    howItWorks:
        'Non-players wager Bounty cards on who finishes first. Winners keep the card effect.',
    category: BoardInnovationCategory.social,
  );

  static const rivalWarden = BoardInnovationSpec(
    id: 'rival_warden',
    emoji: '⚖️',
    title: 'Rival Warden',
    hook: 'A fifth player with a gavel.',
    howItWorks:
        'Rotating neutral vetoes one beam advance per round — must justify it in character.',
    category: BoardInnovationCategory.social,
  );

  static const mashupMap = BoardInnovationSpec(
    id: 'mashup_map',
    emoji: '🧩',
    title: 'Mashup Map',
    hook: 'Impossible geography.',
    howItWorks:
        'Mix corners from two overlays on one board — Office break room + Museum gallery.',
    category: BoardInnovationCategory.meta,
  );

  static const raidRelics = BoardInnovationSpec(
    id: 'raid_relics',
    emoji: '💎',
    title: 'Raid Relics',
    hook: 'Passport stamps that change the next game.',
    howItWorks:
        'Magnetic chips in Raid Passport: Reroll Chaos, Whisper Immunity, +1 on first Bounty.',
    category: BoardInnovationCategory.meta,
  );

  static const seasonalBreach = BoardInnovationSpec(
    id: 'seasonal_breach',
    emoji: '🎃',
    title: 'Seasonal Breach',
    hook: 'Overlays that break their own rules.',
    howItWorks:
        'Halloween = Curse deck; Party = dance-spin faces; Space = lights-off blackout by default.',
    category: BoardInnovationCategory.meta,
  );

  static const whoRaided = BoardInnovationSpec(
    id: 'who_raided',
    emoji: '📣',
    title: 'Who Raided?',
    hook: 'The victory call-and-response.',
    howItWorks:
        'Facilitator: "Who Raided?" Table: "{Team} Raided!" Crown on pedestal.',
    category: BoardInnovationCategory.ceremony,
  );

  static const crownSnap = BoardInnovationSpec(
    id: 'crown_snap',
    emoji: '🧲',
    title: 'Crown Snap',
    hook: 'Magnetic pedestal payoff.',
    howItWorks:
        'Crown clicks home on hidden magnet. Optional fanfare chip in premium box.',
    category: BoardInnovationCategory.ceremony,
  );

  static const all = [
    heatCrucible,
    comboStreak,
    lastStand,
    crownHeist,
    reverseRaid,
    vaultBreach,
    blackoutBrief,
    echoMission,
    spectatorSyndicate,
    rivalWarden,
    mashupMap,
    raidRelics,
    seasonalBreach,
    whoRaided,
    crownSnap,
  ];

  static const chaosCompassFaces = [
    'Swap corners with any rival for next raid',
    'Everyone hunts with one hand behind back',
    'Leader moves back 1 space — underdog surge',
    'Silent raid — no talking until Reveal',
    'Double or nothing: +2 on win, −1 on fail',
    'Wild zone — any room counts this round',
    'Spin again — facilitator picks two twists',
    'Vault Breach — all teams hunt one object',
  ];

  static const bountyOutcomes = [
    'Steal 1 space from the leader',
    'Wild hunt — any zone counts as home turf',
    'Free +1 advance — no hunt required',
    'Force a rival to spin Chaos right now',
    'Secret deed peek — look at one rival screen',
    'Combo streak +1 even on a failed raid (once)',
    'Last Stand token — bank for later',
    'Relic chip — place on Raid Passport',
  ];

  static List<BoardInnovationSpec> forCategory(BoardInnovationCategory cat) =>
      all.where((i) => i.category == cat).toList();
}

enum BoardInnovationCategory {
  track('Raid Track twists'),
  mission('Mission & hunt modes'),
  social('Table & spectator play'),
  meta('Cross-session & SKU magic'),
  ceremony('Win moment & components');

  const BoardInnovationCategory(this.label);
  final String label;
}

class BoardInnovationSpec {
  const BoardInnovationSpec({
    required this.id,
    required this.emoji,
    required this.title,
    required this.hook,
    required this.howItWorks,
    required this.category,
  });

  final String id;
  final String emoji;
  final String title;
  final String hook;
  final String howItWorks;
  final BoardInnovationCategory category;
}
