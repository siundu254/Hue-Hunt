import 'package:flutter/material.dart';

class ChromaMeterBar extends StatelessWidget {
  const ChromaMeterBar({super.key, required this.value, this.streak});

  final int value;
  final int? streak;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chroma Meter', style: TextStyle(fontWeight: FontWeight.w600)),
            if (streak != null && streak! > 0)
              Text('Streak ×$streak', style: TextStyle(color: Colors.amber.shade300)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 12,
            backgroundColor: Colors.white12,
            color: Color.lerp(Colors.cyan, Colors.pink, value / 100),
          ),
        ),
      ],
    );
  }
}
