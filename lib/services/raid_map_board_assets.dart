import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hue_hunt/models/board_prototype_spec.dart';

/// Preloads manufacturer SVG vignettes for The Raid Map (300 DPI print masters).
class RaidMapBoardAssets {
  RaidMapBoardAssets._();
  static final RaidMapBoardAssets instance = RaidMapBoardAssets._();

  static const _roomPaths = {
    BoardCorner.topLeft: 'assets/board/room_living.svg',
    BoardCorner.topRight: 'assets/board/room_study.svg',
    BoardCorner.bottomLeft: 'assets/board/room_kitchen.svg',
    BoardCorner.bottomRight: 'assets/board/room_garden.svg',
  };

  static const vaultPath = 'assets/board/vault_emblem.svg';

  /// SVG viewBox width × height for room vignettes.
  static const roomArtSize = ui.Size(400, 280);
  static const vaultArtSize = ui.Size(200, 200);

  final Map<BoardCorner, ui.Picture> _rooms = {};
  ui.Picture? _vault;
  bool _loaded = false;
  bool _loading = false;

  bool get isLoaded => _loaded;

  ui.Picture? room(BoardCorner corner) => _rooms[corner];
  ui.Picture? get vault => _vault;
  Map<BoardCorner, ui.Picture> get rooms => Map.unmodifiable(_rooms);

  Future<void> ensureLoaded() async {
    if (_loaded || _loading) return;
    _loading = true;
    try {
      for (final entry in _roomPaths.entries) {
        _rooms[entry.key] = await _loadPicture(entry.value);
      }
      _vault = await _loadPicture(vaultPath);
      _loaded = true;
    } finally {
      _loading = false;
    }
  }

  Future<ui.Picture> _loadPicture(String asset) async {
    final raw = await rootBundle.loadString(asset);
    final drawable = await svg.fromSvgString(raw, raw);
    return drawable.toPicture();
  }

  void dispose() {
    for (final pic in _rooms.values) {
      pic.dispose();
    }
    _vault?.dispose();
    _rooms.clear();
    _vault = null;
    _loaded = false;
  }
}
