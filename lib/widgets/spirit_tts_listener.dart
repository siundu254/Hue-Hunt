import 'package:flutter/material.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/services/spirit_tts_service.dart';

/// Speaks Hue Spirit lines when text changes (v1.5).
class SpiritTtsListener extends StatefulWidget {
  const SpiritTtsListener({
    super.key,
    required this.text,
    required this.enabled,
    this.mode,
  });

  final String text;
  final bool enabled;
  final SessionMode? mode;

  @override
  State<SpiritTtsListener> createState() => _SpiritTtsListenerState();
}

class _SpiritTtsListenerState extends State<SpiritTtsListener> {
  @override
  void initState() {
    super.initState();
    _speak();
  }

  @override
  void didUpdateWidget(SpiritTtsListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.enabled != widget.enabled) {
      _speak();
    }
  }

  void _speak() {
    if (!widget.enabled) return;
    SpiritTtsService.instance.speak(
      widget.text,
      mode: widget.mode,
      enabled: widget.enabled,
    );
  }

  @override
  void dispose() {
    SpiritTtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
