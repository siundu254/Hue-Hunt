import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/target_hue_card.dart';

class EchoMissionPanel extends StatefulWidget {
  const EchoMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final void Function({required int meterGain, required bool success, int? teamIndex}) onComplete;

  @override
  State<EchoMissionPanel> createState() => _EchoMissionPanelState();
}

class _EchoMissionPanelState extends State<EchoMissionPanel> {
  final List<Offset> _strokes = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('ECHO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.echo, neutral: widget.profile.neutralCopy)),
        const SizedBox(height: 12),
        TargetHueCard(mission: widget.mission, profile: widget.profile),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.4,
          child: GestureDetector(
            onPanUpdate: (d) => setState(() => _strokes.add(d.localPosition)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: CustomPaint(
                painter: _EchoPainter(_strokes, widget.mission.targetColor),
                child: _strokes.isEmpty
                    ? const Center(child: Text('Draw the shade here'))
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Group rates the drawing:'),
        Row(
          children: [
            for (final stars in [1, 2, 3])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilledButton(
                    onPressed: _strokes.isEmpty
                        ? null
                        : () => widget.onComplete(
                              meterGain: stars * 10,
                              success: stars >= 2,
                            ),
                    child: Text('★' * stars),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _EchoPainter extends CustomPainter {
  _EchoPainter(this.points, this.color);
  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EchoPainter oldDelegate) => true;
}
