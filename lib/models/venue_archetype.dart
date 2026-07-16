import 'package:flutter/material.dart';

/// Room DNA — Spirit Forge tailors missions to where you're actually standing.
enum VenueArchetype {
  livingRoom,
  office,
  party,
  classroom,
  restaurant,
  hotel,
  hospital,
  museum,
  gym,
  library,
  airport,
  community,
  retail,
  campus,
  seniorLiving,
}

extension VenueArchetypeX on VenueArchetype {
  String get label => switch (this) {
        VenueArchetype.livingRoom => 'Living room',
        VenueArchetype.office => 'Office / retreat',
        VenueArchetype.party => 'Party space',
        VenueArchetype.classroom => 'Classroom',
        VenueArchetype.restaurant => 'Restaurant / café',
        VenueArchetype.hotel => 'Hotel / lobby',
        VenueArchetype.hospital => 'Hospital / care',
        VenueArchetype.museum => 'Museum / gallery',
        VenueArchetype.gym => 'Gym / fitness',
        VenueArchetype.library => 'Public library',
        VenueArchetype.airport => 'Airport / transit',
        VenueArchetype.community => 'Community center',
        VenueArchetype.retail => 'Store / retail',
        VenueArchetype.campus => 'University campus',
        VenueArchetype.seniorLiving => 'Senior living',
      };

  String get emoji => switch (this) {
        VenueArchetype.livingRoom => '🛋️',
        VenueArchetype.office => '💼',
        VenueArchetype.party => '🎉',
        VenueArchetype.classroom => '🏫',
        VenueArchetype.restaurant => '🍽️',
        VenueArchetype.hotel => '🏨',
        VenueArchetype.hospital => '🏥',
        VenueArchetype.museum => '🏛️',
        VenueArchetype.gym => '💪',
        VenueArchetype.library => '📚',
        VenueArchetype.airport => '✈️',
        VenueArchetype.community => '🤝',
        VenueArchetype.retail => '🛍️',
        VenueArchetype.campus => '🎓',
        VenueArchetype.seniorLiving => '🌻',
      };

  IconData get icon => switch (this) {
        VenueArchetype.livingRoom => Icons.weekend_outlined,
        VenueArchetype.office => Icons.business_center_outlined,
        VenueArchetype.party => Icons.celebration_outlined,
        VenueArchetype.classroom => Icons.school_outlined,
        VenueArchetype.restaurant => Icons.restaurant_outlined,
        VenueArchetype.hotel => Icons.hotel_outlined,
        VenueArchetype.hospital => Icons.local_hospital_outlined,
        VenueArchetype.museum => Icons.museum_outlined,
        VenueArchetype.gym => Icons.fitness_center_outlined,
        VenueArchetype.library => Icons.local_library_outlined,
        VenueArchetype.airport => Icons.flight_outlined,
        VenueArchetype.community => Icons.groups_outlined,
        VenueArchetype.retail => Icons.storefront_outlined,
        VenueArchetype.campus => Icons.apartment_outlined,
        VenueArchetype.seniorLiving => Icons.elderly_outlined,
      };

  List<Color> get gradient => switch (this) {
        VenueArchetype.livingRoom => [const Color(0xFF5C4D7D), const Color(0xFFE8B86D)],
        VenueArchetype.office => [const Color(0xFF1B263B), const Color(0xFF415A77)],
        VenueArchetype.party => [const Color(0xFFB5179E), const Color(0xFFF72585)],
        VenueArchetype.classroom => [const Color(0xFF0077B6), const Color(0xFF90E0EF)],
        VenueArchetype.restaurant => [const Color(0xFFBC4749), const Color(0xFFF4A261)],
        VenueArchetype.hotel => [const Color(0xFF2B2D42), const Color(0xFF8D99AE)],
        VenueArchetype.hospital => [const Color(0xFF5B9BD5), const Color(0xFF70AD47)],
        VenueArchetype.museum => [const Color(0xFF6B4E71), const Color(0xFFD4A574)],
        VenueArchetype.gym => [const Color(0xFFE63946), const Color(0xFF457B9D)],
        VenueArchetype.library => [const Color(0xFF2C5282), const Color(0xFF90CDF4)],
        VenueArchetype.airport => [const Color(0xFF1D3557), const Color(0xFFA8DADC)],
        VenueArchetype.community => [const Color(0xFF588157), const Color(0xFFA3B18A)],
        VenueArchetype.retail => [const Color(0xFFE85D04), const Color(0xFFFFC83D)],
        VenueArchetype.campus => [const Color(0xFF5A189A), const Color(0xFFC77DFF)],
        VenueArchetype.seniorLiving => [const Color(0xFF7B6B8A), const Color(0xFFE8C547)],
      };

  String get pitchLine => switch (this) {
        VenueArchetype.livingRoom =>
          'Couch cushions, remotes, and snack bowls become mission targets.',
        VenueArchetype.office =>
          'Desk drawers, badges, and break-room finds — HR-safe, actually fun.',
        VenueArchetype.party =>
          'Drinks, decorations, and loud objects — built for game night energy.',
        VenueArchetype.classroom =>
          'Pencils, posters, and backpacks — teachers run it in 15 minutes.',
        VenueArchetype.restaurant =>
          'Menus, napkins, and table objects — venue sponsors love this.',
        VenueArchetype.hotel =>
          'Luggage tags, lobby art, and room keys — conferences go wild.',
        VenueArchetype.hospital =>
          'Magazines, soft toys, and cheerful objects — calm hunts for wards and waiting rooms.',
        VenueArchetype.museum =>
          'Exhibits, plaques, and gift-shop finds — culture night with zero damage.',
        VenueArchetype.gym =>
          'Weights, mats, and water bottles — look-don\'t-touch equipment hunts.',
        VenueArchetype.library =>
          'Stacks, bookmarks, and quiet corners — whisper-mode scavenger fun.',
        VenueArchetype.airport =>
          'Gates, signage, and carry-ons — layover icebreakers that actually work.',
        VenueArchetype.community =>
          'Hall rentals, kitchens, and craft rooms — youth groups and parish halls.',
        VenueArchetype.retail =>
          'Aisles, displays, and checkout counters — brand activations in-store.',
        VenueArchetype.campus =>
          'Dorms, quads, and student union — orientation week classic.',
        VenueArchetype.seniorLiving =>
          'Common rooms, gardens, and memory boxes — gentle, social, seated-friendly.',
      };
}
