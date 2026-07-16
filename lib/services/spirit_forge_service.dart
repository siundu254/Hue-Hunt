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
        funFact: 'Forged live by the Raid Captain for this exact room.',
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
    final deck = List<MissionDefinition>.from(pool);
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
        VenueArchetype.hospital => _hospital,
        VenueArchetype.museum => _museum,
        VenueArchetype.gym => _gym,
        VenueArchetype.library => _library,
        VenueArchetype.airport => _airport,
        VenueArchetype.community => _community,
        VenueArchetype.retail => _retail,
        VenueArchetype.campus => _campus,
        VenueArchetype.seniorLiving => _seniorLiving,
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
      hueName: 'Pet Echo',
      hex: '#F6AD55',
      objectPrompt: 'Find a real object a pet would steal',
      clue: 'No drawing: hold up the object and let teammates guess.',
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
      hueName: 'Whiteboard Echo',
      hex: '#805AD5',
      objectPrompt: 'Find an object that captures your worst meeting mood',
      clue: 'No drawing: show the object and teammates guess the vibe.',
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
      objectPrompt: "Find an object that represents tonight's dance move",
      clue: 'No drawing: reveal your object and let the group guess the move.',
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
      objectPrompt: 'Find something you write with',
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
      hueName: 'Mascot Echo',
      hex: '#4299E1',
      objectPrompt: 'Find an object that could represent your school mascot',
      clue: 'No drawing: show your object and classmates guess the mascot.',
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
      hueName: 'Chef Echo',
      hex: '#F6AD55',
      objectPrompt: 'Find an object that represents your dream menu dish',
      clue: 'No drawing: reveal your object and group guesses the food.',
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
      hueName: 'Suite Echo',
      hex: '#63B3ED',
      objectPrompt: 'Find an object that captures the vibe of this hotel view',
      clue: 'No drawing: teammates guess the view from your object.',
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

  static const _hospital = [
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.texture,
      hueName: 'Soft Touch',
      hex: '#5B9BD5',
      objectPrompt: 'Find something soft that comforts you',
      clue: 'Blanket, plush toy, or cushion — gentle only.',
      picture: '🧸',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Cheerful Find',
      hex: '#70AD47',
      objectPrompt: 'Find something that makes you smile',
      clue: 'Photo, magazine, or colorful object.',
      picture: '😊',
    ),
    MissionDefinition(
      type: MissionType.hunt,
      huntCategory: HuntCategory.object,
      hueName: 'Waiting Room Read',
      hex: '#4A90A4',
      objectPrompt: 'Find something you can read',
      clue: 'Book, pamphlet, or sign — no clinical charts.',
      picture: '📖',
    ),
    MissionDefinition(
      type: MissionType.relay,
      hueName: 'Calm Relay',
      hex: '#90E0EF',
      objectPrompt: 'Each player finds one calming object',
      clue: 'Walk, do not run. Facilitator approves each find.',
      picture: '🧘',
    ),
    MissionDefinition(
      type: MissionType.ritual,
      hueName: 'Care Circle',
      hex: '#F6E05E',
      objectPrompt: 'Group shares one object that represents hope',
      clue: 'Perfect for waiting rooms and wellness groups.',
      picture: '💛',
    ),
  ];

  static const _museum = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Framed', hex: '#6B4E71', objectPrompt: 'Find something in a frame', clue: 'Art, photo, or display — look only.', picture: '🖼️'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.combo, hueName: 'Ancient', hex: '#D4A574', objectPrompt: 'Find something older than you', clue: 'Plaque, artifact label, or history.', picture: '🏛️'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.texture, hueName: 'Marble Touch', hex: '#8B7355', objectPrompt: 'Find something smooth and cool', clue: 'Stone, metal, or glass case.', picture: '✨'),
    MissionDefinition(type: MissionType.duel, hueName: 'Curator Duel', hex: '#9F7AEA', objectPrompt: 'Teams race to find the most interesting exhibit label', clue: 'Read it aloud — judges pick winner.', picture: '🏆'),
  ];

  static const _gym = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Hydration', hex: '#457B9D', objectPrompt: 'Find something you drink from', clue: 'Bottle, fountain, or shaker.', picture: '💧'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.texture, hueName: 'Foam Feel', hex: '#E63946', objectPrompt: 'Find something rubbery or foamy', clue: 'Mat, band, or roller — do not move it.', picture: '🧘'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.combo, hueName: 'Rep Combo', hex: '#1D3557', objectPrompt: 'Find something round AND heavy-looking', clue: 'Point only — no lifting.', picture: '🏋️'),
    MissionDefinition(type: MissionType.relay, hueName: 'Lap Relay', hex: '#A8DADC', objectPrompt: 'Each player points at one piece of equipment', clue: 'Stay in your lane — no blocking.', picture: '🏃'),
  ];

  static const _library = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Bookmark Hunt', hex: '#2C5282', objectPrompt: 'Find a bookmark or page holder', clue: 'Whisper when you find it.', picture: '🔖'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'ISBN', hex: '#4A5568', objectPrompt: 'Find something with an ISBN or barcode', clue: 'Book back cover counts.', picture: '📚'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.texture, hueName: 'Paper Feel', hex: '#90CDF4', objectPrompt: 'Find something rough or crinkly', clue: 'Paper, card, or dust jacket.', picture: '📄'),
    MissionDefinition(type: MissionType.ritual, hueName: 'Quiet Vote', hex: '#63B3ED', objectPrompt: 'Group picks the most interesting title spine', clue: 'Library-silent finger voting.', picture: '🤫'),
  ];

  static const _airport = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Destination', hex: '#1D3557', objectPrompt: 'Find a sign with a city name', clue: 'Departures board or poster.', picture: '✈️'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Rolling', hex: '#A8DADC', objectPrompt: 'Find something with wheels', clue: 'Luggage, cart, or stroller.', picture: '🧳'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.combo, hueName: 'Travel Combo', hex: '#457B9D', objectPrompt: 'Something portable AND zippered', clue: 'Bag, pouch, or case.', picture: '💼'),
    MissionDefinition(type: MissionType.duel, hueName: 'Gate Rush', hex: '#E63946', objectPrompt: 'First team to find a gate number wins', clue: 'Call it out — no sprinting.', picture: '🛫'),
  ];

  static const _community = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Handmade', hex: '#588157', objectPrompt: 'Find something handmade', clue: 'Craft, quilt, or poster.', picture: '🎨'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Donation', hex: '#A3B18A', objectPrompt: 'Find something donated or shared', clue: 'Food drive, toy bin, or pantry.', picture: '🤝'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.combo, hueName: 'Folded Paper', hex: '#6B8E23', objectPrompt: 'Paper AND folded', clue: 'Flyer, program, or origami.', picture: '📄'),
    MissionDefinition(type: MissionType.ritual, hueName: 'Circle Share', hex: '#F6E05E', objectPrompt: 'Each person holds up one community object', clue: 'Great for youth group opener.', picture: '🎪'),
  ];

  static const _retail = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'On Sale', hex: '#E85D04', objectPrompt: 'Find a sale sign or tag', clue: 'Red tag, sticker, or banner.', picture: '🏷️'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Branded', hex: '#FFC83D', objectPrompt: 'Find something with the store logo', clue: 'Bag, receipt, or display.', picture: '🛍️'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.texture, hueName: 'Display Shine', hex: '#BC4749', objectPrompt: 'Find the shiniest thing on display', clue: 'Point only — no touching stock.', picture: '✨'),
    MissionDefinition(type: MissionType.duel, hueName: 'Aisle Race', hex: '#F4A261', objectPrompt: 'Teams race to find a checkout item first', clue: 'First to call wins — stay in aisles.', picture: '🛒'),
  ];

  static const _campus = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Campus Logo', hex: '#5A189A', objectPrompt: 'Find something with school branding', clue: 'Shirt, mug, or poster.', picture: '🎓'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Lanyard', hex: '#C77DFF', objectPrompt: 'Find an ID or lanyard', clue: 'Yours or a friend\'s — with permission.', picture: '🪪'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.combo, hueName: 'Event Poster', hex: '#4ECDC4', objectPrompt: 'Paper AND mentions a date', clue: 'Bulletin board classic.', picture: '📌'),
    MissionDefinition(type: MissionType.relay, hueName: 'Quad Relay', hex: '#588157', objectPrompt: 'Each player finds one outdoor campus object', clue: 'Stay on paths — no lawns if forbidden.', picture: '🌳'),
  ];

  static const _seniorLiving = [
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Memory', hex: '#E8C547', objectPrompt: 'Find something that sparks a memory', clue: 'Photo, ornament, or keepsake.', picture: '💛'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.texture, hueName: 'Cozy', hex: '#7B6B8A', objectPrompt: 'Find the softest thing nearby', clue: 'Blanket, shawl, or cushion.', picture: '🧶'),
    MissionDefinition(type: MissionType.hunt, huntCategory: HuntCategory.object, hueName: 'Craft', hex: '#5B9BD5', objectPrompt: 'Find something made by hand', clue: 'Knitting, puzzle, or craft project.', picture: '🎲'),
    MissionDefinition(type: MissionType.ritual, hueName: 'Story Circle', hex: '#F6E05E', objectPrompt: 'Each person shares one object and a short story', clue: 'Seated, unhurried, facilitator guides.', picture: '🌻'),
  ];
}
