import 'package:flutter/material.dart';
import 'package:hue_hunt/l10n/mode_l10n.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:provider/provider.dart';

class ChromaMapScreen extends StatelessWidget {
  const ChromaMapScreen({super.key, this.highlight = SessionMode.family});

  final SessionMode highlight;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final savedNodes = context.watch<ExpeditionProvider>().mapNodes;
    final regions = ModeProfile.profiles;
    final unlockedCount = savedNodes.length;

    return Scaffold(
      appBar: AppBar(title: Text(l.chromaMap)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            unlockedCount == 0 ? l.chromaMapEmpty : l.chromaMapProgress(unlockedCount),
            style: const TextStyle(height: 1.35),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _MapPainter(
                unlocked: unlockedCount.clamp(0, 5),
                highlight: highlight,
              ),
              child: Center(
                child: Text(
                  l.chromaMapRegions(unlockedCount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (final profile in regions)
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: profile.gradient),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(profile.icon, color: Colors.white),
              ),
              title: Text(profile.localizedTitle(l)),
              subtitle: Text(profile.localizedSubtitle(l)),
              trailing: Icon(
                savedNodes.any((n) => n.contains(profile.mode.name))
                    ? Icons.check_circle
                    : Icons.lock_outline,
                color: savedNodes.any((n) => n.contains(profile.mode.name))
                    ? Colors.greenAccent
                    : Colors.white38,
              ),
            ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.unlocked, required this.highlight});

  final int unlocked;
  final SessionMode highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final nodes = [
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.45, size.height * 0.25),
      Offset(size.width * 0.7, size.height * 0.45),
      Offset(size.width * 0.55, size.height * 0.75),
      Offset(size.width * 0.3, size.height * 0.2),
    ];
    for (var i = 0; i < nodes.length; i++) {
      paint.color = i < unlocked ? Colors.cyan.withValues(alpha: 0.85) : Colors.white24;
      canvas.drawCircle(nodes[i], 14, paint);
      if (i > 0) {
        final line = Paint()
          ..color = Colors.white24
          ..strokeWidth = 2;
        canvas.drawLine(nodes[i - 1], nodes[i], line);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => true;
}
