import 'package:flutter/material.dart';
import 'package:hue_hunt/constants/app_branding.dart';
import 'package:hue_hunt/l10n/mode_l10n.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/screens/chroma_map_screen.dart';
import 'package:hue_hunt/screens/hunt_hue_box_screen.dart';
import 'package:hue_hunt/screens/journal_screen.dart';
import 'package:hue_hunt/screens/onboarding_screen.dart';
import 'package:hue_hunt/screens/spirit_forge_screen.dart';
import 'package:hue_hunt/screens/join_expedition_screen.dart';
import 'package:hue_hunt/screens/session_setup_screen.dart';
import 'package:hue_hunt/screens/settings_screen.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/widgets/branding/expedition_scaffold.dart';
import 'package:hue_hunt/widgets/branding/hue_hunt_logo.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _heroGlow;

  @override
  void initState() {
    super.initState();
    _heroGlow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heroGlow.dispose();
    super.dispose();
  }

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
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 0),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: AnimatedBuilder(
                animation: _heroGlow,
                builder: (context, child) => Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  decoration: RaidUi.heroPanel(glow: _heroGlow.value),
                  child: child,
                ),
                child: Column(
                  children: [
                    const HueHuntLogo(size: 88),
                    const SizedBox(height: 14),
                    Text(l.appTitle, style: RaidUi.title(context)),
                    const SizedBox(height: 4),
                    Text(
                      l.tagline.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.treasureYellow.withValues(alpha: 0.95),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.homeHeroBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.4,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _FeaturePillRow(),
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
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaidPrimaryButton(
                    label: 'Spirit Forge — start raid',
                    icon: Icons.flashlight_on_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const SpiritForgeScreen()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const JoinExpeditionScreen()),
                    ),
                    icon: const Icon(Icons.phonelink_ring_outlined),
                    label: const Text('Join expedition on this phone'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SessionSetupScreen(mode: provider.lastMode),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.mysteryPurple.withValues(alpha: 0.35),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text('Classic: ${lastProfile.localizedTitle(l)}'),
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
                  Text(l.chooseMode, style: RaidUi.sectionLabel()),
                  const SizedBox(height: 10),
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
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  minimumSize: const Size.fromHeight(52),
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
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '${l.studioName} · ${AppBranding.versionLabel}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePillRow extends StatelessWidget {
  const _FeaturePillRow();

  @override
  Widget build(BuildContext context) {
    const items = ['🕵️ Secret', '⏱️ Sudden death', '🃏 Decoys', '🌪️ Chaos'];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: items
          .map(
            (t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: RaidUi.featurePill(),
              child: Text(
                t,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          )
          .toList(),
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
      decoration: RaidUi.statTile(),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.treasureYellow,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.65)),
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
            gradient: LinearGradient(
              colors: [
                profile.gradient.first.withValues(alpha: 0.85),
                profile.gradient.last.withValues(alpha: 0.65),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: profile.gradient.first.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(profile.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                      const SizedBox(height: 4),
                      Text(
                        audience,
                        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.75)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
