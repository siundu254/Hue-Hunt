import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Generates a print-ready Hunt-Hue Box rules PDF for retail / playgroups.
class BoxRulesPdf {
  static Future<Uint8List> build() async {
    final doc = pw.Document(title: 'Hunt-Hue Box Rules');
    final body = _sections
        .expand((s) => [
              pw.Header(level: 1, text: s.title),
              pw.SizedBox(height: 6),
              pw.Text(s.body, style: const pw.TextStyle(fontSize: 11, lineSpacing: 4)),
              pw.SizedBox(height: 14),
            ])
        .toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Hunt-Hue Box',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              'Official tabletop rules · NovaLumina Studio',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
          ),
          pw.SizedBox(height: 20),
          ...body,
          pw.Divider(),
          pw.Text(
            'Companion app: Hue Hunt — scan QR on box for digital scorekeeper & bonus missions.',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    return doc.save();
  }
}

class _Section {
  const _Section(this.title, this.body);
  final String title;
  final String body;
}

const _sections = [
  _Section(
    'Goal',
    'Be the first team to 10 points (or highest score when time runs out). '
    '2–4 teams · Ages 8+ · 15–25 minutes · Device optional.',
  ),
  _Section(
    'Setup',
    'Split into teams. Shuffle the 48-card mission deck face-down. '
    'Each team places a token at 0 on the score track. '
    'Pick a Mission Captain to draw (rotate each round).',
  ),
  _Section(
    'Turn structure',
    '1. Draw — Captain reads the card aloud.\n'
    '2. Hunt — Teams search the room (60s for most cards; relay uses 15s per player).\n'
    '3. Confirm — Show finds; group agrees if it matches (trust-based).\n'
    '4. Score — Award points; pass deck to next captain.',
  ),
  _Section(
    'Card types',
    'Colour: match the hue in the room.\n'
    'Object: find the described thing.\n'
    'Texture: find by feel (soft, rough, cold…).\n'
    'Combo: two constraints (e.g. red AND round).\n'
    'Relay: each player adds one find.\n'
    'Duel: teams race; winner takes points.\n'
    'Ritual: group finale — glow hunt (+2 if all succeed).',
  ),
  _Section(
    'Scoring',
    'Successful hunt: 1 pt · Exceptional match: +1 bonus · Relay all-in: 2 pts · '
    'Duel win: 2 pts · Ritual: 2 pts · Rematch success: 1 pt.',
  ),
  _Section(
    'Optional app',
    'One phone may run Hunt-Hue Box mode in the Hue Hunt app as scorekeeper. '
    'No camera required. QR on box unlocks bonus digital cards.',
  ),
  _Section(
    'Win',
    'First team to 10 points wins. Ties: sudden-death duel card.',
  ),
];
