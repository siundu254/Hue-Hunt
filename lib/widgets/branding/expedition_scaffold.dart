import 'package:flutter/material.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Shared gradient shell for home, onboarding, and splash.
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
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.expeditionGradient),
        child: SafeArea(
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
      ),
    );
  }
}
