import 'package:flutter/material.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/screens/box_card_gallery_screen.dart';
import 'package:hue_hunt/screens/box_rules_screen.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/screens/spirit_forge_screen.dart';
import 'package:hue_hunt/screens/session_setup_screen.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/screens/qr_unlock_screen.dart';
import 'package:hue_hunt/services/facilitator_kit_pdf.dart';
import 'package:hue_hunt/services/unlock_service.dart';
import 'package:printing/printing.dart';

/// Retail Hunt-Hue Box companion — device-optional tabletop play.
class HuntHueBoxScreen extends StatefulWidget {
  const HuntHueBoxScreen({super.key});

  @override
  State<HuntHueBoxScreen> createState() => _HuntHueBoxScreenState();
}

class _HuntHueBoxScreenState extends State<HuntHueBoxScreen> {
  String _tagline = '';
  int _cardCount = 0;
  bool _bonusUnlocked = false;

  final _repo = MissionRepository();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _repo.allBoxCards();
    final unlocked = await UnlockService.isBonusChapterUnlocked();
    if (!mounted) return;
    setState(() {
      _tagline = _repo.boxTagline;
      _cardCount = _repo.boxCardCount;
      _bonusUnlocked = unlocked;
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
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SpiritForgeScreen(
                    initialFormat: ExpeditionFormat.huntHueBox,
                  ),
                ),
              ),
              icon: const Icon(Icons.auto_awesome),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Spirit Forge with Hunt-Hue Box'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _startBoxSession(context, deviceOptional: true),
              child: const Text('Classic box scorekeeper (no forge)'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final ok = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(builder: (_) => const QrUnlockScreen()),
                );
                if (ok == true) _load();
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(_bonusUnlocked ? 'Bonus chapter unlocked ✓' : 'Scan box QR'),
            ),
            if (_bonusUnlocked) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => _startBonusChapter(context),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Play Spirit Expedition bonus'),
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final bytes = await FacilitatorKitPdf.build();
                await Printing.sharePdf(
                  bytes: bytes,
                  filename: 'hue_hunt_facilitator_kit.pdf',
                );
              },
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Facilitator kit (PDF)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.campaign_outlined),
              label: const Text('Pre-order Hunt-Hue Box — coming to Gamefound'),
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

  void _startBonusChapter(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SessionSetupScreen(
          mode: SessionMode.family,
          playSource: PlaySource.bonusChapter,
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
