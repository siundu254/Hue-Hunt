import 'package:flutter/material.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Shared Room Raiders visual language — glass panels, mission cards, glow.
abstract final class RaidUi {
  static const radiusLg = 20.0;
  static const radiusMd = 16.0;
  static const radiusSm = 12.0;

  static BoxDecoration heroPanel({double glow = 0.5}) => BoxDecoration(
        borderRadius: BorderRadius.circular(radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mysteryPurple.withValues(alpha: 0.55),
            AppColors.backgroundDark.withValues(alpha: 0.92),
          ],
        ),
        border: Border.all(
          color: AppColors.adventureOrange.withValues(alpha: 0.35 + glow * 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.adventureOrange.withValues(alpha: 0.12 + glow * 0.1),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration glassPanel({Color? accent}) {
    final line = accent ?? AppColors.adventureOrange;
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(color: line.withValues(alpha: 0.28)),
    );
  }

  static BoxDecoration missionCard() => BoxDecoration(
        borderRadius: BorderRadius.circular(radiusMd),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF14101F), Color(0xFF2A1848), Color(0xFF1A2238)],
        ),
        border: Border.all(color: AppColors.adventureOrange.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.mysteryPurple.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration statTile() => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(radiusSm),
        border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.15)),
      );

  static BoxDecoration featurePill() => BoxDecoration(
        color: AppColors.adventureOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.adventureOrange.withValues(alpha: 0.35)),
      );

  static LinearGradient primaryButtonGradient() => const LinearGradient(
        colors: [AppColors.adventureOrange, Color(0xFFE86A00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Color raidMeterColor(double progress) =>
      Color.lerp(AppColors.mysteryPurple, AppColors.treasureYellow, progress.clamp(0.0, 1.0))!;

  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.1,
          );

  static TextStyle sectionLabel() => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: AppColors.treasureYellow,
      );
}

/// Gradient primary CTA used on home and forge screens.
class RaidPrimaryButton extends StatelessWidget {
  const RaidPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: enabled
                ? RaidUi.primaryButtonGradient()
                : LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade800]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.adventureOrange.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                else if (icon != null) ...[
                  Icon(icon, color: AppColors.backgroundDark, size: 22),
                  const SizedBox(width: 10),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
