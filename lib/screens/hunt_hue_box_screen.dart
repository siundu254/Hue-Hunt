import 'package:flutter/material.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/screens/board_prototype_screen.dart';
import 'package:hue_hunt/screens/box_card_gallery_screen.dart';
import 'package:hue_hunt/screens/box_rules_screen.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/screens/spirit_forge_screen.dart';
import 'package:hue_hunt/screens/session_setup_screen.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/screens/qr_unlock_screen.dart';
import 'package:hue_hunt/services/facilitator_kit_pdf.dart';
import 'package:hue_hunt/services/unlock_service.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/widgets/board/raid_map_venue_picker.dart';
import 'package:hue_hunt/widgets/branding/hue_hunt_logo.dart';
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
              padding: const EdgeInsets.all(22),
              decoration: RaidUi.heroPanel(),
              child: const Column(
                children: [
                  HueHuntLogo(size: 56),
                  SizedBox(height: 8),
                  Text(
                    'Hunt-Hue Box',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tabletop party game — Room Raiders in a box',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.35),
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
            const _BoxItem(icon: Icons.hourglass_bottom, text: 'Sand timer + Raid Captain guide booklet'),
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
            const SizedBox(height: 20),
            Text('The Raid Map — ${RaidMapVenues.all.length} venues', style: RaidUi.sectionLabel()),
            const SizedBox(height: 8),
            Text(
              'One board, swappable overlays for home, office, school, hospital, and more. Tap a venue to preview.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), height: 1.35),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.55,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: RaidMapVenues.all.length,
              itemBuilder: (context, i) {
                final v = RaidMapVenues.all[i];
                return RaidMapVenueCard(
                  venue: v,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BoardPrototypeScreen(initialVenue: v.id),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const BoardPrototypeScreen()),
              ),
              icon: const Icon(Icons.view_quilt_outlined),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Open full board demo'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showSlidesInfo(context),
              icon: const Icon(Icons.slideshow_outlined),
              label: const Text('Google Slides deck (PPTX + HTML in documents/)'),
            ),
            const SizedBox(height: 8),
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

  void _showSlidesInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('The Raid Map slide deck'),
        content: const Text(
          'In the project documents/ folder:\n\n'
          '• Hunt-Hue-Box-Board-Deck-NovaLumina-FY2026-27.pptx\n'
          '  The Raid Map v2 — upload to Google Drive → Open with Google Slides\n\n'
          '• Hunt-Hue-Box-Board-Deck.html\n'
          '  Browser presentation — arrow keys + F11 fullscreen\n\n'
          'Regenerate: python3 documents/generate_board_deck.py',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it')),
        ],
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
