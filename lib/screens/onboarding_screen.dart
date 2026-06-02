import 'package:flutter/material.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/screens/home_screen.dart';
import 'package:hue_hunt/screens/session_setup_screen.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/widgets/branding/expedition_scaffold.dart';
import 'package:hue_hunt/widgets/branding/hue_hunt_logo.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.introOnly = false});

  final bool introOnly;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_OnboardingPage> _pages(BuildContext context) {
    final l = context.l10n;
    return [
      _OnboardingPage(
        icon: Icons.search_rounded,
        title: l.onboardingHuntTitle,
        body: l.onboardingHuntBody,
      ),
      _OnboardingPage(
        icon: Icons.phonelink_ring_outlined,
        title: l.onboardingPassTitle,
        body: l.onboardingPassBody,
      ),
      _OnboardingPage(
        icon: Icons.inventory_2_outlined,
        title: l.onboardingBoxTitle,
        body: l.onboardingBoxBody,
      ),
    ];
  }

  Future<void> _finish({bool startFamily = false}) async {
    if (!widget.introOnly) {
      await context.read<ExpeditionProvider>().completeOnboarding();
    }
    if (!mounted) return;
    if (widget.introOnly) {
      Navigator.of(context).pop();
      if (startFamily) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const SessionSetupScreen(mode: SessionMode.family),
          ),
        );
      }
      return;
    }
    if (startFamily) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const SessionSetupScreen(mode: SessionMode.family),
        ),
      );
    } else {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pages = _pages(context);

    return ExpeditionScaffold(
      body: Column(
        children: [
          const SizedBox(height: 24),
          const HueHuntLogo(size: 64),
          const SizedBox(height: 8),
          Text(
            l.appTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            l.tagline,
            style: TextStyle(color: AppColors.amber.withValues(alpha: 0.95)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: pages[i],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _page == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _page == i ? AppColors.accent : Colors.white30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_page < pages.length - 1)
              FilledButton(
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                ),
                child: Text(l.next),
              )
            else ...[
              FilledButton(
                onPressed: () => _finish(startFamily: true),
                child: Text(l.startFamilyMission),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => _finish(),
                child: Text(l.exploreAllModes),
              ),
            ],
            if (_page < pages.length - 1)
              TextButton(
                onPressed: () => _finish(),
                child: Text(l.skip),
              ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 56, color: AppColors.accent),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.45,
            color: Colors.white.withValues(alpha: 0.88),
          ),
        ),
      ],
    );
  }
}
