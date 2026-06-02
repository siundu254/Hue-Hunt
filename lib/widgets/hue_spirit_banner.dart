import 'package:flutter/material.dart';
import 'package:hue_hunt/models/spirit_mood.dart';

class HueSpiritBanner extends StatefulWidget {
  const HueSpiritBanner({
    super.key,
    required this.message,
    this.mood = SpiritMood.neutral,
    this.compact = false,
  });

  final String message;
  final SpiritMood mood;
  final bool compact;

  @override
  State<HueSpiritBanner> createState() => _HueSpiritBannerState();
}

class _HueSpiritBannerState extends State<HueSpiritBanner>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _entranceController;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut),
    );
    _glow = Tween<double>(begin: 0.25, end: 0.55).animate(_pulseController);
    _entranceController.forward();
  }

  @override
  void didUpdateWidget(HueSpiritBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message || oldWidget.mood != widget.mood) {
      _entranceController.forward(from: 0);
    }
    if (widget.mood == SpiritMood.celebrating) {
      _pulseController.duration = const Duration(milliseconds: 700);
    } else {
      _pulseController.duration = const Duration(milliseconds: 1400);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Color _accentForMood() => switch (widget.mood) {
        SpiritMood.neutral => Colors.deepPurple,
        SpiritMood.excited => Colors.indigo,
        SpiritMood.celebrating => Colors.pinkAccent,
        SpiritMood.rematch => Colors.orange,
      };

  @override
  Widget build(BuildContext context) {
    final accent = _accentForMood();
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _entranceController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(widget.compact ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.55 + _glow.value * 0.2),
                  Colors.indigo.withValues(alpha: 0.35),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accent.withValues(alpha: 0.4 + _glow.value * 0.3),
                width: widget.mood == SpiritMood.celebrating ? 2 : 1,
              ),
              boxShadow: widget.mood == SpiritMood.celebrating
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: _glow.value),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SpiritAvatar(
                  emoji: widget.mood.emoji,
                  compact: widget.compact,
                  wobble: _pulseController.value,
                  celebrating: widget.mood == SpiritMood.celebrating,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hue Spirit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.compact ? 13 : 15,
                          color: Colors.amber.shade200,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.15),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Text(
                          widget.message,
                          key: ValueKey<String>(widget.message),
                          style: TextStyle(
                            height: 1.35,
                            fontSize: widget.compact ? 13 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SpiritAvatar extends StatelessWidget {
  const _SpiritAvatar({
    required this.emoji,
    required this.compact,
    required this.wobble,
    required this.celebrating,
  });

  final String emoji;
  final bool compact;
  final double wobble;
  final bool celebrating;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 48.0;
    return Transform.rotate(
      angle: celebrating ? (wobble - 0.5) * 0.12 : 0,
      child: Transform.scale(
        scale: celebrating ? 1.0 + (wobble * 0.08) : 1.0,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          child: Text(emoji, style: TextStyle(fontSize: compact ? 22 : 28)),
        ),
      ),
    );
  }
}
