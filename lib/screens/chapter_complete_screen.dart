import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/models/chapter_award.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/services/facilitator_kit_pdf.dart';
import 'package:hue_hunt/services/share_card_service.dart';
import 'package:hue_hunt/services/team_kit_pdf.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/widgets/chapter_awards_panel.dart';
import 'package:hue_hunt/widgets/expedition_share_card.dart';
import 'package:hue_hunt/widgets/raid_highlight_share_card.dart';
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
    required this.awards,
    required this.isTeamExpedition,
    required this.onViewMap,
    required this.onDone,
    this.spiritQuote = 'Another room conquered — Raiders move on!',
  });

  final int score;
  final int meter;
  final String modeTitle;
  final List<TeamConfig> teams;
  final List<ChapterAward> awards;
  final bool isTeamExpedition;
  final VoidCallback onViewMap;
  final VoidCallback onDone;
  final String spiritQuote;

  @override
  State<ChapterCompletePanel> createState() => _ChapterCompletePanelState();
}

class _ChapterCompletePanelState extends State<ChapterCompletePanel> {
  final _shareKey = GlobalKey();
  final _mvpKey = GlobalKey();

  TeamConfig? get _winner =>
      widget.teams.isEmpty ? null : widget.teams.reduce((a, b) => a.score >= b.score ? a : b);

  ChapterAward? get _mvpAward =>
      widget.awards.isEmpty ? null : widget.awards.first;

  Future<void> _sharePng(GlobalKey key, String filename, String text) async {
    final png = await ShareCardService.capturePng(key);
    if (png == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(png);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: text,
      subject: AppBranding.productName,
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
      filename: 'room_raiders_team_certificate.pdf',
    );
  }

  Future<void> _openFacilitatorKit() async {
    final bytes = await FacilitatorKitPdf.build();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'room_raiders_facilitator_kit.pdf',
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
        Offstage(
          child: RepaintBoundary(
            key: _mvpKey,
            child: RaidHighlightShareCard(
              modeTitle: widget.modeTitle,
              score: widget.score,
              meter: widget.meter,
              teams: widget.teams,
              mvpAward: _mvpAward,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: RaidUi.heroPanel(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Raid complete!',
                style: RaidUi.title(context),
              ),
              const SizedBox(height: 8),
              Text('${widget.modeTitle} — great hunt, Raiders.'),
              const SizedBox(height: 12),
              Text(
                'Session score: ${widget.score} · Raid Meter: ${widget.meter}%',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
              ),
              if (winner != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Winning team: ${winner.name} (${winner.score} pts)',
                  style: const TextStyle(
                    color: AppColors.treasureYellow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.teams.length > 1) ...[
          const SizedBox(height: 12),
          ...widget.teams.map(
            (t) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: RaidUi.statTile(),
              child: Row(
                children: [
                  Expanded(child: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                  Text('${t.score} pts', style: const TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        ChapterAwardsPanel(awards: widget.awards),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: widget.onViewMap,
          icon: const Icon(Icons.map_outlined),
          label: const Text('View Raid Map'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => _sharePng(
            _shareKey,
            'room_raiders_expedition.png',
            'We finished a ${AppBranding.productName} ${widget.modeTitle} raid!',
          ),
          icon: const Icon(Icons.image_outlined),
          label: const Text('Share expedition card (PNG)'),
        ),
        if (_mvpAward != null) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => _sharePng(
              _mvpKey,
              'room_raiders_mvp.png',
              '${_mvpAward!.recipient} earned ${_mvpAward!.title} in ${AppBranding.productName}!',
            ),
            icon: const Icon(Icons.emoji_events_outlined),
            label: const Text('Share MVP highlight card'),
          ),
        ],
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
