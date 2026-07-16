import 'package:flutter/material.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/screens/home_screen.dart';
import 'package:hue_hunt/screens/onboarding_screen.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/widgets/branding/expedition_scaffold.dart';
import 'package:hue_hunt/widgets/branding/hue_hunt_logo.dart';
import 'package:provider/provider.dart';

class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  bool _ready = false;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final provider = context.read<ExpeditionProvider>();
    final started = DateTime.now();
    await provider.loadProgress();
    final elapsed = DateTime.now().difference(started);
    const minSplash = Duration(milliseconds: 1200);
    if (elapsed < minSplash) {
      await Future<void>.delayed(minSplash - elapsed);
    }
    if (!mounted) return;
    setState(() {
      _showOnboarding = !provider.onboardingComplete;
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      final l = context.l10n;
      return ExpeditionScaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: RaidUi.heroPanel(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HueHuntLogo(size: 96),
                const SizedBox(height: 20),
                Text(
                  l.appTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  l.tagline,
                  style: TextStyle(color: AppColors.treasureYellow.withValues(alpha: 0.9)),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.adventureOrange,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return _showOnboarding ? const OnboardingScreen() : const HomeScreen();
  }
}
