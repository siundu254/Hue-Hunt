import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/team_config.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
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

    return Card(
      elevation: 8,
      color: Colors.amber.shade900.withValues(alpha: 0.92),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.swap_horiz, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              l.passDeviceTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            Text(
              l.passDevicePlayer(playerNumber, totalPlayers),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
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
                style: const TextStyle(color: Colors.white70, height: 1.3),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.amber.shade900,
              ),
              onPressed: () => _handleReady(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l.passDeviceReady),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
