import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/models/game_settings.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/screens/app_entry_screen.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(title: l.settingsLanguage),
          _LanguageTile(
            title: l.settingsLanguageSystem,
            selected: settings.useSystemLocale,
            onTap: () => settings.setLocale(null),
          ),
          _LanguageTile(
            title: l.settingsLanguageEn,
            selected: settings.locale?.languageCode == 'en',
            onTap: () => settings.setLocale(const Locale('en')),
          ),
          _LanguageTile(
            title: l.settingsLanguageEs,
            selected: settings.locale?.languageCode == 'es',
            onTap: () => settings.setLocale(const Locale('es')),
          ),
          _LanguageTile(
            title: l.settingsLanguageFr,
            selected: settings.locale?.languageCode == 'fr',
            onTap: () => settings.setLocale(const Locale('fr')),
          ),
          _LanguageTile(
            title: l.settingsLanguageDe,
            selected: settings.locale?.languageCode == 'de',
            onTap: () => settings.setLocale(const Locale('de')),
          ),
          _LanguageTile(
            title: l.settingsLanguageZh,
            selected: settings.locale?.languageCode == 'zh',
            onTap: () => settings.setLocale(const Locale('zh')),
          ),
          _SectionHeader(title: l.settingsGameControls),
          SwitchListTile(
            title: Text(l.settingsSoundEffects),
            subtitle: Text(l.settingsSoundEffectsSub),
            value: settings.soundEffects,
            onChanged: settings.setSoundEffects,
          ),
          SwitchListTile(
            title: Text(l.settingsHaptics),
            subtitle: Text(l.settingsHapticsSub),
            value: settings.haptics,
            onChanged: settings.setHaptics,
          ),
          SwitchListTile(
            title: Text(l.settingsSpiritHints),
            subtitle: Text(l.settingsSpiritHintsSub),
            value: settings.spiritHints,
            onChanged: settings.setSpiritHints,
          ),
          SwitchListTile(
            title: Text(l.settingsPassReminders),
            subtitle: Text(l.settingsPassRemindersSub),
            value: settings.passDeviceReminders,
            onChanged: settings.setPassDeviceReminders,
          ),
          SwitchListTile(
            title: Text(l.settingsCameraDefault),
            subtitle: Text(l.settingsCameraDefaultSub),
            value: settings.defaultCameraBonus,
            onChanged: settings.setDefaultCameraBonus,
          ),
          ListTile(
            title: Text(l.settingsMissionTimer),
            subtitle: Text(_timerLabel(l, settings.timerPreset)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<MissionTimerPreset>(
              segments: [
                ButtonSegment(
                  value: MissionTimerPreset.short,
                  label: Text(l.settingsTimerShort, style: const TextStyle(fontSize: 11)),
                ),
                ButtonSegment(
                  value: MissionTimerPreset.standard,
                  label: Text(l.settingsTimerStandard),
                ),
                ButtonSegment(
                  value: MissionTimerPreset.long,
                  label: Text(l.settingsTimerLong, style: const TextStyle(fontSize: 11)),
                ),
              ],
              selected: {settings.timerPreset},
              onSelectionChanged: (s) => settings.setTimerPreset(s.first),
            ),
          ),
          const SizedBox(height: 8),
          _SectionHeader(title: l.settingsData),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: Text(l.settingsResetProgress),
            subtitle: Text(l.settingsResetProgressSub),
            onTap: () => _confirmResetProgress(context),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(l.settingsReplayOnboarding),
            onTap: () async {
              await context.read<ExpeditionProvider>().clearOnboarding();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const AppEntryScreen()),
                (_) => false,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              l.settingsMissionContentNote,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.55),
                height: 1.35,
              ),
            ),
          ),
          _SectionHeader(title: l.settingsAbout),
          ListTile(
            title: Text(AppBranding.productName),
            subtitle: Text('${AppBranding.tagline}\n${l.settingsVersion(AppBranding.version)}'),
          ),
        ],
      ),
    );
  }

  String _timerLabel(dynamic l, MissionTimerPreset preset) => switch (preset) {
        MissionTimerPreset.short => l.settingsTimerShort,
        MissionTimerPreset.standard => l.settingsTimerStandard,
        MissionTimerPreset.long => l.settingsTimerLong,
      };

  Future<void> _confirmResetProgress(BuildContext context) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.resetProgressTitle),
        content: Text(l.resetProgressBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.reset)),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<ExpeditionProvider>().resetAllProgress();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.progressResetDone)));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: selected ? const Icon(Icons.check, color: Colors.greenAccent) : null,
      onTap: onTap,
    );
  }
}
