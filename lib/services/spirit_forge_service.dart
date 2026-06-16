import 'dart:math';
import 'package:hue_hunt/models/hunt_category.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/venue_archetype.dart';

/// Generates bespoke chapters from room DNA — feels AI-forged, runs offline.
class SpiritForgeService {
  static final _rng = Random();

  static List<MissionDefinition> forge({
    required VenueArchetype venue,
    String? roomNickname,
    int count = 4,
  }) {
    final pool = List<MissionDefinition>.from(_poolFor(venue));
    pool.shuffle(_rng);
    final chapter = pool.take(count).toList();
    if (roomNickname != null && roomNickname.trim().isNotEmpty && chapter.isNotEmpty) {
      final nick = roomNickname.trim();
      chapter[0] = MissionDefinition(
        type: chapter[0].type,
        hueName: '${chapter[0].hueName} · $nick',
        hex: chapter[0].hex,
        clue: chapter[0].clue,
        picture: chapter[0].picture,
        huntCategory: chapter[0].huntCategory,
        objectPrompt: '${chapter[0].challengePrompt} (for $nick)',
        funFact: 'Forged live by the Hue Spirit for this exact room.',
      );
    }
    return chapter;
  }

  static String forgeNarration(VenueArchetype venue, {String? roomNickname, bool box = false}) {
    final place = roomNickname?.trim().isNotEmpty == true
        ? roomNickname!.trim()
        : venue.label;
    if (box) {
      return 'Hunt-Hue Box mode for $place. '
          'Draw physical cards — I am your AI host and scorekeeper. Let\'s go!';
    }
    return 'I am reading the energy of $place. '
        'Forging missions that only work in this room. '
        'This chapter has never existed before. Ready?';
  }

  /// Box deck: object-led cards only, shuffled like a live forge.
  static List<MissionDefinition> forgeFromBoxDeck(
    List<MissionDefinition> pool, {
    int count = 5,
  }) {
    final objectLed = pool
        .where(
          (m) => m.type != MissionType.hunt || m.huntCategory != HuntCategory.color,
        )
        .toList();
    final deck = List<MissionDefinition>.from(objectLed.isEmpty ? pool : objectLed);
    deck.shuffle(_rng);
    return deck.take(count).toList();
  }

  static List<MissionDefinition> _poolFor(VenueArchetype venue) => switch (venue) {
        VenueArchetype.livingRoom => _livingRoom,
        VenueArchetype.office => _office,
        VenueArchetype.party => _party,
        VenueArchetype.classroom => _classroom,
        VenueArchetype.restaurant => _restaurant,
        VenueArchetype.hotel => _hotel,
      };

  static const _livingRoom = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Remote Royale',
      hex: '#4A5568',
      objectPrompt: 'Find the thing that controls the TV',
      clue: 'Remote, phone, or tablet — whatever runs the screen.',
      picture: '📺',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.combo,
      hueName: 'Couch Combo',
      hex: '#D69E2E',
      objectPrompt: 'Find something soft AND something you snack on',
      clue: 'Pillow plus chips. Blanket plus fruit. Be creative.',
      picture: '🛋️',
    ),
    MissionDefinition(
      type: MissionType.forge,
      hueName: 'Coffee Table Trio',
      hex: '#8B4513',
      objectPrompt: 'Collect 3 objects currently on or under the coffee table',
      clue: 'Coasters, books, remotes — real items only.',
      picture: '☕',
    ),
    MissionDefinition(
      type: MissionType.echo,
      hueName: 'Pet Sketch',
      hex: '#F6AD55',
      objectPrompt: 'Sketch a pet toy or something a pet would steal',
      clue: 'Stick figures welcome — group guesses the object.',
      picture: '🐾',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Shelf Relay',
      hex: '#718096',
      objectPrompt: 'Each player grabs one object from a shelf or mantle',
      clue: 'Pass the device after each find.',
      picture: '📚',
    ),
    MissionDefinition(
      type: MissionType.duel,
      hueName: 'Cushion Clash',
      hex: '#ED8936',
      objectPrompt: 'Find the comfiest object in the room',
      clue: 'Teams race — tap when your squad has it.',
      picture: '🪑',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Living Room Legend',
      hex: '#ECC94B',
      objectPrompt: 'Everyone reveals the weirdest object in this room',
      clue: 'Group vote — no camera required.',
      picture: '🏆',
    ),
  ];

  static const _office = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Deadline Dash',
      hex: '#2D3748',
      objectPrompt: 'Find something with a date or deadline on it',
      clue: 'Calendar, sticky note, or laptop notification.',
      picture: '📅',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.texture,
      hueName: 'Ergonomic Hunt',
      hex: '#4A5568',
      objectPrompt: 'Find something that supports how you work',
      clue: 'Chair, stand, wrist rest, or headphones.',
      picture: '🪑',
    ),
    MissionDefinition(
      type: MissionType.forge,
      hueName: 'Desk Drawer Trio',
      hex: '#3182CE',
      objectPrompt: 'Collect 3 professional objects a colleague would recognize',
      clue: 'Badge, pen, notebook — keep it workplace-safe.',
      picture: '💼',
    ),
    MissionDefinition(
      type: MissionType.echo,
      hueName: 'Whiteboard Sketch',
      hex: '#805AD5',
      objectPrompt: 'Sketch your worst meeting face',
      clue: 'Teammates guess the expression — laughter counts.',
      picture: '😬',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Break Room Relay',
      hex: '#38A169',
      objectPrompt: 'Each teammate finds one break-room object',
      clue: 'Mug, snack, or water bottle.',
      picture: '☕',
    ),
    MissionDefinition(
      type: MissionType.duel,
      hueName: 'Brand Battle',
      hex: '#2B6CB0',
      objectPrompt: 'Find the most on-brand object in the room',
      clue: 'Two teams race to show their pick.',
      picture: '🎯',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Team Trophy',
      hex: '#D69E2E',
      objectPrompt: 'Pick one object that represents your team culture',
      clue: 'Place it center — group explains why.',
      picture: '🤝',
    ),
  ];

  static const _party = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Loudest Find',
      hex: '#D53F8C',
      objectPrompt: 'Find the loudest object in the room',
      clue: 'Speaker, shaker, or party horn.',
      picture: '🔊',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.combo,
      hueName: 'Disco Duo',
      hex: '#9F7AEA',
      objectPrompt: 'Find something shiny AND something you can drink from',
      clue: 'Tinsel plus cup. LED plus glass.',
      picture: '🪩',
    ),
    MissionDefinition(
      type: MissionType.forge,
      hueName: 'Snack Table Trio',
      hex: '#DD6B20',
      objectPrompt: 'Collect 3 party snacks or drinks from the room',
      clue: 'Chips, cups, candy — hunt the table.',
      picture: '🍿',
    ),
    MissionDefinition(
      type: MissionType.echo,
      hueName: 'Dance Move',
      hex: '#F687B3',
      objectPrompt: 'Sketch a dance move your group would do tonight',
      clue: 'Abstract is fine — group guesses the move.',
      picture: '💃',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Toast Relay',
      hex: '#ED64A6',
      objectPrompt: 'Each player finds one object to cheers with',
      clue: 'Pass device — no spills on the phone!',
      picture: '🥂',
    ),
    MissionDefinition(
      type: MissionType.duel,
      hueName: 'Costume Clash',
      hex: '#B83280',
      objectPrompt: 'Find the most ridiculous party object',
      clue: 'First team to 2 wins.',
      picture: '🎭',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Party MVP',
      hex: '#F6E05E',
      objectPrompt: 'Group vote: best find of the night',
      clue: 'Everyone points at the winner.',
      picture: '👑',
    ),
  ];

  static const _classroom = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Pencil Panic',
      hex: '#2C5282',
      objectPrompt: 'Find something you write or draw with',
      clue: 'Pencil, marker, crayon, or chalk.',
      picture: '✏️',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.texture,
      hueName: 'Backpack Dig',
      hex: '#4A5568',
      objectPrompt: 'Find something bumpy or rough in a backpack',
      clue: 'Zipper, keychain, or textbook cover.',
      picture: '🎒',
    ),
    MissionDefinition(
      type: MissionType.forge,
      hueName: 'Desk Trio',
      hex: '#38B2AC',
      objectPrompt: 'Collect 3 school supplies from desks nearby',
      clue: 'Eraser, ruler, glue — real items.',
      picture: '📐',
    ),
    MissionDefinition(
      type: MissionType.echo,
      hueName: 'Mascot Sketch',
      hex: '#4299E1',
      objectPrompt: 'Sketch your school mascot or a silly teacher face',
      clue: 'Group guesses — keep it kind!',
      picture: '🦁',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Row Relay',
      hex: '#667EEA',
      objectPrompt: 'Each student finds one object from their row',
      clue: 'Pass the device down the line.',
      picture: '🪑',
    ),
    MissionDefinition(
      type: MissionType.duel,
      hueName: 'Recess Race',
      hex: '#48BB78',
      objectPrompt: 'Find something you would bring to recess',
      clue: 'Teams race — tap when ready.',
      picture: '⚽',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Class Champion',
      hex: '#ECC94B',
      objectPrompt: 'Everyone shows their favorite find from class today',
      clue: 'Vote for the funniest object.',
      picture: '🌟',
    ),
  ];

  static const _restaurant = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Menu Mission',
      hex: '#C05621',
      objectPrompt: 'Find a menu, receipt, or order number',
      clue: 'Table tent, QR stand, or paper menu.',
      picture: '📋',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.combo,
      hueName: 'Table Setting',
      hex: '#9C4221',
      objectPrompt: 'Find something metal AND something paper on the table',
      clue: 'Fork plus napkin. Spoon plus receipt.',
      picture: '🍴',
    ),
    MissionDefinition(
      type: MissionType.forge,
      hueName: 'Table Trio',
      hex: '#DD6B20',
      objectPrompt: 'Collect 3 objects currently on your table',
      clue: 'Salt, sauce, coaster — don\'t steal from neighbors!',
      picture: '🍽️',
    ),
    MissionDefinition(
      type: MissionType.echo,
      hueName: 'Chef Sketch',
      hex: '#F6AD55',
      objectPrompt: 'Sketch the dish you wish was on the menu',
      clue: 'Group guesses the food.',
      picture: '👨‍🍳',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Table Hop',
      hex: '#ED8936',
      objectPrompt: 'Each person finds one object at the table',
      clue: 'Pass device clockwise.',
      picture: '🔄',
    ),
    MissionDefinition(
      type: MissionType.duel,
      hueName: 'Tip Jar Duel',
      hex: '#D69E2E',
      objectPrompt: 'Find the most interesting object the staff left nearby',
      clue: 'Teams race — be respectful of staff!',
      picture: '💰',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Table Toast',
      hex: '#F6E05E',
      objectPrompt: 'Everyone holds up their favorite table object',
      clue: 'Cheers — group picks the winner.',
      picture: '🥂',
    ),
  ];

  static const _hotel = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Luggage Lore',
      hex: '#2D3748',
      objectPrompt: 'Find something a traveler would pack',
      clue: 'Charger, toiletry, or key card.',
      picture: '🧳',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.texture,
      hueName: 'Lobby Texture',
      hex: '#718096',
      objectPrompt: 'Find the fanciest texture in the lobby',
      clue: 'Marble, velvet, or polished wood.',
      picture: '✨',
    ),
    MissionDefinition(
      type: MissionType.forge,
      hueName: 'Concierge Trio',
      hex: '#4A5568',
      objectPrompt: 'Collect 3 objects a concierge would recognize',
      clue: 'Key, brochure, pen — hotel-safe only.',
      picture: '🔑',
    ),
    MissionDefinition(
      type: MissionType.echo,
      hueName: 'Suite Sketch',
      hex: '#63B3ED',
      objectPrompt: 'Sketch the view from this window or doorway',
      clue: 'Abstract skyline counts — group guesses.',
      picture: '🌆',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Floor Relay',
      hex: '#805AD5',
      objectPrompt: 'Each player finds one object on this floor',
      clue: 'Pass device — stay in public areas.',
      picture: '🛗',
    ),
    MissionDefinition(
      type: MissionType.duel,
      hueName: 'Bellhop Battle',
      hex: '#B794F4',
      objectPrompt: 'Find the most luxurious object in sight',
      clue: 'Teams race — first to 2 wins.',
      picture: '🛎️',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Lobby Legend',
      hex: '#F6E05E',
      objectPrompt: 'Group vote: best travel find in the room',
      clue: 'Perfect conference icebreaker finale.',
      picture: '🏆',
    ),
  ];
}
