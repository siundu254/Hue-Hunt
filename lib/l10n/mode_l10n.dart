import 'package:hue_hunt/l10n/app_localizations.dart';
import 'package:hue_hunt/models/session_mode.dart';

extension ModeProfileL10n on ModeProfile {
  String localizedTitle(AppLocalizations l) => switch (mode) {
        SessionMode.family => l.modeFamilyTitle,
        SessionMode.friends => l.modeFriendsTitle,
        SessionMode.party => l.modePartyTitle,
        SessionMode.team => l.modeTeamTitle,
        SessionMode.kids => l.modeKidsTitle,
      };

  String localizedSubtitle(AppLocalizations l) => switch (mode) {
        SessionMode.family => l.modeFamilySubtitle,
        SessionMode.friends => l.modeFriendsSubtitle,
        SessionMode.party => l.modePartySubtitle,
        SessionMode.team => l.modeTeamSubtitle,
        SessionMode.kids => l.modeKidsSubtitle,
      };

  String localizedAudience(AppLocalizations l) => switch (mode) {
        SessionMode.family => l.modeFamilyAudience,
        SessionMode.friends => l.modeFriendsAudience,
        SessionMode.party => l.modePartyAudience,
        SessionMode.team => l.modeTeamAudience,
        SessionMode.kids => l.modeKidsAudience,
      };

  String localizedSpiritIntro(AppLocalizations l) => switch (mode) {
        SessionMode.family => l.modeFamilyIntro,
        SessionMode.friends => l.modeFriendsIntro,
        SessionMode.party => l.modePartyIntro,
        SessionMode.team => l.modeTeamIntro,
        SessionMode.kids => l.modeKidsIntro,
      };
}

extension SessionModeL10n on SessionMode {
  ModeProfile get profile => ModeProfile.forMode(this);
}
