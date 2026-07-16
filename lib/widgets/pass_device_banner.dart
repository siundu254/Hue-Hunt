import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:provider/provider.dart';

class PassDeviceBanner extends StatelessWidget {
  const PassDeviceBanner({
    super.key,
    required this.playerNumber,
    required this.totalPlayers,
    required this.team,
    required this.onReady,
    this.missionLabel,
  });

  final int playerNumber;
  final int totalPlayers;
  final TeamConfig? team;
  final VoidCallback onReady;
  final String? missionLabel;

  void _handleReady(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    if (settings.haptics) {
      HapticFeedback.mediumImpact();
    }
    onReady();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = context.watch<SettingsProvider>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.adventureOrange.withValues(alpha: 0.9),
            AppColors.mysteryPurple.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(RaidUi.radiusLg),
        border: Border.all(color: AppColors.treasureYellow.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: AppColors.adventureOrange.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.swap_horiz_rounded, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              l.passDeviceTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            if (team != null)
              Text(
                l.passDeviceTeam(team!.name),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            Text(
              l.passDevicePlayer(playerNumber, totalPlayers),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
            ),
            if (missionLabel != null) ...[
              const SizedBox(height: 8),
              Text(
                missionLabel!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ],
            if (settings.passDeviceReminders) ...[
              const SizedBox(height: 8),
              Text(
                l.passDeviceNoPeek,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), height: 1.35),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.backgroundDark,
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onPressed: () => _handleReady(context),
              child: Text(l.passDeviceReady),
            ),
          ],
        ),
      ),
    );
  }
}
