import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/models/game_settings.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/screens/app_entry_screen.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/widgets/branding/expedition_scaffold.dart';
import 'package:hue_hunt/widgets/branding/hue_hunt_logo.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = context.watch<SettingsProvider>();
    final expedition = context.watch<ExpeditionProvider>();

    return ExpeditionScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(l.settingsTitle),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SettingsHeroCard(
                    mapNodes: expedition.mapNodes.length,
                    stickers: expedition.stickers.length,
                    bestScore: expedition.bestScore,
                  ),
                  const SizedBox(height: 20),
                  _SettingsSection(
                    icon: Icons.translate_rounded,
                    title: l.settingsLanguage,
                    child: _LanguagePicker(settings: settings, l: l),
                  ),
                  const SizedBox(height: 14),
                  _SettingsSection(
                    icon: Icons.record_voice_over_outlined,
                    title: l.settingsSpiritHost,
                    child: Column(
                      children: [
                        _SettingsToggle(
                          icon: Icons.volume_up_outlined,
                          title: l.settingsSoundEffects,
                          subtitle: l.settingsSoundEffectsSub,
                          value: settings.soundEffects,
                          onChanged: settings.setSoundEffects,
                        ),
                        _SettingsToggle(
                          icon: Icons.auto_awesome_outlined,
                          title: l.settingsSpiritHints,
                          subtitle: l.settingsSpiritHintsSub,
                          value: settings.spiritHints,
                          onChanged: settings.setSpiritHints,
                        ),
                        _SettingsToggle(
                          icon: Icons.vibration_outlined,
                          title: l.settingsHaptics,
                          subtitle: l.settingsHapticsSub,
                          value: settings.haptics,
                          onChanged: settings.setHaptics,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SettingsSection(
                    icon: Icons.tune_rounded,
                    title: l.settingsGameControls,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                          child: Text(
                            l.settingsMissionTimer,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SegmentedButton<MissionTimerPreset>(
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
                        const SizedBox(height: 8),
                        _SettingsToggle(
                          icon: Icons.swap_horiz_rounded,
                          title: l.settingsPassReminders,
                          subtitle: l.settingsPassRemindersSub,
                          value: settings.passDeviceReminders,
                          onChanged: settings.setPassDeviceReminders,
                        ),
                        _SettingsToggle(
                          icon: Icons.photo_camera_outlined,
                          title: l.settingsCameraDefault,
                          subtitle: l.settingsCameraDefaultSub,
                          value: settings.defaultCameraBonus,
                          onChanged: settings.setDefaultCameraBonus,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SettingsSection(
                    icon: Icons.bolt_rounded,
                    title: l.settingsForgeDefaults,
                    child: Column(
                      children: [
                        _SettingsToggle(
                          icon: Icons.wifi_tethering_rounded,
                          title: l.settingsDefaultOpenRoom,
                          subtitle: l.settingsDefaultOpenRoomSub,
                          value: settings.defaultOpenRoom,
                          onChanged: settings.setDefaultOpenRoom,
                        ),
                        _SettingsToggle(
                          icon: Icons.live_tv_outlined,
                          title: l.settingsGameShowReveals,
                          subtitle: l.settingsGameShowRevealsSub,
                          value: settings.defaultGameShowReveals,
                          onChanged: settings.setDefaultGameShowReveals,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SettingsSection(
                    icon: Icons.storage_outlined,
                    title: l.settingsData,
                    child: Column(
                      children: [
                        _SettingsActionTile(
                          icon: Icons.restart_alt_rounded,
                          title: l.settingsResetProgress,
                          subtitle: l.settingsResetProgressSub,
                          isDestructive: true,
                          onTap: () => _confirmResetProgress(context),
                        ),
                        _SettingsActionTile(
                          icon: Icons.school_outlined,
                          title: l.settingsReplayOnboarding,
                          onTap: () async {
                            await context.read<ExpeditionProvider>().clearOnboarding();
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(builder: (_) => const AppEntryScreen()),
                              (_) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.settingsMissionContentNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${AppBranding.studioName} · ${l.settingsVersion(AppBranding.version)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmResetProgress(BuildContext context) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.resetProgressTitle),
        content: Text(l.resetProgressBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: Text(l.reset),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<ExpeditionProvider>().resetAllProgress();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.progressResetDone)));
  }
}

class _SettingsHeroCard extends StatelessWidget {
  const _SettingsHeroCard({
    required this.mapNodes,
    required this.stickers,
    required this.bestScore,
  });

  final int mapNodes;
  final int stickers;
  final int bestScore;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.55),
            AppColors.backgroundMid.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const HueHuntLogo(size: 56),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppBranding.productName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppBranding.tagline,
                  style: TextStyle(color: AppColors.amber.withValues(alpha: 0.9), fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _MiniStat(label: l.statBestScore, value: '$bestScore'),
                    _MiniStat(label: l.statMapNodes, value: '$mapNodes'),
                    _MiniStat(label: l.statStickers, value: '$stickers'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$value $label',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppColors.accent),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(icon, size: 22, color: Colors.white.withValues(alpha: 0.7)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.62), height: 1.3),
        ),
        value: value,
        activeThumbColor: AppColors.accent,
        onChanged: onChanged,
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade300 : Colors.white.withValues(alpha: 0.85);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.55)),
            )
          : null,
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.35)),
      onTap: onTap,
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.settings, required this.l});

  final SettingsProvider settings;
  final dynamic l;

  static const _options = [
    (null, '🌐', 'system'),
    (Locale('en'), '🇺🇸', 'en'),
    (Locale('es'), '🇪🇸', 'es'),
    (Locale('fr'), '🇫🇷', 'fr'),
    (Locale('de'), '🇩🇪', 'de'),
    (Locale('zh'), '🇨🇳', 'zh'),
  ];

  String _label(String key) => switch (key) {
        'system' => l.settingsLanguageSystem,
        'en' => l.settingsLanguageEn,
        'es' => l.settingsLanguageEs,
        'fr' => l.settingsLanguageFr,
        'de' => l.settingsLanguageDe,
        'zh' => l.settingsLanguageZh,
        _ => key,
      };

  bool _selected(Locale? locale) {
    if (locale == null) return settings.useSystemLocale;
    return settings.locale?.languageCode == locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _options.map((opt) {
        final selected = _selected(opt.$1);
        return FilterChip(
          selected: selected,
          avatar: Text(opt.$2, style: const TextStyle(fontSize: 16)),
          label: Text(_label(opt.$3)),
          onSelected: (_) => settings.setLocale(opt.$1),
          selectedColor: AppColors.accent.withValues(alpha: 0.35),
          checkmarkColor: AppColors.backgroundDark,
        );
      }).toList(),
    );
  }
}
