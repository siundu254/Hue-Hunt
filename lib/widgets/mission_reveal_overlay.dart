import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/chaos_twist.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/services/spirit_tts_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Game-show mission drop — the pitch "this is crazy" moment.
class MissionRevealOverlay extends StatefulWidget {
  const MissionRevealOverlay({
    super.key,
    required this.mission,
    required this.missionIndex,
    required this.totalMissions,
    required this.teamName,
    required this.soundEnabled,
    required this.onComplete,
    this.chaosTwist,
  });

  final MissionDefinition mission;
  final int missionIndex;
  final int totalMissions;
  final String? teamName;
  final bool soundEnabled;
  final VoidCallback onComplete;
  final ChaosTwist? chaosTwist;

  @override
  State<MissionRevealOverlay> createState() => _MissionRevealOverlayState();
}

class _MissionRevealOverlayState extends State<MissionRevealOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _slide;
  late final Animation<double> _pulseScale;
  late final Animation<Offset> _slideOffset;
  int _countdown = 3;
  bool _showCountdown = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _slide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _pulseScale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _slideOffset = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slide, curve: Curves.easeOutCubic));
    _runSequence();
  }

  Future<void> _runSequence() async {
    final team = widget.teamName ?? 'Explorers';
    if (widget.chaosTwist != null) {
      await SpiritTtsService.instance.speak(
        widget.chaosTwist!.spiritLine,
        enabled: widget.soundEnabled,
      );
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    await SpiritTtsService.instance.speak(
      'Attention room! Mission ${widget.missionIndex + 1}. $team — listen up.',
      enabled: widget.soundEnabled,
    );
    if (!mounted) return;
    await _slide.forward();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    await SpiritTtsService.instance.speak(
      widget.mission.challengePrompt,
      enabled: widget.soundEnabled,
    );
    if (!mounted) return;
    setState(() => _showCountdown = true);
    for (var i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      HapticFeedback.heavyImpact();
      await SpiritTtsService.instance.speak('$i', enabled: widget.soundEnabled);
      await Future<void>.delayed(const Duration(milliseconds: 700));
    }
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    await SpiritTtsService.instance.speak('Hunt!', enabled: widget.soundEnabled);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted || _done) return;
    _done = true;
    widget.onComplete();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.94),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'GAME SHOW DROP',
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: AppColors.amber.withValues(alpha: 0.9),
                ),
              ),
              const Spacer(),
              ScaleTransition(
                scale: _pulseScale,
                child: Text(widget.mission.picture, style: const TextStyle(fontSize: 88)),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideOffset,
                child: Column(
                  children: [
                    Text(
                      'MISSION ${widget.missionIndex + 1} / ${widget.totalMissions}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      missionTypeLabel(widget.mission.type),
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.mission.challengePrompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                    if (widget.teamName != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        '${widget.teamName} — you\'re up!',
                        style: TextStyle(
                          color: Colors.amber.shade200,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              if (_showCountdown)
                Text(
                  _countdown > 0 ? '$_countdown' : 'HUNT!',
                  style: TextStyle(
                    fontSize: _countdown > 0 ? 72 : 48,
                    fontWeight: FontWeight.w900,
                    color: _countdown > 0 ? Colors.white : AppColors.accent,
                    letterSpacing: _countdown > 0 ? 0 : 6,
                  ),
                )
              else
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.accent),
                ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
