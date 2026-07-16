import 'package:flutter/material.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:provider/provider.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stickers = context.watch<ExpeditionProvider>().stickers;

    return Scaffold(
      appBar: AppBar(title: const Text('Expedition Journal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Stickers unlock when you complete a chapter in each mode.',
            style: TextStyle(height: 1.35),
          ),
          const SizedBox(height: 16),
          for (final profile in ModeProfile.profiles)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: profile.gradient.first.withValues(alpha: 0.4),
                child: Icon(
                  stickers.contains(profile.mode.name) ? Icons.check : Icons.lock_outline,
                ),
              ),
              title: Text(profile.title),
              subtitle: Text(
                stickers.contains(profile.mode.name)
                    ? 'Region unlocked on Raid Map'
                    : 'Complete a chapter to unlock',
              ),
            ),
        ],
      ),
    );
  }
}
