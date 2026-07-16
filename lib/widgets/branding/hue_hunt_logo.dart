import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';

/// Room Raiders app icon / logo mark.
class HueHuntLogo extends StatelessWidget {
  const HueHuntLogo({super.key, this.size = 72, this.showGlow = true});

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showGlow
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8A00).withValues(alpha: 0.35),
                  blurRadius: size * 0.2,
                  spreadRadius: size * 0.02,
                ),
              ],
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.22),
        child: Image.asset(
          AppBranding.logoAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
