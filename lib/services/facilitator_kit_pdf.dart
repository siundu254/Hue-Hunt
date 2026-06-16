import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// 10-minute host script for Team Kit + Hunt-Hue Box (v1.5).
class FacilitatorKitPdf {
  static Future<Uint8List> build() async {
    final doc = pw.Document(title: 'Hue Hunt Facilitator Kit');
    final sections = [
      _S('Before you start (2 min)', [
        'Split into 2–4 teams. One phone runs Hue Hunt in Team Expedition or Party mode.',
        'Hue Spirit will voice mission intros if sound is on — or read prompts aloud.',
        'Camera stays off; confirms are trust-based group votes.',
      ]),
      _S('Round flow (10–12 min)', [
        '1. Briefing — Spirit welcomes the group; tap Start chapter.',
        '2. Each mission: taxonomy badge shows Object / Texture / Combo / Forge / etc.',
        '3. Pass device if prompted (party/box/kids).',
        '4. Hunt the room → group confirm → Chroma Meter rises.',
        '5. After final mission: certificate + share card (Team mode).',
      ]),
      _S('Tabletop Hunt-Hue Box (zero phones)', [
        'Shuffle 48 cards. Captain draws, teams hunt 60s, group confirms, award points.',
        'First to 10 wins. Optional: one phone as scorekeeper only.',
        'Scan box QR in app to unlock bonus digital chapter.',
      ]),
      _S('HR / facilitator tips', [
        'Keep energy high; missions are 45–90 seconds each.',
        'If stuck, allow one hint — Spirit rewards honesty over speed.',
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
              'Hue Hunt Facilitator Kit',
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
