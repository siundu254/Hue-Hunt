import 'package:flutter/material.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/services/raid_map_board_assets.dart';
import 'package:hue_hunt/widgets/board/board_layout_painter.dart';

/// Interactive orbit view — drag to yaw/pitch, pinch to zoom. Unity-quality fallback.
class RaidMapOrbitBoard extends StatefulWidget {
  const RaidMapOrbitBoard({
    super.key,
    required this.venue,
    required this.scores,
    this.highlightZone,
    this.chaosAngle = 0,
    this.shimmerPhase = 0,
    this.onTeamTap,
    this.onVaultTap,
  });

  final RaidMapVenueProfile venue;
  final Map<String, int> scores;
  final String? highlightZone;
  final double chaosAngle;
  final double shimmerPhase;
  final ValueChanged<int>? onTeamTap;
  final VoidCallback? onVaultTap;

  @override
  State<RaidMapOrbitBoard> createState() => _RaidMapOrbitBoardState();
}

class _RaidMapOrbitBoardState extends State<RaidMapOrbitBoard> with SingleTickerProviderStateMixin {
  double _yaw = 0.12;
  double _pitch = 0.22;
  double _zoom = 1.0;
  Offset? _dragStart;
  bool _artReady = false;
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _loadArt();
  }

  Future<void> _loadArt() async {
    await RaidMapBoardAssets.instance.ensureLoaded();
    if (mounted) setState(() => _artReady = true);
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final size = Size(c.maxWidth, c.maxHeight);
        return GestureDetector(
          onScaleStart: (d) => _dragStart = d.focalPoint,
          onScaleUpdate: (d) {
            setState(() {
              if (d.pointerCount >= 2) {
                _zoom = (_zoom * d.scale).clamp(0.85, 1.35);
              } else if (_dragStart != null) {
                final delta = d.focalPoint - _dragStart!;
                _yaw += delta.dx * 0.004;
                _pitch = (_pitch + delta.dy * 0.003).clamp(0.08, 0.42);
                _dragStart = d.focalPoint;
              }
            });
          },
          onScaleEnd: (_) => _dragStart = null,
          onTapUp: (d) => _handleTap(d.localPosition, size),
          child: AnimatedBuilder(
            animation: _shimmer,
            builder: (context, _) {
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0016)
                ..translate(0.0, size.height * 0.02)
                ..rotateX(-_pitch)
                ..rotateY(_yaw)
                ..scale(_zoom);
              return Transform(
                alignment: Alignment.center,
                transform: matrix,
                child: CustomPaint(
                  size: size,
                  painter: BoardLayoutPainter(
                    venue: widget.venue,
                    highlightZoneId: widget.highlightZone,
                    teamScores: widget.scores,
                    chaosCompassAngle: widget.chaosAngle,
                    shimmerPhase: _shimmer.value,
                    roomArt: _artReady ? RaidMapBoardAssets.instance.rooms : null,
                    vaultEmblem: _artReady ? RaidMapBoardAssets.instance.vault : null,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleTap(Offset pos, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    if ((pos - Offset(cx, cy)).distance < size.width * 0.16) {
      widget.onVaultTap?.call();
      return;
    }
    final m = size.shortestSide * 0.055;
    final inner = size.shortestSide * 0.21;
    final zones = [
      Rect.fromLTWH(m, m + 14, cx - inner - m, cy - inner * 0.45 - m),
      Rect.fromLTWH(cx + inner, m + 14, size.width - m - cx - inner, cy - inner * 0.45 - m),
      Rect.fromLTWH(m, cy + inner * 0.45, cx - inner - m, size.height - m - 28 - cy - inner * 0.45),
      Rect.fromLTWH(cx + inner, cy + inner * 0.45, size.width - m - cx - inner, size.height - m - 28 - cy - inner * 0.45),
    ];
    for (var i = 0; i < zones.length; i++) {
      if (zones[i].contains(pos)) {
        widget.onTeamTap?.call(i);
        return;
      }
    }
  }
}
