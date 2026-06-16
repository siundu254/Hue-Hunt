import 'package:flutter/material.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/services/facilitator_kit_pdf.dart';
import 'package:hue_hunt/services/share_card_service.dart';
import 'package:hue_hunt/services/team_kit_pdf.dart';
import 'package:hue_hunt/widgets/expedition_share_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ChapterCompletePanel extends StatefulWidget {
  const ChapterCompletePanel({
    super.key,
    required this.score,
    required this.meter,
    required this.modeTitle,
    required this.teams,
    required this.isTeamExpedition,
    required this.onViewMap,
    required this.onDone,
    this.spiritQuote = 'The Chroma Expedition shines brighter!',
  });

  final int score;
  final int meter;
  final String modeTitle;
  final List<TeamConfig> teams;
  final bool isTeamExpedition;
  final VoidCallback onViewMap;
  final VoidCallback onDone;
  final String spiritQuote;

  @override
  State<ChapterCompletePanel> createState() => _ChapterCompletePanelState();
}

class _ChapterCompletePanelState extends State<ChapterCompletePanel> {
  final _shareKey = GlobalKey();

  TeamConfig? get _winner =>
      widget.teams.isEmpty ? null : widget.teams.reduce((a, b) => a.score >= b.score ? a : b);

  Future<void> _sharePng() async {
    final png = await ShareCardService.capturePng(_shareKey);
    if (png == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hue_hunt_expedition.png');
    await file.writeAsBytes(png);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'We finished a Hue Hunt ${widget.modeTitle} chapter!',
      subject: 'Hue Hunt Expedition',
    );
  }

  Future<void> _exportCertificate() async {
    final winner = _winner;
    final bytes = await TeamKitPdf.buildCertificate(
      eventTitle: widget.modeTitle,
      teamNames: widget.teams.map((t) => t.name).toList(),
      leadingTeam: winner?.name ?? 'All teams',
      sessionScore: widget.score,
      chromaMeter: widget.meter,
      completedAt: DateTime.now(),
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'hue_hunt_team_certificate.pdf',
    );
  }

  Future<void> _openFacilitatorKit() async {
    final bytes = await FacilitatorKitPdf.build();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'hue_hunt_facilitator_kit.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final winner = _winner;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Offstage(
          child: RepaintBoundary(
            key: _shareKey,
            child: ExpeditionShareCard(
              modeTitle: widget.modeTitle,
              score: widget.score,
              meter: widget.meter,
              teams: widget.teams,
              spiritQuote: widget.spiritQuote,
            ),
          ),
        ),
        const Text(
          'Chapter complete!',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('${widget.modeTitle} — great hunt, explorers.'),
        const SizedBox(height: 12),
        Text('Session score: ${widget.score} · Chroma Meter: ${widget.meter}%'),
        if (winner != null) ...[
          const SizedBox(height: 12),
          Text(
            'Leading team: ${winner.name} (${winner.score} pts)',
            style: TextStyle(color: Colors.amber.shade200, fontWeight: FontWeight.w600),
          ),
        ],
        if (widget.teams.length > 1) ...[
          const SizedBox(height: 12),
          ...widget.teams.map(
            (t) => ListTile(
              dense: true,
              title: Text(t.name),
              trailing: Text('${t.score} pts'),
            ),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: widget.onViewMap,
          icon: const Icon(Icons.map_outlined),
          label: const Text('View Chroma Map'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _sharePng,
          icon: const Icon(Icons.image_outlined),
          label: const Text('Share expedition card (PNG)'),
        ),
        if (widget.isTeamExpedition) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _exportCertificate,
            icon: const Icon(Icons.workspace_premium_outlined),
            label: const Text('Team Kit certificate (PDF)'),
          ),
        ],
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _openFacilitatorKit,
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('Facilitator script (PDF)'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: widget.onDone, child: const Text('Back to home')),
      ],
    );
  }
}
