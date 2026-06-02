import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/l10n/mode_l10n.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/screens/chroma_map_screen.dart';
import 'package:hue_hunt/screens/hunt_hue_box_screen.dart';
import 'package:hue_hunt/screens/journal_screen.dart';
import 'package:hue_hunt/screens/onboarding_screen.dart';
import 'package:hue_hunt/screens/session_setup_screen.dart';
import 'package:hue_hunt/screens/settings_screen.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/widgets/branding/expedition_scaffold.dart';
import 'package:hue_hunt/widgets/branding/hue_hunt_logo.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = context.watch<ExpeditionProvider>();
    final lastProfile = ModeProfile.forMode(provider.lastMode);
    final mapCount = provider.mapNodes.length;
    final stickerCount = provider.stickers.length;

    return ExpeditionScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: l.settings,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HueHuntLogo(size: 80),
                  const SizedBox(height: 12),
                  Text(
                    l.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    l.subBrand,
                    style: TextStyle(
                      color: AppColors.amber.withValues(alpha: 0.95),
                      fontSize: 15,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.tagline,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.homeHeroBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      height: 1.35,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _StatChip(label: l.statBestScore, value: '${provider.bestScore}')),
                      const SizedBox(width: 8),
                      Expanded(child: _StatChip(label: l.statMapNodes, value: '$mapCount')),
                      const SizedBox(width: 8),
                      Expanded(child: _StatChip(label: l.statStickers, value: '$stickerCount')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SessionSetupScreen(mode: provider.lastMode),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(l.playMode(lastProfile.localizedTitle(l))),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.backgroundDark,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const OnboardingScreen(introOnly: true),
                        ),
                      ),
                      icon: const Icon(Icons.help_outline, size: 18),
                      label: Text(l.howItWorks),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l.chooseMode,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final profile = ModeProfile.profiles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ModeCard(
                      profile: profile,
                      title: profile.localizedTitle(l),
                      subtitle: profile.localizedSubtitle(l),
                      audience: profile.localizedAudience(l),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SessionSetupScreen(mode: profile.mode),
                        ),
                      ),
                    ),
                  );
                },
                childCount: ModeProfile.profiles.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const HuntHueBoxScreen()),
                ),
                icon: const Icon(Icons.inventory_2_outlined),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l.huntHueBoxButton),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ChromaMapScreen(highlight: provider.lastMode),
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined),
                      label: Text(l.chromaMap),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const JournalScreen()),
                      ),
                      icon: const Icon(Icons.menu_book_outlined),
                      label: Text(l.journal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '${l.studioName} · ${AppBranding.versionLabel}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.65)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.profile,
    required this.title,
    required this.subtitle,
    required this.audience,
    required this.onTap,
  });

  final ModeProfile profile;
  final String title;
  final String subtitle;
  final String audience;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: profile.gradient),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: profile.gradient.first.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 28,
                  child: Icon(profile.icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(subtitle),
                      const SizedBox(height: 4),
                      Text(
                        audience,
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
