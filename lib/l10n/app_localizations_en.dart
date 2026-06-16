// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hue Hunt';

  @override
  String get subBrand => 'Family Mission';

  @override
  String get tagline => 'The Chroma Expedition';

  @override
  String get studioName => 'NovaLumina Studio';

  @override
  String get homeHeroBody =>
      'Spirit Forge invents missions for your room — app, team phones, spectators, or Hunt-Hue Box tabletop.';

  @override
  String get statBestScore => 'Best score';

  @override
  String get statMapNodes => 'Map nodes';

  @override
  String get statStickers => 'Stickers';

  @override
  String playMode(String mode) {
    return 'Play $mode';
  }

  @override
  String get howItWorks => 'How it works';

  @override
  String get chooseMode => 'Choose a mode';

  @override
  String get huntHueBoxButton => 'Hunt-Hue Box — tabletop + app';

  @override
  String get chromaMap => 'Chroma Map';

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Settings';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get startFamilyMission => 'Start Family Mission';

  @override
  String get exploreAllModes => 'Explore all modes';

  @override
  String get onboardingHuntTitle => 'Hunt real things';

  @override
  String get onboardingHuntBody =>
      'Every mission asks your group to find objects, textures, or combos in the room — not flat colour swatches. Works in any home, office, or party.';

  @override
  String get onboardingPassTitle => 'One phone, whole group';

  @override
  String get onboardingPassBody =>
      'Pass the device between players. Confirm finds together. Teams, scoring, and the Hue Spirit guide keep energy high without everyone on a screen.';

  @override
  String get onboardingBoxTitle => 'Digital or tabletop';

  @override
  String get onboardingBoxBody =>
      'Play in the app, or use the Hunt-Hue Box with zero phones. Same missions, same laughs — your choice.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageZh => '中文 (简体)';

  @override
  String get settingsGameControls => 'Game controls';

  @override
  String get settingsSoundEffects => 'Sound effects';

  @override
  String get settingsSoundEffectsSub =>
      'Spirit voice, Game Show Drop, and mission cues';

  @override
  String get settingsSpiritHost => 'Hue Spirit host';

  @override
  String get settingsForgeDefaults => 'Spirit Forge';

  @override
  String get settingsDefaultOpenRoom => 'Open expedition room';

  @override
  String get settingsDefaultOpenRoomSub =>
      'Team and spectator phones join on the same Wi‑Fi';

  @override
  String get settingsGameShowReveals => 'Game Show Drop reveals';

  @override
  String get settingsGameShowRevealsSub =>
      'Fullscreen voice countdown before each mission';

  @override
  String get settingsMissionContentNote =>
      'Mission prompts stay in English; all menus follow your language.';

  @override
  String get settingsHaptics => 'Haptic feedback';

  @override
  String get settingsHapticsSub => 'Vibration on pass-device and confirms';

  @override
  String get settingsSpiritHints => 'Hue Spirit hints';

  @override
  String get settingsSpiritHintsSub => 'Narrator messages between missions';

  @override
  String get settingsPassReminders => 'Pass-device reminders';

  @override
  String get settingsPassRemindersSub =>
      'Extra prompts when handing off the phone';

  @override
  String get settingsMissionTimer => 'Mission timer';

  @override
  String get settingsTimerShort => 'Short (−25%)';

  @override
  String get settingsTimerStandard => 'Standard';

  @override
  String get settingsTimerLong => 'Long (+25%)';

  @override
  String get settingsCameraDefault => 'Default camera bonus';

  @override
  String get settingsCameraDefaultSub =>
      'When a mode allows optional photo verify';

  @override
  String get settingsData => 'Data & privacy';

  @override
  String get settingsResetProgress => 'Reset expedition progress';

  @override
  String get settingsResetProgressSub => 'Clears map, journal, and best score';

  @override
  String get settingsReplayOnboarding => 'Replay introduction';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get resetProgressTitle => 'Reset progress?';

  @override
  String get resetProgressBody =>
      'This clears your Chroma Map nodes, journal stickers, and best score. It cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get progressResetDone => 'Expedition progress reset';

  @override
  String get modeFamilyTitle => 'Family Mission';

  @override
  String get modeFamilySubtitle => 'Gentle co-op at home';

  @override
  String get modeFamilyAudience => 'Parents + kids · ages 5+';

  @override
  String get modeFamilyIntro =>
      'Welcome, explorers! We will hunt together — no rush, all teamwork.';

  @override
  String get modeFriendsTitle => 'Friends Hunt';

  @override
  String get modeFriendsSubtitle => 'Speed, streaks, laughs';

  @override
  String get modeFriendsAudience => 'Teens & adults · 2–6 players';

  @override
  String get modeFriendsIntro =>
      'Friends mode activated! Stack streaks and beat the clock — camera bonus optional.';

  @override
  String get modePartyTitle => 'Party Mission';

  @override
  String get modePartySubtitle => 'Room hunt · camera off';

  @override
  String get modePartyAudience => 'Game night · 4–8 players';

  @override
  String get modePartyIntro =>
      'Party time! Pass the device, hunt in the room, and confirm as a group.';

  @override
  String get modeTeamTitle => 'Team Expedition';

  @override
  String get modeTeamSubtitle => 'Workplace-safe missions';

  @override
  String get modeTeamAudience => 'Colleagues · retreats';

  @override
  String get modeTeamIntro =>
      'Team Expedition briefing. Neutral missions, shared scoreboard, no camera required.';

  @override
  String get modeKidsTitle => 'Kids Co-Op';

  @override
  String get modeKidsSubtitle => 'Picture clues · shared meter';

  @override
  String get modeKidsAudience => 'Siblings & classrooms · 5–10';

  @override
  String get modeKidsIntro =>
      'Hi team! Use the picture clues and help each other — everyone wins together.';

  @override
  String get sessionSetupBox => 'Hunt-Hue Box setup';

  @override
  String get sessionPlayers => 'Players';

  @override
  String get sessionTeams => 'Teams';

  @override
  String sessionTeamName(int number) {
    return 'Team $number name';
  }

  @override
  String sessionSummary(int players, int teams, int missions) {
    return '$players players · $teams teams · $missions missions';
  }

  @override
  String get sessionCameraOptional => 'Camera verify (optional bonus)';

  @override
  String get sessionCameraOptionalSub =>
      'Off by default. Party, Team, Kids, and Box stay camera-free.';

  @override
  String get sessionCameraDisabled => 'Camera disabled';

  @override
  String get sessionCameraDisabledSub => 'Manual and group confirm only.';

  @override
  String get sessionFeatureHunts => 'Hunts: objects, textures & combo cards';

  @override
  String get sessionFeaturePass => 'Pass-device + group confirm';

  @override
  String get sessionFeatureTurns => 'Individual turns';

  @override
  String get sessionFeatureScoreboard => 'Team scoreboard on every mission';

  @override
  String get sessionBeginBriefing => 'Begin briefing';

  @override
  String get passDeviceTitle => 'Pass the device';

  @override
  String passDeviceTeam(String name) {
    return 'Team $name';
  }

  @override
  String passDevicePlayer(int current, int total) {
    return 'Player $current of $total';
  }

  @override
  String get passDeviceNoPeek =>
      'Don\'t peek at the next mission until it\'s your turn!';

  @override
  String get passDeviceReady => 'I\'m ready — show mission';

  @override
  String get chromaMapEmpty =>
      'Complete a chapter to light up your first region on the map.';

  @override
  String chromaMapProgress(int count) {
    return 'Your expedition has unlocked $count map nodes. Keep hunting to reveal more.';
  }

  @override
  String chromaMapRegions(int count) {
    return '$count regions explored';
  }

  @override
  String get spiritBoxIntro =>
      'Hunt-Hue Box mode! Draw missions from your physical deck — this device is the scorekeeper.';

  @override
  String spiritMissionReady(int number, String team) {
    return 'Mission $number — $team, ready?';
  }

  @override
  String get spiritExplorers => 'Explorers';

  @override
  String get spiritHuntGreat => 'Stunning hunt! The Chroma Meter surges.';

  @override
  String get spiritHuntGood => 'Nice find — keep the expedition rolling.';

  @override
  String get spiritRematch =>
      'Spirit Rematch! Twist: try the object hunt another way.';

  @override
  String get spiritMapUnlock =>
      'Brilliant sync! A new region glows on the Chroma Map.';

  @override
  String get spiritMapProgress =>
      'Nice hunt — the Expedition remembers this chapter.';

  @override
  String get huntHueBox => 'Hunt-Hue Box';

  @override
  String get whatsInside => 'What\'s inside';

  @override
  String boxCardsCount(int count) {
    return '$count mission cards (object, texture, combo hunts)';
  }
}
