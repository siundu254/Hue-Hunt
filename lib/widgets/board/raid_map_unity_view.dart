import 'package:flutter/material.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/services/unity_board_bridge.dart';
import 'package:hue_hunt/widgets/board/raid_map_orbit_board.dart';

/// 3D board view — Unity when embedded ([UnityBoardBridge.useUnity]), else interactive orbit painter.
class RaidMapUnityView extends StatefulWidget {
  const RaidMapUnityView({
    super.key,
    required this.venue,
    required this.scores,
    this.highlightZone,
    this.chaosAngle = 0,
    this.onTeamTap,
    this.onVaultTap,
  });

  final RaidMapVenueProfile venue;
  final Map<String, int> scores;
  final String? highlightZone;
  final double chaosAngle;
  final ValueChanged<int>? onTeamTap;
  final VoidCallback? onVaultTap;

  @override
  State<RaidMapUnityView> createState() => _RaidMapUnityViewState();
}

class _RaidMapUnityViewState extends State<RaidMapUnityView> {
  @override
  void initState() {
    super.initState();
    UnityBoardBridge.onUnityMessage = _onUnityMessage;
    UnityBoardBridge.loadVenue(widget.venue);
    UnityBoardBridge.setScores(widget.scores);
  }

  @override
  void didUpdateWidget(RaidMapUnityView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.venue.id != widget.venue.id) {
      UnityBoardBridge.loadVenue(widget.venue);
    }
    if (oldWidget.scores != widget.scores) {
      UnityBoardBridge.setScores(widget.scores);
    }
  }

  @override
  void dispose() {
    if (UnityBoardBridge.onUnityMessage == _onUnityMessage) {
      UnityBoardBridge.onUnityMessage = null;
    }
    UnityBoardBridge.detachController();
    super.dispose();
  }

  void _onUnityMessage(String event, Map<String, dynamic> payload) {
    switch (event) {
      case 'cornerTapped':
        final i = payload['teamIndex'];
        if (i is int) widget.onTeamTap?.call(i);
      case 'vaultTapped':
        widget.onVaultTap?.call();
      case 'ready':
        UnityBoardBridge.loadVenue(widget.venue);
        UnityBoardBridge.setScores(widget.scores);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UnityBoardBridge.isAvailable) {
      // Wire RaidMapUnityNative.embed — see raid_map_unity_native.dart
      return const Center(
        child: Text('Unity export linked — uncomment RaidMapUnityNative.embed'),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        RaidMapOrbitBoard(
          venue: widget.venue,
          scores: widget.scores,
          highlightZone: widget.highlightZone,
          chaosAngle: widget.chaosAngle,
          onTeamTap: widget.onTeamTap,
          onVaultTap: widget.onVaultTap,
        ),
        Positioned(
          left: 8,
          bottom: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'ORBIT 3D · drag to rotate',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
