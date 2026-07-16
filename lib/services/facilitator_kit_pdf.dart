import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// 10-minute host script for Team Kit + Hunt-Hue Box (Room Raiders v2.1).
class FacilitatorKitPdf {
  static Future<Uint8List> build() async {
    final doc = pw.Document(title: 'Room Raiders Facilitator Kit');
    final sections = [
      _S('Before you start (2 min)', [
        'Split into 2–4 teams. One phone runs Room Raiders in Team Expedition or Party mode.',
        'Raid Captain voices mission intros if sound is on — or read prompts aloud.',
        'Camera stays off; confirms are trust-based group votes.',
        'Each player gets a secret objective — only visible on their pass-device turn.',
      ]),
      _S('Round flow (10–12 min)', [
        '1. Briefing — Raid Captain welcomes the group; tap Start chapter.',
        '2. Each mission: taxonomy badge shows Object / Texture / Combo / Forge / etc.',
        '3. Pass device if prompted; reveal secret objectives privately.',
        '4. Hunt the room → sudden death may fire → group confirm → Raid Meter rises.',
        '5. Mission 2+: chaos twist banner. Watch for decoy missions (0 pts).',
        '6. After final mission: Raid Awards + certificate + share cards (Team mode).',
      ]),
      _S('Tabletop Hunt-Hue Box (zero phones)', [
        'Shuffle 48 object-led cards. Captain draws, teams hunt 60s, group confirms, award points.',
        'First to 10 wins. Optional: one phone as Room Raiders scorekeeper only.',
        'Scan box QR in app to unlock bonus digital chapter.',
      ]),
      _S('HR / facilitator tips', [
        'Missions are object/texture/combo only — never colour hunts.',
        'Keep energy high; sudden-death timers add adrenaline without elimination.',
        'Export Team certificate PDF after chapter for L&D records.',
        'Pilot pricing: Team Kit USD 199/event — hello@novaluminastudio.com',
      ]),
    ];

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Room Raiders Facilitator Kit',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              '10-minute host script · NovaLumina Studio',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
            ),
          ),
          pw.SizedBox(height: 20),
          ...sections.expand((s) => [
            pw.Header(level: 1, text: s.title),
            ...s.lines.map((l) => pw.Bullet(text: l)),
            pw.SizedBox(height: 12),
          ]),
        ],
      ),
    );
    return doc.save();
  }
}

class _S {
  const _S(this.title, this.lines);
  final String title;
  final List<String> lines;
}
