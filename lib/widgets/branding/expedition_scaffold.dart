import 'package:flutter/material.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Shared gradient shell with ambient flashlight glow.
class ExpeditionScaffold extends StatelessWidget {
  const ExpeditionScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.padding,
  });

  final Widget body;
  final Widget? bottom;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.expeditionGradient),
          ),
          Positioned(
            top: -80,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.adventureOrange.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mysteryPurple.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Column(
                children: [
                  Expanded(child: body),
                  if (bottom != null) bottom!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
