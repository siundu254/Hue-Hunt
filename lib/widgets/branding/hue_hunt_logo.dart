import 'package:flutter/material.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Vector-style logo mark — no external image asset required.
class HueHuntLogo extends StatelessWidget {
  const HueHuntLogo({super.key, this.size = 72, this.showGlow = true});

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(showGlow: showGlow),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.showGlow});

  final bool showGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.42;

    if (showGlow) {
      final glow = Paint()
        ..color = AppColors.accent.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, r * 1.1, glow);
    }

    final ring = Paint()
      ..shader = const SweepGradient(
        colors: [AppColors.primary, AppColors.accent, AppColors.amber, AppColors.primary],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;
    canvas.drawCircle(center, r, ring);

    final core = Paint()..color = AppColors.backgroundDark;
    canvas.drawCircle(center, r * 0.55, core);

    final dotPaint = Paint()..color = AppColors.accent;
    for (var i = 0; i < 3; i++) {
      final dx = center.dx + r * 0.35 * (i == 1 ? 0 : 0.9) * (i == 0 ? -1 : 1);
      final dy = center.dy + r * 0.35 * (i == 1 ? -0.95 : 0.35);
      canvas.drawCircle(Offset(dx, dy), size.width * 0.07, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => false;
}
