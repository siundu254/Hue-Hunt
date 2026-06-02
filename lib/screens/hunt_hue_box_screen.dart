import 'package:flutter/material.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/screens/box_card_gallery_screen.dart';
import 'package:hue_hunt/screens/box_rules_screen.dart';
import 'package:hue_hunt/screens/session_setup_screen.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';

/// Retail Hunt-Hue Box companion — device-optional tabletop play.
class HuntHueBoxScreen extends StatefulWidget {
  const HuntHueBoxScreen({super.key});

  @override
  State<HuntHueBoxScreen> createState() => _HuntHueBoxScreenState();
}

class _HuntHueBoxScreenState extends State<HuntHueBoxScreen> {
  String _tagline = '';
  int _cardCount = 0;

  final _repo = MissionRepository();

  @override
  void initState() {
    super.initState();
    _repo.allBoxCards().then((_) {
      if (!mounted) return;
      setState(() {
        _tagline = _repo.boxTagline;
        _cardCount = _repo.boxCardCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.huntHueBox)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE85D04), Color(0xFFF48C06), Color(0xFFFAA307)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text('📦', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 8),
                  Text(
                    'Hunt-Hue Box',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tabletop party game — Monopoly meets I Spy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(_tagline.isEmpty ? 'Loading…' : _tagline, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 16),
            Text(l.whatsInside, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _BoxItem(
              icon: Icons.style,
              text: l.boxCardsCount(_cardCount),
            ),
            const _BoxItem(icon: Icons.hourglass_bottom, text: 'Sand timer + Hue Spirit guide booklet'),
            const _BoxItem(icon: Icons.groups, text: 'Team tokens for 4 squads'),
            const _BoxItem(icon: Icons.qr_code, text: 'QR unlocks bonus digital chapters in the app'),
            const SizedBox(height: 20),
            const Text('How to play without phones', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              '1. Split into teams · 2. Draw a mission card · 3. Hunt the room · '
              '4. Confirm as a group · 5. First team to 10 points wins.\n\n'
              'Optional: one phone runs Party Mission as live scorekeeper.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _startBoxSession(context, deviceOptional: true),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Play with box + app scorekeeper'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const BoxRulesScreen()),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Printable rules (PDF)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const BoxCardGalleryScreen()),
              ),
              icon: const Icon(Icons.grid_view),
              label: const Text('View all box cards (print layout)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _showPhysicalRules(context),
              child: const Text('Quick tabletop tips'),
            ),
          ],
        ),
      ),
    );
  }

  void _startBoxSession(BuildContext context, {required bool deviceOptional}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SessionSetupScreen(
          mode: SessionMode.party,
          playSource: PlaySource.huntHueBox,
        ),
      ),
    );
  }

  void _showPhysicalRules(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tabletop-only'),
        content: const Text(
          'Use physical cards and team tokens only. Track points with pen and paper. '
          'Scan the box QR when you want bonus digital missions.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it')),
        ],
      ),
    );
  }
}

class _BoxItem extends StatelessWidget {
  const _BoxItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.amber.shade200),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
