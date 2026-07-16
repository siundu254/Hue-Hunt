import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Team Expedition completion certificate for HR / L&D (Room Raiders v2.1).
class TeamKitPdf {
  static Future<Uint8List> buildCertificate({
    required String eventTitle,
    required List<String> teamNames,
    required String leadingTeam,
    required int sessionScore,
    required int chromaMeter,
    required DateTime completedAt,
  }) async {
    final doc = pw.Document(title: 'Room Raiders Team Certificate');
    final dateStr =
        '${completedAt.year}-${completedAt.month.toString().padLeft(2, '0')}-${completedAt.day.toString().padLeft(2, '0')}';

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(48),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'Certificate of Team Raid',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Room Raiders · NovaLumina Studio',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 28),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(24),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.orange, width: 2),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'This certifies that the following teams completed',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    eventTitle,
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    'Teams: ${teamNames.join(' · ')}',
                    style: const pw.TextStyle(fontSize: 12),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Leading squad: $leadingTeam',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Session score: $sessionScore · Raid Meter: $chromaMeter%',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Completed: $dateStr · Duration: ~15 minutes',
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
                  ),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Text(
              'Object-led indoor raids · camera-off · secret objectives · pass-device friendly',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
      ),
    );
    return doc.save();
  }
}
