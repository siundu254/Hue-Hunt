import 'package:flutter/material.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Physical Hunt-Hue Box — The Raid Map (expandable venue platform).
abstract final class BoardPrototypeSpec {
  static const productName = 'Hunt-Hue Box';
  static const boardName = 'The Raid Map';
  static const tagline = 'One board. Every room. Swap the map.';
  static const version = 'Prototype v2.3 — cards · venue timers · vault charter';

  /// Default venue in retail box.
  static const defaultVenue = RaidMapVenueId.home;

  static const boardWidthMm = 480;
  static const boardHeightMm = 480;
  static const boardFold = 'Quad-fold rigid board · 240×240mm · spot-UV beam tracks';

  /// Sand-timer options for Timer Crucible dial (printed ring on vault).
  static const timerDialSeconds = [45, 60, 75, 90];

  static int huntTimerSecondsFor(RaidMapVenueId venue) =>
      RaidMapVenues.playOf(venue).raidTimerSeconds;

  static const boxWidthMm = 295;
  static const boxHeightMm = 295;
  static const boxDepthMm = 75;

  static const cardWidthMm = 63;
  static const cardHeightMm = 88;
  static const totalCards = 48;
  static const winScore = 10;

  /// Legacy default — use [huntTimerSecondsFor] per venue.
  static const huntTimerSeconds = 60;

  /// Chaos-checkpoint spaces on every raid beam (draw chaos twist).
  static const chaosCheckpoints = [3, 6, 9];

  /// Sudden-death reminder space on every beam.
  static const suddenDeathSpace = 7;

  /// Bounty-card spaces — draw a Raid Bounty for bonus advance (Monopoly-style pickup).
  static const bountySpaces = [2, 5];

  static const raidTrackMechanics = [
    'HQ (0) — your corner deed · teams start every raid here',
    'Loot (1, 4, 8) — standard advance on a successful hunt',
    'Bounty ★ (2, 5) — draw Raid Bounty card · bonus space or steal',
    'Chaos ⚡ (3, 6, 9) — spin the Chaos Compass',
    'Sudden Death 💀 (7) — risk elimination or lose a space',
    'Crown 👑 (10) — place the Raid Crown · you win',
    'Territory bonus — hunt in your zone = +1 extra space',
    'Blitz round — all teams hunt the same object · winner +2',
    'Raid Combo Streak — 3 wins → +1, Bounty, or Relic stamp',
    'Last Stand — last place gets one comeback per game',
    'Crown Heist — space 9 challenges leader at 10 (DUEL card)',
    'Heat Crucible — each confirmed raid shaves 5s off the timer',
  ];

  static List<BoardTeam> teamsFor(RaidMapVenueId venue) => RaidMapVenues.profile(venue).teams;

  static RaidMapVenueProfile venueProfile(RaidMapVenueId id) => RaidMapVenues.profile(id);

  static const vaultZones = [
    BoardZone(
      id: 'draw',
      label: 'Mission altar',
      subtitle: 'Face-down deck · captain draws here',
      icon: Icons.layers,
      widthMm: 63,
      heightMm: 88,
    ),
    BoardZone(
      id: 'active',
      label: 'Spotlight',
      subtitle: 'Active mission · read to the room',
      icon: Icons.flashlight_on,
      widthMm: 63,
      heightMm: 88,
    ),
    BoardZone(
      id: 'discard',
      label: 'Loot chute',
      subtitle: 'Played cards slide in · reshuffle when empty',
      icon: Icons.layers_clear,
      widthMm: 63,
      heightMm: 88,
    ),
    BoardZone(
      id: 'timer',
      label: 'Timer crucible',
      subtitle: 'Sand timer + printed dial · venue default marked on overlay',
      icon: Icons.hourglass_bottom,
      widthMm: 50,
      heightMm: 50,
    ),
    BoardZone(
      id: 'chaos',
      label: 'Chaos Compass',
      subtitle: 'Spin for sudden-death & twist events',
      icon: Icons.explore,
      widthMm: 70,
      heightMm: 70,
    ),
    BoardZone(
      id: 'crown',
      label: 'Crown pedestal',
      subtitle: 'First team to 10 places the Raid Crown here',
      icon: Icons.emoji_events,
      widthMm: 45,
      heightMm: 45,
    ),
  ];

  /// Alias for vault zones (legacy id).
  static List<BoardZone> get zones => vaultZones;

  static const turnPhases = [
    BoardTurnPhase(
      step: 1,
      title: 'Brief',
      body: 'Raid Captain draws from the Mission Altar and reads the hunt to every room.',
      icon: Icons.campaign,
    ),
    BoardTurnPhase(
      step: 2,
      title: 'Raid',
      body: 'Flip timer to the seconds on the mission card (or vault charter default). Hunt the real space.',
      icon: Icons.directions_run,
    ),
    BoardTurnPhase(
      step: 3,
      title: 'Reveal',
      body: 'Bring finds back to your room corner. Group confirms — trust vote, captain breaks ties.',
      icon: Icons.visibility,
    ),
    BoardTurnPhase(
      step: 4,
      title: 'Vault',
      body: 'Advance your token along the Raid Beam. Hit ⚡? Spin the Chaos Compass. First to 👑 wins.',
      icon: Icons.emoji_events,
    ),
  ];

  static const signatureComponents = [
    BoardComponent('The Raid Crown', '1', 'Metal/resin 35mm centerpiece · photo moment'),
    BoardComponent('Chaos Compass dial', '1', 'Mounted spinner · 8 sudden-death & twist faces'),
    BoardComponent('Secret screens (folding)', '4', 'Corner privacy shields for hidden objectives'),
    BoardComponent('Flashlight beam tracks', '4', 'Spot-UV ink on raid meters · Kickstarter premium'),
  ];

  static const components = [
    BoardComponent('Home venue overlay (core)', '1', '4 quadrant tiles + printed vault charter rim'),
    BoardComponent('Raid Mode Deck (tuck box)', '24', '6 cards × 4 age bands — green / orange / purple / gold stripes'),
    BoardComponent('Mission brief cards', '48', '63×88mm · timer on face · venue stripe on back'),
    BoardComponent('Raid Crown miniature', '1', '35mm · sits on crown pedestal'),
    BoardComponent('Chaos Compass (mounted)', '1', '70mm spinner in vault'),
    BoardComponent('Secret objective screens', '4', 'Folding cardboard · one per room'),
    BoardComponent('Team raider tokens', '4', 'Flashlight-meeples · 28mm · room colors'),
    BoardComponent('Sand timer set', '4', '45/60/75/90s · nest in crucible dial well'),
    BoardComponent('Raid Captain grimoire', '1', 'A5 rules + lore · 12pp (optional — charter on board)'),
    BoardComponent('Premium box + molded insert', '1', '295×295×75mm · crown well in lid'),
    BoardComponent('QR relic sticker', '1', 'Unlocks digital missions in Room Raiders app'),
  ];

  static const cardMix = [
    BoardCardMix('Object hunts', 18, AppColors.adventureOrange),
    BoardCardMix('Combo hunts', 12, AppColors.mysteryPurple),
    BoardCardMix('Texture hunts', 7, Color(0xFF4ECDC4)),
    BoardCardMix('Relay', 4, AppColors.treasureYellow),
    BoardCardMix('Duel', 4, Color(0xFFE85D04)),
    BoardCardMix('Ritual', 3, Color(0xFF81C784)),
  ];

  static const whyItWins = [
    'One universal core — vault, beams, crown, compass — never rebuy the board.',
    'Venue overlays swap the floor plan: Home, Office, School, Hospital & more.',
    'Same mission pipeline as Room Raiders app — tabletop + digital stay aligned.',
    'B2B expansion packs: Office, School, Care kits for institutional buyers.',
    '"Who Raided?" crown ceremony works in every venue — shareable everywhere.',
    'Outside-the-box modes: Reverse Raid, Vault Breach, Mashup Map, Raid Relics.',
  ];

  static const expansionDeliverables = [
    'Core box: Raid Map + Home overlay + crown + compass + 48 cards',
    'Expansion pack: 4 overlay tiles + 12 venue cards + facilitator tip card',
    'Digital: printable overlay PDF + app venue sync',
    'Enterprise: white-label overlay for hotels, hospitals, sponsors',
  ];

  static const prototypeNotes = [
    'Mission brief cards print ⏱ seconds on every face — facilitators never look up timers.',
    'Venue overlay swaps the vault charter rim: timer, pace, age band, boundaries (4 lines).',
    'Timer crucible has embossed dial 45/60/75/90 — arrow on overlay points to venue default.',
    'Hero shot: crown on pedestal, compass mid-spin, card in spotlight — shoot for Kickstarter.',
    'Raid beams need spot-UV or metallic ink so they read under living-room light.',
    'Deliver: 1× core map + 2× expansion overlay proofs + card face sheet per venue.',
  ];

  static const vaultCharterSpec = '''
Vault charter rim (printed on every venue overlay — swaps with the map)
• Line 1: RAID {seconds}s — default sand timer for this venue
• Line 2: PACE {Calm|Standard|Blitz|Whisper}
• Line 3: AGES {band}
• Line 4: BOUNDARIES — in-bounds zones in ≤6 words
Facilitator tip card is optional; charter replaces handwritten notes.''';
}

enum BoardCorner { topLeft, topRight, bottomLeft, bottomRight }

class BoardTeam {
  const BoardTeam({
    required this.id,
    required this.name,
    required this.roomName,
    required this.roomEmoji,
    required this.color,
    required this.emoji,
    required this.corner,
    required this.flavor,
  });

  final String id;
  final String name;
  final String roomName;
  final String roomEmoji;
  final Color color;
  final String emoji;
  final BoardCorner corner;
  final String flavor;
}

class BoardZone {
  const BoardZone({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.widthMm,
    required this.heightMm,
  });

  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final int widthMm;
  final int heightMm;
}

class BoardTurnPhase {
  const BoardTurnPhase({
    required this.step,
    required this.title,
    required this.body,
    required this.icon,
  });

  final int step;
  final String title;
  final String body;
  final IconData icon;
}

class BoardComponent {
  const BoardComponent(this.name, this.qty, this.spec);
  final String name;
  final String qty;
  final String spec;
}

class BoardCardMix {
  const BoardCardMix(this.label, this.count, this.color);
  final String label;
  final int count;
  final Color color;
}
