import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/venue_archetype.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// How a venue ships for The Raid Map tabletop product.
enum RaidMapExpansionTier {
  /// In the base Hunt-Hue Box — Home overlay.
  core,

  /// Physical quadrant overlay pack (retail / B2B).
  expansionPack,

  /// App + printable overlay PDF only.
  digital,
}

/// Venue profiles for The Raid Map — same core board, swappable quadrants.
enum RaidMapVenueId {
  home,
  office,
  school,
  hospital,
  party,
  hotel,
  restaurant,
  museum,
  gym,
  library,
  airport,
  community,
  retail,
  campus,
  seniorLiving,
}

/// Raid tempo printed on the vault charter — swaps with venue overlay.
enum RaidPace {
  calm('Calm', 'Longer timer · gentle facilitation'),
  standard('Standard', 'Default family & mixed-age pace'),
  blitz('Blitz', 'Short timer · high-energy venues'),
  whisper('Whisper', 'Quiet hunts · galleries & libraries');

  const RaidPace(this.label, this.description);
  final String label;
  final String description;
}

/// Printed on the board overlay + vault rim — no facilitator notes required.
class VenuePlayProfile {
  const VenuePlayProfile({
    required this.raidTimerSeconds,
    required this.pace,
    required this.ageBand,
    required this.boardBoundaries,
    required this.vaultCharter,
    required this.difficultyStars,
    required this.difficultyLabel,
    required this.recommendedTeamSize,
    required this.ruleModifier,
    required this.loreBrief,
    required this.achievementTitle,
  });

  final int raidTimerSeconds;
  final RaidPace pace;
  final String ageBand;
  final String boardBoundaries;
  final List<String> vaultCharter;
  final int difficultyStars;
  final String difficultyLabel;
  final String recommendedTeamSize;
  final String ruleModifier;
  final String loreBrief;
  final String achievementTitle;

  String get difficultyDisplay =>
      '${List.filled(difficultyStars, '⭐').join()} $difficultyLabel';
}

class RaidMapQuadrant {
  const RaidMapQuadrant({
    required this.id,
    required this.zoneName,
    required this.zoneEmoji,
    required this.teamName,
    required this.teamEmoji,
    required this.color,
    required this.flavor,
    required this.corner,
  });

  final String id;
  final String zoneName;
  final String zoneEmoji;
  final String teamName;
  final String teamEmoji;
  final Color color;
  final String flavor;
  final BoardCorner corner;

  BoardTeam toBoardTeam() => BoardTeam(
        id: id,
        name: teamName,
        roomName: zoneName,
        roomEmoji: zoneEmoji,
        color: color,
        emoji: teamEmoji,
        corner: corner,
        flavor: flavor,
      );
}

/// Full venue overlay — four quadrants + facilitator context.
class RaidMapVenueProfile {
  const RaidMapVenueProfile({
    required this.id,
    required this.title,
    required this.tagline,
    required this.emoji,
    required this.quadrants,
    required this.tier,
    required this.useCase,
    required this.facilitatorTip,
    required this.exampleMissions,
    this.appVenue,
    this.packSku,
  });

  final RaidMapVenueId id;
  final String title;
  final String tagline;
  final String emoji;
  final List<RaidMapQuadrant> quadrants;
  final RaidMapExpansionTier tier;
  final String useCase;
  final String facilitatorTip;
  final List<String> exampleMissions;
  final VenueArchetype? appVenue;
  final String? packSku;

  List<BoardTeam> get teams => quadrants.map((q) => q.toBoardTeam()).toList();

  bool get isCore => tier == RaidMapExpansionTier.core;

  VenuePlayProfile get play => RaidMapVenues.playOf(id);

  int get raidTimerSeconds => play.raidTimerSeconds;

  int get difficultyStars => play.difficultyStars;

  String get difficultyLabel => play.difficultyLabel;

  String get difficultyDisplay => play.difficultyDisplay;

  String get recommendedTeamSize => play.recommendedTeamSize;

  String get ruleModifier => play.ruleModifier;

  String get loreBrief => play.loreBrief;

  String get achievementTitle => play.achievementTitle;
  RaidPace get pace => play.pace;
  String get ageBand => play.ageBand;
  String get boardBoundaries => play.boardBoundaries;
  List<String> get vaultCharter => play.vaultCharter;
}

/// Registry of venue overlays — single source for board, deck, and app alignment.
abstract final class RaidMapVenues {
  static const expansionModel = '''
One universal Raid Map core (vault, beams, crown, compass) +
swappable venue overlay for each setting. Ship Home in the box;
Office, School, Hospital & more as expansion packs or digital PDFs.''';

  static const overlayPhysicalSpec =
      '4 corner overlay tiles · 118×118mm each · slot over quadrant art · reverse-print for storage';

  static RaidMapVenueProfile profile(RaidMapVenueId id) => switch (id) {
        RaidMapVenueId.home => home,
        RaidMapVenueId.office => office,
        RaidMapVenueId.school => school,
        RaidMapVenueId.hospital => hospital,
        RaidMapVenueId.party => party,
        RaidMapVenueId.hotel => hotel,
        RaidMapVenueId.restaurant => restaurant,
        RaidMapVenueId.museum => museum,
        RaidMapVenueId.gym => gym,
        RaidMapVenueId.library => library,
        RaidMapVenueId.airport => airport,
        RaidMapVenueId.community => community,
        RaidMapVenueId.retail => retail,
        RaidMapVenueId.campus => campus,
        RaidMapVenueId.seniorLiving => seniorLiving,
      };

  static RaidMapVenueProfile? fromAppVenue(VenueArchetype venue) => switch (venue) {
        VenueArchetype.livingRoom => home,
        VenueArchetype.office => office,
        VenueArchetype.classroom => school,
        VenueArchetype.hospital => hospital,
        VenueArchetype.party => party,
        VenueArchetype.hotel => hotel,
        VenueArchetype.restaurant => restaurant,
        VenueArchetype.museum => museum,
        VenueArchetype.gym => gym,
        VenueArchetype.library => library,
        VenueArchetype.airport => airport,
        VenueArchetype.community => community,
        VenueArchetype.retail => retail,
        VenueArchetype.campus => campus,
        VenueArchetype.seniorLiving => seniorLiving,
      };

  static List<RaidMapVenueProfile> forTier(RaidMapExpansionTier? tier) {
    if (tier == null) return all;
    return all.where((v) => v.tier == tier).toList();
  }

  static const home = RaidMapVenueProfile(
    id: RaidMapVenueId.home,
    title: 'Home Raid',
    tagline: 'Game night on the coffee table',
    emoji: '🏠',
    tier: RaidMapExpansionTier.core,
    appVenue: VenueArchetype.livingRoom,
    packSku: 'HHB-CORE-MAP',
    useCase: 'Families & friends · living rooms · weekends',
    facilitatorTip: 'Agree which rooms are in-bounds before the first draw.',
    exampleMissions: ['Something on the couch', 'Round AND bouncy', 'Colder than room temp'],
    quadrants: [
      RaidMapQuadrant(
        id: 'living',
        zoneName: 'Living Room',
        zoneEmoji: '🛋️',
        teamName: 'Aurora',
        teamEmoji: '🔥',
        color: AppColors.adventureOrange,
        flavor: 'Couch raids & lamp-lit finds',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'study',
        zoneName: 'Study',
        zoneEmoji: '📚',
        teamName: 'Ember',
        teamEmoji: '⚡',
        color: Color(0xFFE85D04),
        flavor: 'Desk drawers & bookshelf chaos',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'kitchen',
        zoneName: 'Kitchen',
        zoneEmoji: '🍳',
        teamName: 'Tide',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Fridge runs & counter hunts',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'patio',
        zoneName: 'Patio',
        zoneEmoji: '🌿',
        teamName: 'Fern',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Plants, shoes & outdoor loot',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static const office = RaidMapVenueProfile(
    id: RaidMapVenueId.office,
    title: 'Office Raid',
    tagline: 'HR-safe chaos for retreats & stand-ups',
    emoji: '💼',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.office,
    packSku: 'HHB-EXP-OFFICE',
    useCase: 'Team building · onboarding · hybrid offsites',
    facilitatorTip: 'Keep hunts to desks and break areas — no executive floors without permission.',
    exampleMissions: ['Something with a logo', 'Stationery you can share', 'Badge or lanyard'],
    quadrants: [
      RaidMapQuadrant(
        id: 'open',
        zoneName: 'Open Plan',
        zoneEmoji: '🖥️',
        teamName: 'Sprint',
        teamEmoji: '⚡',
        color: Color(0xFF415A77),
        flavor: 'Desks, monitors & swivel chairs',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'break',
        zoneName: 'Break Room',
        zoneEmoji: '☕',
        teamName: 'Pulse',
        teamEmoji: '🔥',
        color: AppColors.adventureOrange,
        flavor: 'Mugs, snacks & microwave mysteries',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'pod',
        zoneName: 'Meeting Pod',
        zoneEmoji: '📋',
        teamName: 'Pivot',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Whiteboards, markers & sticky notes',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'supply',
        zoneName: 'Supply Closet',
        zoneEmoji: '📦',
        teamName: 'Stack',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Cables, adapters & spare keyboards',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static const school = RaidMapVenueProfile(
    id: RaidMapVenueId.school,
    title: 'School Raid',
    tagline: '15-minute classroom energy',
    emoji: '🏫',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.classroom,
    packSku: 'HHB-EXP-SCHOOL',
    useCase: 'Classrooms · after-school clubs · library days',
    facilitatorTip: 'Teacher sets boundaries — hunts stay inside the room unless marked "hall pass".',
    exampleMissions: ['Something you write with', 'Paper AND folded', 'Poster or sign'],
    quadrants: [
      RaidMapQuadrant(
        id: 'class',
        zoneName: 'Classroom',
        zoneEmoji: '✏️',
        teamName: 'Crew A',
        teamEmoji: '🔥',
        color: Color(0xFF0077B6),
        flavor: 'Desks, pencils & project corners',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'library',
        zoneName: 'Library',
        zoneEmoji: '📖',
        teamName: 'Crew B',
        teamEmoji: '⚡',
        color: Color(0xFF4B2A8C),
        flavor: 'Books, shelves & quiet loot',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'hall',
        zoneName: 'Hallway',
        zoneEmoji: '🚪',
        teamName: 'Crew C',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Lockers, hooks & bulletin boards',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'gym',
        zoneName: 'Gym',
        zoneEmoji: '🏀',
        teamName: 'Crew D',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Equipment, mats & sports gear',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static const hospital = RaidMapVenueProfile(
    id: RaidMapVenueId.hospital,
    title: 'Care Raid',
    tagline: 'Gentle hunts for wards & waiting rooms',
    emoji: '🏥',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.hospital,
    packSku: 'HHB-EXP-CARE',
    useCase: 'Children\'s wards · rehab · family waiting areas · staff wellness',
    facilitatorTip: 'Use calm missions only — no running, no clinical equipment, facilitator approves all finds.',
    exampleMissions: ['Something soft', 'A picture or magazine', 'Something that cheers you up'],
    quadrants: [
      RaidMapQuadrant(
        id: 'ward',
        zoneName: 'Patient Bay',
        zoneEmoji: '🛏️',
        teamName: 'Hope',
        teamEmoji: '💛',
        color: Color(0xFF5B9BD5),
        flavor: 'Bedside comforts & personal items',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'nurses',
        zoneName: 'Nurses Station',
        zoneEmoji: '💊',
        teamName: 'Care',
        teamEmoji: '💚',
        color: Color(0xFF70AD47),
        flavor: 'Charts, pens & care supplies (look only)',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'waiting',
        zoneName: 'Waiting Room',
        zoneEmoji: '🪑',
        teamName: 'Calm',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Chairs, toys & reading material',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'rehab',
        zoneName: 'Rehab Gym',
        zoneEmoji: '🧘',
        teamName: 'Restore',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Bands, balls & mobility aids',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static const party = RaidMapVenueProfile(
    id: RaidMapVenueId.party,
    title: 'Party Raid',
    tagline: 'Birthdays, game night, maximum volume',
    emoji: '🎉',
    tier: RaidMapExpansionTier.digital,
    appVenue: VenueArchetype.party,
    packSku: 'HHB-DIG-PARTY',
    useCase: 'House parties · celebrations · adult game nights',
    facilitatorTip: 'Add 5 seconds if someone is holding a drink — house rule on the board.',
    exampleMissions: ['Something loud', 'Party decoration', 'Something a guest brought'],
    quadrants: [
      RaidMapQuadrant(
        id: 'dance',
        zoneName: 'Dance Floor',
        zoneEmoji: '💃',
        teamName: 'Bass',
        teamEmoji: '🔥',
        color: Color(0xFFB5179E),
        flavor: 'Speakers, lights & moving bodies',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'snack',
        zoneName: 'Snack Bar',
        zoneEmoji: '🍕',
        teamName: 'Crumb',
        teamEmoji: '⚡',
        color: AppColors.adventureOrange,
        flavor: 'Plates, drinks & serving chaos',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'photo',
        zoneName: 'Photo Zone',
        zoneEmoji: '📸',
        teamName: 'Flash',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Props, cameras & memorable junk',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'yard',
        zoneName: 'Backyard',
        zoneEmoji: '🌙',
        teamName: 'Night',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Outdoor finds & fire-pit loot',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static const hotel = RaidMapVenueProfile(
    id: RaidMapVenueId.hotel,
    title: 'Hotel Raid',
    tagline: 'Conferences & lobby icebreakers',
    emoji: '🏨',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.hotel,
    packSku: 'HHB-EXP-HOTEL',
    useCase: 'Conferences · retreats · hospitality activations',
    facilitatorTip: 'Stay in public spaces and meeting floors — never guest rooms.',
    exampleMissions: ['Something with a room number', 'Brochure or sign', 'Luggage or bag tag'],
    quadrants: [
      RaidMapQuadrant(
        id: 'lobby',
        zoneName: 'Lobby',
        zoneEmoji: '🛎️',
        teamName: 'Guest',
        teamEmoji: '🔥',
        color: Color(0xFF2B2D42),
        flavor: 'Reception, art & concierge desk',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'conf',
        zoneName: 'Conference',
        zoneEmoji: '🎤',
        teamName: 'Keynote',
        teamEmoji: '⚡',
        color: Color(0xFF8D99AE),
        flavor: 'Badges, lanyards & AV gear',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'lounge',
        zoneName: 'Lounge',
        zoneEmoji: '🍸',
        teamName: 'Mixer',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Couches, menus & networking',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'suite',
        zoneName: 'Suite Hall',
        zoneEmoji: '🚪',
        teamName: 'Bell',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Hall art, carts & room signs',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static const restaurant = RaidMapVenueProfile(
    id: RaidMapVenueId.restaurant,
    title: 'Venue Raid',
    tagline: 'Dining rooms & branded activations',
    emoji: '🍽️',
    tier: RaidMapExpansionTier.digital,
    appVenue: VenueArchetype.restaurant,
    packSku: 'HHB-DIG-VENUE',
    useCase: 'Restaurants · cafés · sponsor pop-ups',
    facilitatorTip: 'Hunts use table items only — staff approves before players leave their section.',
    exampleMissions: ['Something on the menu', 'Napkin AND folded', 'Something branded'],
    quadrants: [
      RaidMapQuadrant(
        id: 'dining',
        zoneName: 'Dining Room',
        zoneEmoji: '🍽️',
        teamName: 'Table',
        teamEmoji: '🔥',
        color: Color(0xFFBC4749),
        flavor: 'Plates, cutlery & table decor',
        corner: BoardCorner.topLeft,
      ),
      RaidMapQuadrant(
        id: 'kitchen',
        zoneName: 'Kitchen Pass',
        zoneEmoji: '👨‍🍳',
        teamName: 'Line',
        teamEmoji: '⚡',
        color: AppColors.adventureOrange,
        flavor: 'Service window & pass-through',
        corner: BoardCorner.topRight,
      ),
      RaidMapQuadrant(
        id: 'bar',
        zoneName: 'Bar',
        zoneEmoji: '🍹',
        teamName: 'Shake',
        teamEmoji: '🌊',
        color: Color(0xFF4ECDC4),
        flavor: 'Glasses, shakers & garnishes',
        corner: BoardCorner.bottomLeft,
      ),
      RaidMapQuadrant(
        id: 'patio',
        zoneName: 'Patio',
        zoneEmoji: '☀️',
        teamName: 'Alfresco',
        teamEmoji: '🌿',
        color: Color(0xFF81C784),
        flavor: 'Outdoor seating & heaters',
        corner: BoardCorner.bottomRight,
      ),
    ],
  );

  static final museum = RaidMapVenueProfile(
    id: RaidMapVenueId.museum,
    title: 'Museum Raid',
    tagline: 'Gallery night — look, don\'t touch',
    emoji: '🏛️',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.museum,
    packSku: 'HHB-EXP-MUSEUM',
    useCase: 'Museums · galleries · science centers · date nights',
    facilitatorTip: 'Hands behind back rule — describe finds without moving exhibits.',
    exampleMissions: ['Something framed', 'Older than you', 'Gift-shop souvenir'],
    quadrants: _q(
      ('Gallery', '🖼️', 'Curio', '🔍', const Color(0xFF6B4E71), 'Paintings & sculptures'),
      ('Lobby', '🏛️', 'Patron', '✨', const Color(0xFFD4A574), 'Tickets & info desk'),
      ('Archive', '📜', 'Archive', '📚', const Color(0xFF8B7355), 'Cases & plaques'),
      ('Café', '☕', 'Espresso', '🔥', AppColors.adventureOrange, 'Museum café finds'),
    ),
  );

  static final gym = RaidMapVenueProfile(
    id: RaidMapVenueId.gym,
    title: 'Gym Raid',
    tagline: 'Fitness floor energy — no equipment moving',
    emoji: '💪',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.gym,
    packSku: 'HHB-EXP-GYM',
    useCase: 'Gyms · CrossFit boxes · school PE · corporate wellness',
    facilitatorTip: 'Point at equipment — never lift, unplug, or block lanes.',
    exampleMissions: ['Something you hydrate with', 'Rubber or foam texture', 'Countdown timer visible'],
    quadrants: _q(
      ('Cardio', '🏃', 'Pace', '⚡', const Color(0xFFE63946), 'Treadmills & bikes'),
      ('Weights', '🏋️', 'Rep', '💪', const Color(0xFF457B9D), 'Racks & dumbbells'),
      ('Studio', '🧘', 'Flow', '🌊', const Color(0xFF4ECDC4), 'Mats & mirrors'),
      ('Locker', '🚿', 'Fresh', '🌿', const Color(0xFF81C784), 'Lockers & benches'),
    ),
  );

  static final library = RaidMapVenueProfile(
    id: RaidMapVenueId.library,
    title: 'Library Raid',
    tagline: 'Whisper-mode scavenger hunt',
    emoji: '📚',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.library,
    packSku: 'HHB-EXP-LIBRARY',
    useCase: 'Public libraries · reading rooms · literacy programs',
    facilitatorTip: 'Indoor voices only — hunts stay in public areas, not stacks staff-only.',
    exampleMissions: ['Something with an ISBN', 'Bookmark or holder', 'Quietest object you find'],
    quadrants: _q(
      ('Stacks', '📚', 'Page', '📖', const Color(0xFF2C5282), 'Shelves & spines'),
      ('Reading', '🪑', 'Quiet', '🤫', const Color(0xFF4A5568), 'Tables & lamps'),
      ('Children', '🧸', 'Story', '✨', const Color(0xFF90CDF4), 'Kids corner loot'),
      ('Desk', '🖥️', 'Loan', '🔖', AppColors.mysteryPurple, 'Checkout & returns'),
    ),
  );

  static final airport = RaidMapVenueProfile(
    id: RaidMapVenueId.airport,
    title: 'Transit Raid',
    tagline: 'Layover legends — gate to gate',
    emoji: '✈️',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.airport,
    packSku: 'HHB-EXP-AIRPORT',
    useCase: 'Airports · train stations · conference transit lounges',
    facilitatorTip: 'Stay airside/public — never security lines or baggage belts.',
    exampleMissions: ['Something with a destination', 'Rolling luggage', 'Boarding pass or ticket'],
    quadrants: _q(
      ('Gate', '🛫', 'Board', '✈️', const Color(0xFF1D3557), 'Seating & displays'),
      ('Shop', '🛍️', 'Duty', '💼', AppColors.adventureOrange, 'Duty-free finds'),
      ('Food', '🍔', 'Bite', '🔥', const Color(0xFFE85D04), 'Food court raid'),
      ('Arrivals', '🧳', 'Land', '🌊', const Color(0xFFA8DADC), 'Carousel & signage'),
    ),
  );

  static final community = RaidMapVenueProfile(
    id: RaidMapVenueId.community,
    title: 'Community Raid',
    tagline: 'Parish halls · youth clubs · town centers',
    emoji: '🤝',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.community,
    packSku: 'HHB-EXP-COMMUNITY',
    useCase: 'Community centers · churches · scout halls · rec centers',
    facilitatorTip: 'Respect sacred spaces — facilitator marks off-limits zones before play.',
    exampleMissions: ['Something handmade', 'Folded paper', 'Something donated'],
    quadrants: _q(
      ('Main Hall', '🎪', 'Gather', '🤝', const Color(0xFF588157), 'Chairs & stage'),
      ('Kitchen', '🍲', 'Serve', '🔥', AppColors.adventureOrange, 'Potluck & pantry'),
      ('Craft', '🎨', 'Make', '✨', const Color(0xFFA3B18A), 'Supplies & projects'),
      ('Garden', '🌻', 'Grow', '🌿', const Color(0xFF81C784), 'Outdoor patch & tools'),
    ),
  );

  static final retail = RaidMapVenueProfile(
    id: RaidMapVenueId.retail,
    title: 'Retail Raid',
    tagline: 'In-store activations & mall events',
    emoji: '🛍️',
    tier: RaidMapExpansionTier.digital,
    appVenue: VenueArchetype.retail,
    packSku: 'HHB-DIG-RETAIL',
    useCase: 'Stores · malls · pop-ups · brand sponsor days',
    facilitatorTip: 'Hands-off merchandise — describe items without unboxing stock.',
    exampleMissions: ['Something on sale', 'Branded bag or tag', 'Something shiny on display'],
    quadrants: _q(
      ('Front', '🪟', 'Window', '✨', AppColors.treasureYellow, 'Display & entrance'),
      ('Aisle', '🛒', 'Browse', '🔍', AppColors.adventureOrange, 'Shelves & signs'),
      ('Fitting', '👕', 'Try', '⚡', const Color(0xFFE85D04), 'Mirrors & hooks'),
      ('Checkout', '💳', 'Pay', '🌊', const Color(0xFF4ECDC4), 'Counters & baskets'),
    ),
  );

  static final campus = RaidMapVenueProfile(
    id: RaidMapVenueId.campus,
    title: 'Campus Raid',
    tagline: 'Orientation week classic',
    emoji: '🎓',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.campus,
    packSku: 'HHB-EXP-CAMPUS',
    useCase: 'Universities · dorms · student unions · frosh week',
    facilitatorTip: 'Public campus only — no dorm rooms without resident permission.',
    exampleMissions: ['Something with a logo', 'Student ID or lanyard', 'Poster for an event'],
    quadrants: _q(
      ('Quad', '🌳', 'Quad', '🌿', const Color(0xFF588157), 'Lawns & benches'),
      ('Union', '🎓', 'Union', '🔥', const Color(0xFF5A189A), 'Food court & clubs'),
      ('Library', '📚', 'Study', '📖', const Color(0xFFC77DFF), 'Campus library corner'),
      ('Lab', '🔬', 'Lab', '⚡', const Color(0xFF4ECDC4), 'Hallways & bulletin boards'),
    ),
  );

  static final seniorLiving = RaidMapVenueProfile(
    id: RaidMapVenueId.seniorLiving,
    title: 'Sunrise Raid',
    tagline: 'Gentle social play for senior communities',
    emoji: '🌻',
    tier: RaidMapExpansionTier.expansionPack,
    appVenue: VenueArchetype.seniorLiving,
    packSku: 'HHB-EXP-SUNRISE',
    useCase: 'Senior living · assisted living · day centers · memory cafés',
    facilitatorTip: 'Seated-friendly hunts — no rushing, small groups, facilitator approves every find.',
    exampleMissions: ['Something from a memory', 'Knitting or craft item', 'Photo of family'],
    quadrants: _q(
      ('Lounge', '🛋️', 'Warm', '💛', const Color(0xFFE8C547), 'Couches & TV nook'),
      ('Dining', '🍽️', 'Table', '🤝', const Color(0xFF7B6B8A), 'Dining hall & menus'),
      ('Garden', '🌻', 'Bloom', '🌿', const Color(0xFF81C784), 'Raised beds & benches'),
      ('Activity', '🎲', 'Play', '✨', const Color(0xFF5B9BD5), 'Games & craft table'),
    ),
  );

  /// Builds four quadrants in corner order: TL, TR, BL, BR.
  static List<RaidMapQuadrant> _q(
    (String zone, String zoneEmoji, String team, String teamEmoji, Color color, String flavor) tl,
    (String, String, String, String, Color, String) tr,
    (String, String, String, String, Color, String) bl,
    (String, String, String, String, Color, String) br,
  ) =>
      [
        RaidMapQuadrant(
          id: tl.$1.toLowerCase().replaceAll(' ', '_'),
          zoneName: tl.$1,
          zoneEmoji: tl.$2,
          teamName: tl.$3,
          teamEmoji: tl.$4,
          color: tl.$5,
          flavor: tl.$6,
          corner: BoardCorner.topLeft,
        ),
        RaidMapQuadrant(
          id: tr.$1.toLowerCase().replaceAll(' ', '_'),
          zoneName: tr.$1,
          zoneEmoji: tr.$2,
          teamName: tr.$3,
          teamEmoji: tr.$4,
          color: tr.$5,
          flavor: tr.$6,
          corner: BoardCorner.topRight,
        ),
        RaidMapQuadrant(
          id: bl.$1.toLowerCase().replaceAll(' ', '_'),
          zoneName: bl.$1,
          zoneEmoji: bl.$2,
          teamName: bl.$3,
          teamEmoji: bl.$4,
          color: bl.$5,
          flavor: bl.$6,
          corner: BoardCorner.bottomLeft,
        ),
        RaidMapQuadrant(
          id: br.$1.toLowerCase().replaceAll(' ', '_'),
          zoneName: br.$1,
          zoneEmoji: br.$2,
          teamName: br.$3,
          teamEmoji: br.$4,
          color: br.$5,
          flavor: br.$6,
          corner: BoardCorner.bottomRight,
        ),
      ];

  static List<RaidMapVenueProfile> get all => [
        home,
        office,
        school,
        hospital,
        party,
        hotel,
        restaurant,
        museum,
        gym,
        library,
        airport,
        community,
        retail,
        campus,
        seniorLiving,
      ];

  static List<RaidMapVenueProfile> get expansionPacks =>
      all.where((v) => v.tier == RaidMapExpansionTier.expansionPack).toList();

  static List<RaidMapVenueProfile> get digitalOverlays =>
      all.where((v) => v.tier == RaidMapExpansionTier.digital).toList();

  /// Per-venue timer, pace, age band & vault charter — printed on overlay, not written down.
  static VenuePlayProfile playOf(RaidMapVenueId id) => _playProfiles[id]!;

  static const _playProfiles = {
    RaidMapVenueId.home: VenuePlayProfile(
      raidTimerSeconds: 60,
      pace: RaidPace.standard,
      ageBand: 'All ages',
      boardBoundaries: 'Living · Study · Kitchen · Patio',
      vaultCharter: ['RAID 60s', 'PACE Standard', 'AGES All', 'STAY in agreed rooms'],
      difficultyStars: 2,
      difficultyLabel: 'Easy',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Agree in-bounds rooms before the first draw',
      loreBrief: 'Game night chaos — find the loot before pizza arrives.',
      achievementTitle: 'Couch Commander',
    ),
    RaidMapVenueId.office: VenuePlayProfile(
      raidTimerSeconds: 45,
      pace: RaidPace.blitz,
      ageBand: 'Adults',
      boardBoundaries: 'Desks · break room · pods only',
      vaultCharter: ['RAID 45s', 'PACE Blitz', 'AGES Adults', 'NO exec floors'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '4–8',
      ruleModifier: 'No running — desk and break areas only',
      loreBrief: 'Confidential files have gone missing. Search before the board meeting begins.',
      achievementTitle: 'Office Detective',
    ),
    RaidMapVenueId.school: VenuePlayProfile(
      raidTimerSeconds: 60,
      pace: RaidPace.standard,
      ageBand: '8+',
      boardBoundaries: 'Class · library · hall · gym',
      vaultCharter: ['RAID 60s', 'PACE Standard', 'AGES 8+', 'TEACHER sets bounds'],
      difficultyStars: 2,
      difficultyLabel: 'Easy',
      recommendedTeamSize: '6–12',
      ruleModifier: 'Teacher sets boundaries before play',
      loreBrief: 'The bell rings in fifteen minutes — clear the classroom hunt.',
      achievementTitle: 'Hall Monitor Hero',
    ),
    RaidMapVenueId.hospital: VenuePlayProfile(
      raidTimerSeconds: 90,
      pace: RaidPace.calm,
      ageBand: 'All ages',
      boardBoundaries: 'Bay · waiting · rehab · nurses look-only',
      vaultCharter: ['RAID 90s', 'PACE Calm', 'AGES All', 'NO running · soft finds'],
      difficultyStars: 2,
      difficultyLabel: 'Easy',
      recommendedTeamSize: '4–6',
      ruleModifier: 'No running · calm missions · facilitator approves finds',
      loreBrief: 'Bring a smile to the waiting room before visiting hours end.',
      achievementTitle: 'Gentle Guardian',
    ),
    RaidMapVenueId.party: VenuePlayProfile(
      raidTimerSeconds: 45,
      pace: RaidPace.blitz,
      ageBand: '13+',
      boardBoundaries: 'Dance · snack · photo · yard',
      vaultCharter: ['RAID 45s', 'PACE Blitz', 'AGES 13+', '+5s if holding drink'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '6+',
      ruleModifier: 'Bonus dance challenge when music plays',
      loreBrief: 'The host hid the party favors — find them before cake time.',
      achievementTitle: 'Dance Captain',
    ),
    RaidMapVenueId.hotel: VenuePlayProfile(
      raidTimerSeconds: 45,
      pace: RaidPace.standard,
      ageBand: 'Adults',
      boardBoundaries: 'Lobby · conf · lounge · halls',
      vaultCharter: ['RAID 45s', 'PACE Standard', 'AGES Adults', 'NO guest rooms'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Public spaces only — never enter guest rooms',
      loreBrief: 'VIP luggage vanished in the lobby — recover it before check-in rush.',
      achievementTitle: 'Concierge Crafter',
    ),
    RaidMapVenueId.restaurant: VenuePlayProfile(
      raidTimerSeconds: 40,
      pace: RaidPace.blitz,
      ageBand: 'All ages',
      boardBoundaries: 'Table items · bar · patio section',
      vaultCharter: ['RAID 40s', 'PACE Blitz', 'AGES All', 'STAFF approves bounds'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Table items only · staff approves boundaries',
      loreBrief: 'The signature dish needs a garnish — raid the dining room before service.',
      achievementTitle: 'Menu Maven',
    ),
    RaidMapVenueId.museum: VenuePlayProfile(
      raidTimerSeconds: 75,
      pace: RaidPace.whisper,
      ageBand: 'All ages',
      boardBoundaries: 'Gallery · lobby · archive · café',
      vaultCharter: ['RAID 75s', 'PACE Whisper', 'AGES All', 'LOOK don\'t touch'],
      difficultyStars: 4,
      difficultyLabel: 'Expert',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Whisper throughout · describe finds without moving exhibits',
      loreBrief: 'A curator\'s clue trail leads through the galleries before closing time.',
      achievementTitle: 'Silent Scholar',
    ),
    RaidMapVenueId.gym: VenuePlayProfile(
      raidTimerSeconds: 50,
      pace: RaidPace.standard,
      ageBand: '13+',
      boardBoundaries: 'Cardio · weights · studio · lockers',
      vaultCharter: ['RAID 50s', 'PACE Standard', 'AGES 13+', 'POINT don\'t move gear'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Point at equipment — never lift or unplug',
      loreBrief: 'Class starts in five — find your gear before the warm-up whistle.',
      achievementTitle: 'Rep Raider',
    ),
    RaidMapVenueId.library: VenuePlayProfile(
      raidTimerSeconds: 75,
      pace: RaidPace.whisper,
      ageBand: 'All ages',
      boardBoundaries: 'Stacks · reading · kids · desk',
      vaultCharter: ['RAID 75s', 'PACE Whisper', 'AGES All', 'INDOOR voices'],
      difficultyStars: 4,
      difficultyLabel: 'Expert',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Whisper throughout the game',
      loreBrief: 'A rare volume was mis-shelved — return it before quiet hour.',
      achievementTitle: 'Page Turner',
    ),
    RaidMapVenueId.airport: VenuePlayProfile(
      raidTimerSeconds: 45,
      pace: RaidPace.blitz,
      ageBand: 'Adults',
      boardBoundaries: 'Gate · shop · food · arrivals',
      vaultCharter: ['RAID 45s', 'PACE Blitz', 'AGES Adults', 'STAY airside public'],
      difficultyStars: 4,
      difficultyLabel: 'Expert',
      recommendedTeamSize: '6+',
      ruleModifier: 'Stay airside public — never block security lines',
      loreBrief: 'Gate change panic — locate boarding essentials before boarding.',
      achievementTitle: 'Gate Guardian',
    ),
    RaidMapVenueId.community: VenuePlayProfile(
      raidTimerSeconds: 60,
      pace: RaidPace.standard,
      ageBand: 'All ages',
      boardBoundaries: 'Hall · kitchen · craft · garden',
      vaultCharter: ['RAID 60s', 'PACE Standard', 'AGES All', 'MARK sacred off-limits'],
      difficultyStars: 2,
      difficultyLabel: 'Easy',
      recommendedTeamSize: '6–12',
      ruleModifier: 'Mark sacred or off-limits zones before play',
      loreBrief: 'Potluck setup is behind schedule — gather supplies before guests arrive.',
      achievementTitle: 'Gather Leader',
    ),
    RaidMapVenueId.retail: VenuePlayProfile(
      raidTimerSeconds: 40,
      pace: RaidPace.blitz,
      ageBand: 'All ages',
      boardBoundaries: 'Front · aisle · fitting · checkout',
      vaultCharter: ['RAID 40s', 'PACE Blitz', 'AGES All', 'HANDS off stock'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '4–8',
      ruleModifier: 'Hands off merchandise — describe finds only',
      loreBrief: 'The window display is missing a hero product before the flash sale opens.',
      achievementTitle: 'Shelf Sleuth',
    ),
    RaidMapVenueId.campus: VenuePlayProfile(
      raidTimerSeconds: 60,
      pace: RaidPace.standard,
      ageBand: '13+',
      boardBoundaries: 'Quad · union · library · lab halls',
      vaultCharter: ['RAID 60s', 'PACE Standard', 'AGES 13+', 'PUBLIC campus only'],
      difficultyStars: 3,
      difficultyLabel: 'Medium',
      recommendedTeamSize: '6+',
      ruleModifier: 'Public campus only — no dorm rooms without permission',
      loreBrief: 'Orientation scavenger — collect clues across the quad before the rally.',
      achievementTitle: 'Quad Captain',
    ),
    RaidMapVenueId.seniorLiving: VenuePlayProfile(
      raidTimerSeconds: 90,
      pace: RaidPace.calm,
      ageBand: '55+ gentle',
      boardBoundaries: 'Lounge · dining · garden · activity',
      vaultCharter: ['RAID 90s', 'PACE Calm', 'AGES 55+', 'SEATED · approve finds'],
      difficultyStars: 2,
      difficultyLabel: 'Easy',
      recommendedTeamSize: '4–6',
      ruleModifier: 'Seated-friendly · facilitator approves every find',
      loreBrief: 'Activity hour memories — share a story object before tea service.',
      achievementTitle: 'Memory Keeper',
    ),
  };
}
