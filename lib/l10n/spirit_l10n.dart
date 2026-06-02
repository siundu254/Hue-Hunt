import 'package:hue_hunt/l10n/app_localizations.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/l10n/mode_l10n.dart';

enum SpiritMessageKind {
  boxIntro,
  profileIntro,
  missionReady,
  huntGreat,
  huntGood,
  rematch,
  mapUnlock,
  mapProgress,
}

/// Resolves Hue Spirit copy for the active expedition state.
class SpiritL10n {
  SpiritL10n({
    required this.kind,
    this.missionNumber = 1,
    this.teamName,
    this.mode,
  });

  final SpiritMessageKind kind;
  final int missionNumber;
  final String? teamName;
  final SessionMode? mode;

  String resolve(AppLocalizations l) {
    return switch (kind) {
      SpiritMessageKind.boxIntro => l.spiritBoxIntro,
      SpiritMessageKind.profileIntro =>
        mode != null ? mode!.profile.localizedSpiritIntro(l) : l.modeFamilyIntro,
      SpiritMessageKind.missionReady => l.spiritMissionReady(
          missionNumber,
          teamName ?? l.spiritExplorers,
        ),
      SpiritMessageKind.huntGreat => l.spiritHuntGreat,
      SpiritMessageKind.huntGood => l.spiritHuntGood,
      SpiritMessageKind.rematch => l.spiritRematch,
      SpiritMessageKind.mapUnlock => l.spiritMapUnlock,
      SpiritMessageKind.mapProgress => l.spiritMapProgress,
    };
  }
}
