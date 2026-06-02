import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hue_hunt/services/box_rules_pdf.dart';
import 'package:printing/printing.dart';

class BoxRulesScreen extends StatefulWidget {
  const BoxRulesScreen({super.key});

  @override
  State<BoxRulesScreen> createState() => _BoxRulesScreenState();
}

class _BoxRulesScreenState extends State<BoxRulesScreen> {
  String _markdown = '';
  bool _printing = false;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/box/hunt_hue_box_rules.md').then((s) {
      if (mounted) setState(() => _markdown = s);
    });
  }

  Future<void> _printPdf() async {
    setState(() => _printing = true);
    try {
      final bytes = await BoxRulesPdf.build();
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'Hunt-Hue-Box-Rules',
      );
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  Future<void> _sharePdf() async {
    setState(() => _printing = true);
    try {
      final bytes = await BoxRulesPdf.build();
      await Printing.sharePdf(bytes: bytes, filename: 'Hunt-Hue-Box-Rules.pdf');
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Box rules (printable)'),
        actions: [
          IconButton(
            onPressed: _printing ? null : _printPdf,
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print',
          ),
          IconButton(
            onPressed: _printing ? null : _sharePdf,
            icon: const Icon(Icons.ios_share),
            tooltip: 'Share PDF',
          ),
        ],
      ),
      body: _markdown.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Markdown(
              data: _markdown,
              padding: const EdgeInsets.all(16),
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                h1: Theme.of(context).textTheme.headlineSmall,
                p: const TextStyle(height: 1.45),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _printing ? null : _printPdf,
        icon: _printing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf),
        label: Text(_printing ? 'Preparing…' : 'Print / PDF'),
      ),
    );
  }
}
