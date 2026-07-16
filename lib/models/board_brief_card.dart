import 'package:flutter/material.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Printed mission brief card — one hunt per card, timer on the face (no lookup).
enum BoardBriefCardType {
  object('OBJECT', Icons.category_outlined, AppColors.adventureOrange, 1.0),
  combo('COMBO', Icons.merge_type, AppColors.mysteryPurple, 1.0),
  texture('TEXTURE', Icons.texture, Color(0xFF4ECDC4), 1.0),
  relay('RELAY', Icons.swap_horiz, AppColors.treasureYellow, 0.35),
  duel('DUEL', Icons.sports_mma, Color(0xFFE85D04), 0.5),
  ritual('RITUAL', Icons.auto_awesome, Color(0xFF81C784), 1.15);

  const BoardBriefCardType(this.label, this.icon, this.color, this.timerFactor);

  final String label;
  final IconData icon;
  final Color color;

  /// Multiplier on venue [RaidMapVenueProfile.raidTimerSeconds].
  final double timerFactor;
}

/// Physical card layout spec for manufacturers.
class BoardBriefCardDesign {
  const BoardBriefCardDesign._();

  static const widthMm = BoardPrototypeSpec.cardWidthMm;
  static const heightMm = BoardPrototypeSpec.cardHeightMm;

  static const faceLayout = '''
FRONT — mission brief (read aloud from Spotlight)
• Type strip (8mm): color + OBJECT / COMBO / TEXTURE / RELAY / DUEL / RITUAL
• Mission prompt (center, 14pt min): object-led hunt text
• Timer badge (embossed, bottom-left): ⏱ {seconds}s — no rulebook lookup
• Venue pip (bottom-right): overlay color dot + deck code (e.g. HHB-HOME-07)

BACK
• Venue band (top 18%): overlay art color + venue name
• Spot-UV raid icon (center)
• Card index + tier (bottom): 07/48 · CORE''';

  static const expansionPackCount = 12;
  static const coreDeckCount = 48;

  static int timerFor(RaidMapVenueProfile venue, BoardBriefCardType type) {
    final base = venue.raidTimerSeconds;
    final scaled = (base * type.timerFactor).round();
    return scaled.clamp(15, 120);
  }

  static String deckCode(RaidMapVenueProfile venue, int index) {
    final sku = venue.packSku ?? 'HHB-CORE';
    final prefix = sku.replaceAll('HHB-', '').split('-').first;
    return 'HHB-${prefix.toUpperCase()}-${index.toString().padLeft(2, '0')}';
  }
}
