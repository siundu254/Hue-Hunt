import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:hue_hunt/models/board_prototype_spec.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';

/// Printable manufacturer / market-research brief for the Hunt-Hue Box board.
class BoardPrototypePdf {
  static Future<Uint8List> build({
    RaidMapVenueId venue = BoardPrototypeSpec.defaultVenue,
    Map<String, int> teamScores = const {},
    int activePhase = 1,
  }) async {
    final profile = BoardPrototypeSpec.venueProfile(venue);
    final teams = profile.teams;
    final doc = pw.Document(title: 'Hunt-Hue Box Board Prototype');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          _header(),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: '${profile.title} — venue overlay'),
          pw.SizedBox(height: 8),
          pw.Text(
            'Quad-fold Raid Map, ${BoardPrototypeSpec.boardWidthMm}×${BoardPrototypeSpec.boardHeightMm}mm. '
            'Universal vault + raid beams; ${profile.title} overlay swaps the four quadrants.',
            style: const pw.TextStyle(fontSize: 10, lineSpacing: 3),
          ),
          pw.SizedBox(height: 12),
          _boardDiagram(),
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.Header(level: 1, text: 'Center zone layout'),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1.5),
            },
            children: [
              _tableRow(['Zone', 'Purpose', 'Size (mm)'], header: true),
              for (final z in BoardPrototypeSpec.zones)
                _tableRow([z.label, z.subtitle, '${z.widthMm}×${z.heightMm}']),
            ],
          ),
        ],
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Header(level: 1, text: 'Turn structure'),
          pw.SizedBox(height: 8),
          for (final phase in BoardPrototypeSpec.turnPhases)
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: phase.step == activePhase ? PdfColors.orange : PdfColors.grey400,
                  width: phase.step == activePhase ? 1.5 : 0.5,
                ),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${phase.step}. ${phase.title}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(phase.body, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
                ],
              ),
            ),
          pw.SizedBox(height: 12),
          pw.Header(level: 1, text: 'Quadrants & raid beams'),
          pw.SizedBox(height: 6),
          for (final team in teams)
            pw.Bullet(
              text:
                  '${team.roomEmoji} ${team.roomName} — Team ${team.name}: raid beam to vault. '
                  'Demo score: ${teamScores[team.id] ?? 0}/${BoardPrototypeSpec.winScore}.',
            ),
          pw.SizedBox(height: 8),
          pw.Header(level: 1, text: 'Venue expansion library'),
          pw.SizedBox(height: 6),
          for (final v in RaidMapVenues.all)
            pw.Bullet(text: '${v.emoji} ${v.title}: ${v.useCase}'),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: 'Card deck mix (${BoardPrototypeSpec.totalCards} cards)'),
          pw.SizedBox(height: 6),
          for (final mix in BoardPrototypeSpec.cardMix)
            pw.Bullet(text: '${mix.label}: ${mix.count} cards'),
          pw.SizedBox(height: 8),
          pw.Text(
            'Cards: poker size ${BoardPrototypeSpec.cardWidthMm}×${BoardPrototypeSpec.cardHeightMm}mm, 350gsm. '
            'Object-led missions only — no colour hunts.',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Header(level: 1, text: 'Bill of materials'),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(0.6),
              1: const pw.FlexColumnWidth(2.5),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              _tableRow(['Qty', 'Component', 'Spec'], header: true),
              for (final c in BoardPrototypeSpec.components) _tableRow([c.qty, c.name, c.spec]),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Header(level: 1, text: 'Prototype deliverables (market research)'),
          pw.SizedBox(height: 6),
          pw.Bullet(text: '1× full-color Raid Control Mat proof'),
          pw.Bullet(text: '1× 48-card mission deck proof sheet'),
          pw.Bullet(text: '1× retail box flat with insert tray'),
          pw.Bullet(text: '1× sand timer + 4 team tokens'),
          pw.SizedBox(height: 12),
          pw.Header(level: 1, text: 'Production notes'),
          pw.SizedBox(height: 6),
          for (final note in BoardPrototypeSpec.prototypeNotes)
            pw.Bullet(text: note),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Text(
            'NovaLumina Studio · Room Raiders / Hunt-Hue Box · ${BoardPrototypeSpec.version}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.Text(
            'Companion app: Room Raiders (free scorekeeper + QR bonus missions)',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _header() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Hunt-Hue Box — Board Prototype Brief',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          BoardPrototypeSpec.version,
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.TableRow _tableRow(List<String> cells, {bool header = false}) {
    final style = pw.TextStyle(
      fontSize: header ? 10 : 9,
      fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.TableRow(
      children: cells
          .map(
            (c) => pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(c, style: style),
            ),
          )
          .toList(),
    );
  }

  static pw.Widget _boardDiagram() {
    return pw.Container(
      height: 280,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.orange, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey900,
      ),
      child: pw.Stack(
        children: [
          // Fold cross
          pw.Positioned(
            left: 199,
            top: 0,
            bottom: 0,
            child: pw.Container(width: 1, color: PdfColors.grey700),
          ),
          pw.Positioned(
            left: 0,
            right: 0,
            top: 139,
            child: pw.Container(height: 1, color: PdfColors.grey700),
          ),
          // Team camps
          _campBox(12, 12, 'AURORA', PdfColors.orange),
          _campBox(318, 12, 'EMBER', PdfColors.orange),
          _campBox(12, 188, 'TIDE', PdfColors.teal),
          _campBox(318, 188, 'FERN', PdfColors.green),
          // Command center
          pw.Positioned(
            left: 100,
            top: 80,
            child: pw.Container(
              width: 200,
              height: 120,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.purple, width: 1.5),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'RAID COMMAND CENTER',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.amber,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _cardSlot('DRAW'),
                      _cardSlot('ACTIVE'),
                      _cardSlot('DISCARD'),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 36,
                        height: 36,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey500),
                          shape: pw.BoxShape.circle,
                        ),
                        alignment: pw.Alignment.center,
                        child: pw.Text('⏱', style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(width: 12),
                      _cardSlot('CHAOS'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          pw.Positioned(
            left: 150,
            bottom: 8,
            child: pw.Text(
              '${BoardPrototypeSpec.boardWidthMm}×${BoardPrototypeSpec.boardHeightMm} mm',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _campBox(double left, double top, String label, PdfColor color) {
    return pw.Positioned(
      left: left,
      top: top,
      child: pw.Container(
        width: 110,
        height: 70,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 1.5),
          borderRadius: pw.BorderRadius.circular(6),
          color: PdfColors.grey800,
        ),
        padding: const pw.EdgeInsets.all(6),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: color)),
            pw.SizedBox(height: 4),
            pw.Text('Score 0→10', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey400)),
            pw.SizedBox(height: 6),
            pw.Container(
              width: 14,
              height: 14,
              decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _cardSlot(String label) {
    return pw.Column(
      children: [
        pw.Container(
          width: 36,
          height: 50,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey500),
            borderRadius: pw.BorderRadius.circular(3),
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(label, style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey400)),
      ],
    );
  }
}
