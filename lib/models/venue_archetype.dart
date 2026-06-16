import 'package:flutter/material.dart';

/// Room DNA — Spirit Forge tailors missions to where you're actually standing.
enum VenueArchetype {
  livingRoom,
  office,
  party,
  classroom,
  restaurant,
  hotel,
}

extension VenueArchetypeX on VenueArchetype {
  String get label => switch (this) {
        VenueArchetype.livingRoom => 'Living room',
        VenueArchetype.office => 'Office / retreat',
        VenueArchetype.party => 'Party space',
        VenueArchetype.classroom => 'Classroom',
        VenueArchetype.restaurant => 'Restaurant / café',
        VenueArchetype.hotel => 'Hotel / lobby',
      };

  String get emoji => switch (this) {
        VenueArchetype.livingRoom => '🛋️',
        VenueArchetype.office => '💼',
        VenueArchetype.party => '🎉',
        VenueArchetype.classroom => '🏫',
        VenueArchetype.restaurant => '🍽️',
        VenueArchetype.hotel => '🏨',
      };

  IconData get icon => switch (this) {
        VenueArchetype.livingRoom => Icons.weekend_outlined,
        VenueArchetype.office => Icons.business_center_outlined,
        VenueArchetype.party => Icons.celebration_outlined,
        VenueArchetype.classroom => Icons.school_outlined,
        VenueArchetype.restaurant => Icons.restaurant_outlined,
        VenueArchetype.hotel => Icons.hotel_outlined,
      };

  List<Color> get gradient => switch (this) {
        VenueArchetype.livingRoom => [const Color(0xFF5C4D7D), const Color(0xFFE8B86D)],
        VenueArchetype.office => [const Color(0xFF1B263B), const Color(0xFF415A77)],
        VenueArchetype.party => [const Color(0xFFB5179E), const Color(0xFFF72585)],
        VenueArchetype.classroom => [const Color(0xFF0077B6), const Color(0xFF90E0EF)],
        VenueArchetype.restaurant => [const Color(0xFFBC4749), const Color(0xFFF4A261)],
        VenueArchetype.hotel => [const Color(0xFF2B2D42), const Color(0xFF8D99AE)],
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
      };
}
