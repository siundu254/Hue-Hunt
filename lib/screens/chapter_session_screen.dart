import 'package:flutter/material.dart';
import 'package:hue_hunt/l10n/mode_l10n.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/models/venue_archetype.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/utils/l10n_ext.dart';
import 'package:hue_hunt/screens/chapter_complete_screen.dart';
import 'package:hue_hunt/screens/chroma_map_screen.dart';
import 'package:hue_hunt/widgets/chaos_twist_banner.dart';
import 'package:hue_hunt/widgets/host_mode_panel.dart';
import 'package:hue_hunt/widgets/mission_reveal_overlay.dart';
import 'package:hue_hunt/widgets/chroma_meter_bar.dart';
import 'package:hue_hunt/widgets/hue_spirit_banner.dart';
import 'package:hue_hunt/widgets/missions/mission_host.dart';
import 'package:hue_hunt/widgets/mission_taxonomy_chip.dart';
import 'package:hue_hunt/widgets/pass_device_banner.dart';
import 'package:hue_hunt/widgets/secret_objective_banner.dart';
import 'package:hue_hunt/widgets/spirit_tts_listener.dart';
import 'package:hue_hunt/widgets/team_scoreboard.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';
import 'package:provider/provider.dart';

class ChapterSessionScreen extends StatelessWidget {
  const ChapterSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = context.watch<SettingsProvider>();
    final expedition = context.watch<ExpeditionProvider>();
    final profile = expedition.profile!;
    final mission = expedition.currentMission;
    final spiritText = settings.spiritHints
        ? expedition.resolveSpiritText(l)
        : '';

    final appTitle = switch (expedition.playSource) {
      PlaySource.huntHueBox => expedition.forgeFormat != null ? 'Spirit Forge · Box' : l.huntHueBox,
      PlaySource.spiritForge => 'Spirit Forge',
      _ => profile.localizedTitle(l),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          if (expedition.phase != SessionPhase.briefing &&
              expedition.phase != SessionPhase.chapterComplete)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  'M ${expedition.missionIndex + 1}/${expedition.chapter.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChromaMeterBar(
                  value: expedition.chromaMeter,
                  streak: profile.showStreaks ? expedition.streak : null,
                ),
                const SizedBox(height: 10),
                TeamScoreboard(
                  teams: expedition.teams,
                  highlightIndex: expedition.activeTeamIndex,
                ),
                const SizedBox(height: 12),
                if (expedition.roomHosting)
                  HostModePanel(expedition: expedition, mission: mission),
                if (expedition.activeChaos != null &&
                    (expedition.phase == SessionPhase.missionPlay ||
                        expedition.phase == SessionPhase.missionIntro))
                  ChaosTwistBanner(twist: expedition.activeChaos!),
                if (settings.spiritHints && spiritText.isNotEmpty)
                  HueSpiritBanner(
                    message: spiritText,
                    mood: expedition.spiritMood,
                    compact: expedition.phase == SessionPhase.missionPlay,
                  ),
                if (settings.spiritHints && spiritText.isNotEmpty)
                  SpiritTtsListener(
                    text: spiritText,
                    enabled: settings.soundEffects,
                    mode: profile.mode,
                  ),
                if (settings.spiritHints && spiritText.isNotEmpty) const SizedBox(height: 16),
                _PhaseBody(
                  expedition: expedition,
                  profile: profile,
                  mission: mission,
                ),
              ],
            ),
          ),
          if (expedition.awaitingGameShowReveal && mission != null)
            MissionRevealOverlay(
              mission: mission,
              missionIndex: expedition.missionIndex,
              totalMissions: expedition.chapter.length,
              teamName: expedition.activeTeam?.name,
              soundEnabled: settings.soundEffects,
              chaosTwist: expedition.activeChaos,
              onComplete: expedition.completeGameShowReveal,
            ),
        ],
      ),
    );
  }
}

class _PhaseBody extends StatelessWidget {
  const _PhaseBody({
    required this.expedition,
    required this.profile,
    required this.mission,
  });

  final ExpeditionProvider expedition;
  final ModeProfile profile;
  final MissionDefinition? mission;

  @override
  Widget build(BuildContext context) {
    switch (expedition.phase) {
      case SessionPhase.briefing:
        return _BriefingPhase(profile: profile, expedition: expedition, onStart: expedition.startChapter);
      case SessionPhase.missionIntro:
        if (expedition.awaitingGameShowReveal) return const SizedBox.shrink();
        final introMission = mission;
        if (introMission == null) return const SizedBox.shrink();
        return _MissionIntroPhase(
          mission: introMission,
          profile: profile,
          index: expedition.missionIndex,
          total: expedition.chapter.length,
          onStart: expedition.beginMissionPlay,
        );
      case SessionPhase.passDevice:
        final secret = expedition.secretObjectiveForPlayer(expedition.passPlayerIndex);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (secret != null) ...[
              SecretObjectiveBanner(
                objective: secret,
                playerNumber: expedition.passPlayerIndex + 1,
              ),
              const SizedBox(height: 12),
            ],
            PassDeviceBanner(
              playerNumber: expedition.passPlayerIndex + 1,
              totalPlayers: expedition.playerCount,
              team: expedition.activeTeam,
              missionLabel: mission?.huntHeadline,
              onReady: expedition.acknowledgePassDevice,
            ),
          ],
        );
      case SessionPhase.missionPlay:
        final playMission = mission;
        if (playMission == null) return const SizedBox.shrink();
        final secret = expedition.secretObjectiveForPlayer(expedition.passPlayerIndex);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (secret != null) ...[
              SecretObjectiveBanner(
                objective: secret,
                playerNumber: expedition.passPlayerIndex + 1,
              ),
              if (!secret.completed)
                TextButton(
                  onPressed: () =>
                      expedition.completeSecretObjective(expedition.passPlayerIndex),
                  child: const Text('Done — secret objective complete'),
                ),
              const SizedBox(height: 10),
            ],
            Container(
              decoration: RaidUi.glassPanel(),
              padding: const EdgeInsets.all(16),
              child: MissionHost(
                mission: playMission,
                profile: profile,
                seconds: expedition.effectiveMissionSeconds,
                playerCount: expedition.playerCount,
                onComplete: expedition.completeMission,
              ),
            ),
          ],
        );
      case SessionPhase.meterSync:
        return _MeterSyncPhase(
          meter: expedition.chromaMeter,
          onContinue: expedition.advanceAfterMeter,
        );
      case SessionPhase.spiritReaction:
        return _SpiritReactionPhase(onContinue: expedition.advanceAfterSpirit);
      case SessionPhase.chapterComplete:
        return ChapterCompletePanel(
          score: expedition.sessionScore,
          meter: expedition.chromaMeter,
          modeTitle: profile.localizedTitle(context.l10n),
          teams: expedition.teams,
          awards: expedition.chapterAwards,
          isTeamExpedition: profile.mode == SessionMode.team,
          onViewMap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ChromaMapScreen(highlight: profile.mode),
            ),
          ),
          onDone: () {
            expedition.resetToHome();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
    }
  }
}

class _BriefingPhase extends StatelessWidget {
  const _BriefingPhase({
    required this.profile,
    required this.expedition,
    required this.onStart,
  });

  final ModeProfile profile;
  final ExpeditionProvider expedition;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Session briefing', style: Theme.of(context).textTheme.titleLarge),
        if (expedition.isSpiritForge && expedition.forgeVenue != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: RaidUi.glassPanel(accent: AppColors.treasureYellow),
            child: Row(
              children: [
                Text(expedition.forgeVenue!.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Spirit Forge chapter for ${expedition.forgeVenue!.label} — '
                    '${expedition.chapter.length} missions forged live. Game Show Drops enabled.',
                    style: const TextStyle(height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        MissionTypeOverviewRow(
          types: expedition.chapter.map((m) => m.type).toSet().toList(),
        ),
        const SizedBox(height: 12),
        Text(
          expedition.resolveSpiritText(context.l10n),
          style: const TextStyle(height: 1.4),
        ),
        if (expedition.forgeFormat == ExpeditionFormat.huntHueBox ||
            expedition.playSource == PlaySource.huntHueBox) ...[
          const SizedBox(height: 12),
          const Text(
            'Draw the matching card from your Hunt-Hue Box — or mirror it on this screen. '
            'Spirit Forge shuffled object-led box missions for this room.',
            style: TextStyle(height: 1.35),
          ),
        ],
        if (expedition.playSource == PlaySource.huntHueBox && expedition.forgeFormat == null) ...[
          const SizedBox(height: 12),
          const Text(
            'Use physical Hunt-Hue cards from your box, or mirror them on this device. '
            'One phone can score the whole table.',
            style: TextStyle(height: 1.35),
          ),
        ],
        const SizedBox(height: 12),
        Text('Teams: ${expedition.teams.map((t) => t.name).join(' · ')}'),
        const SizedBox(height: 8),
        const Text(
          'Hunt real objects, textures, and combos — never colour-based hunts.\n'
          'Secret objectives · sudden death · decoys · chaos twists · raid awards.',
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onStart,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Start chapter'),
          ),
        ),
      ],
    );
  }
}

class _MissionIntroPhase extends StatelessWidget {
  const _MissionIntroPhase({
    required this.mission,
    required this.profile,
    required this.index,
    required this.total,
    required this.onStart,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final int index;
  final int total;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Mission ${index + 1} of $total', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        MissionTaxonomyChip(mission: mission, large: true),
        if (mission.boxCardId != null) ...[
          const SizedBox(height: 6),
          Text('Box card ${mission.boxCardId}', style: TextStyle(color: Colors.amber.shade200)),
        ],
        const SizedBox(height: 10),
        Text(
          mission.challengePrompt,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(mission.clue, style: const TextStyle(height: 1.35)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(mission.type, neutral: profile.neutralCopy)),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onStart,
          child: const Text('Launch mission'),
        ),
      ],
    );
  }
}

class _MeterSyncPhase extends StatelessWidget {
  const _MeterSyncPhase({required this.meter, required this.onContinue});
  final int meter;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.sync, size: 48),
        const SizedBox(height: 12),
        Text('Raid Meter synced to $meter%', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        FilledButton(onPressed: onContinue, child: const Text('Raid Captain reacts…')),
      ],
    );
  }
}

class _SpiritReactionPhase extends StatelessWidget {
  const _SpiritReactionPhase({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('✨', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 12),
        const Text('Map node unlocked · Journal sticker earned'),
        const SizedBox(height: 20),
        FilledButton(onPressed: onContinue, child: const Text('Continue expedition')),
      ],
    );
  }
}
