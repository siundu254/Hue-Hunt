import 'package:flutter/material.dart';
import 'package:hue_hunt/models/chapter_award.dart';
import 'package:hue_hunt/theme/app_colors.dart';

class ChapterAwardsPanel extends StatelessWidget {
  const ChapterAwardsPanel({super.key, required this.awards});

  final List<ChapterAward> awards;

  @override
  Widget build(BuildContext context) {
    if (awards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Raid Awards',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.treasureYellow),
        ),
        const SizedBox(height: 8),
        ...awards.map((a) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(a.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${a.recipient} — ${a.reason}'),
              ),
            )),
      ],
    );
  }
}
