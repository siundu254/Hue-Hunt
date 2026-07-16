import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Raiders'**
  String get appTitle;

  /// No description provided for @subBrand.
  ///
  /// In en, this message translates to:
  /// **'Raid Missions'**
  String get subBrand;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Search the room. Beat the clock.'**
  String get tagline;

  /// No description provided for @studioName.
  ///
  /// In en, this message translates to:
  /// **'NovaLumina Studio'**
  String get studioName;

  /// No description provided for @homeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Room Raiders forges object-led missions for your room — app, team phones, spectators, or Hunt-Hue Box tabletop.'**
  String get homeHeroBody;

  /// No description provided for @statBestScore.
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get statBestScore;

  /// No description provided for @statMapNodes.
  ///
  /// In en, this message translates to:
  /// **'Map nodes'**
  String get statMapNodes;

  /// No description provided for @statStickers.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get statStickers;

  /// No description provided for @playMode.
  ///
  /// In en, this message translates to:
  /// **'Play {mode}'**
  String playMode(String mode);

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @chooseMode.
  ///
  /// In en, this message translates to:
  /// **'Choose a mode'**
  String get chooseMode;

  /// No description provided for @huntHueBoxButton.
  ///
  /// In en, this message translates to:
  /// **'Hunt-Hue Box — tabletop + app'**
  String get huntHueBoxButton;

  /// No description provided for @chromaMap.
  ///
  /// In en, this message translates to:
  /// **'Raid Map'**
  String get chromaMap;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @startFamilyMission.
  ///
  /// In en, this message translates to:
  /// **'Start Family Mission'**
  String get startFamilyMission;

  /// No description provided for @exploreAllModes.
  ///
  /// In en, this message translates to:
  /// **'Explore all modes'**
  String get exploreAllModes;

  /// No description provided for @onboardingHuntTitle.
  ///
  /// In en, this message translates to:
  /// **'Hunt real things'**
  String get onboardingHuntTitle;

  /// No description provided for @onboardingHuntBody.
  ///
  /// In en, this message translates to:
  /// **'Every mission asks your group to find objects, textures, or combos in the room — never colour-based hunts or swatches. Works in any home, office, or party.'**
  String get onboardingHuntBody;

  /// No description provided for @onboardingPassTitle.
  ///
  /// In en, this message translates to:
  /// **'One phone, whole group'**
  String get onboardingPassTitle;

  /// No description provided for @onboardingPassBody.
  ///
  /// In en, this message translates to:
  /// **'Pass the device between players. Secret objectives, sudden-death timers, and the Raid Captain keep energy high without everyone on a screen.'**
  String get onboardingPassBody;

  /// No description provided for @onboardingBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital or tabletop'**
  String get onboardingBoxTitle;

  /// No description provided for @onboardingBoxBody.
  ///
  /// In en, this message translates to:
  /// **'Play in the app, or use the Hunt-Hue Box with zero phones. Same missions, same laughs — your choice.'**
  String get onboardingBoxBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageEs;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageDe;

  /// No description provided for @settingsLanguageZh.
  ///
  /// In en, this message translates to:
  /// **'中文 (简体)'**
  String get settingsLanguageZh;

  /// No description provided for @settingsGameControls.
  ///
  /// In en, this message translates to:
  /// **'Game controls'**
  String get settingsGameControls;

  /// No description provided for @settingsSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSoundEffects;

  /// No description provided for @settingsSoundEffectsSub.
  ///
  /// In en, this message translates to:
  /// **'Raid Captain voice, Game Show Drop, and mission cues'**
  String get settingsSoundEffectsSub;

  /// No description provided for @settingsSpiritHost.
  ///
  /// In en, this message translates to:
  /// **'Raid Captain host'**
  String get settingsSpiritHost;

  /// No description provided for @settingsForgeDefaults.
  ///
  /// In en, this message translates to:
  /// **'Spirit Forge'**
  String get settingsForgeDefaults;

  /// No description provided for @settingsDefaultOpenRoom.
  ///
  /// In en, this message translates to:
  /// **'Open expedition room'**
  String get settingsDefaultOpenRoom;

  /// No description provided for @settingsDefaultOpenRoomSub.
  ///
  /// In en, this message translates to:
  /// **'Team and spectator phones join on the same Wi‑Fi'**
  String get settingsDefaultOpenRoomSub;

  /// No description provided for @settingsGameShowReveals.
  ///
  /// In en, this message translates to:
  /// **'Game Show Drop reveals'**
  String get settingsGameShowReveals;

  /// No description provided for @settingsGameShowRevealsSub.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen voice countdown before each mission'**
  String get settingsGameShowRevealsSub;

  /// No description provided for @settingsMissionContentNote.
  ///
  /// In en, this message translates to:
  /// **'Mission prompts stay in English; all menus follow your language.'**
  String get settingsMissionContentNote;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHaptics;

  /// No description provided for @settingsHapticsSub.
  ///
  /// In en, this message translates to:
  /// **'Vibration on pass-device and confirms'**
  String get settingsHapticsSub;

  /// No description provided for @settingsSpiritHints.
  ///
  /// In en, this message translates to:
  /// **'Raid Captain hints'**
  String get settingsSpiritHints;

  /// No description provided for @settingsSpiritHintsSub.
  ///
  /// In en, this message translates to:
  /// **'Narrator messages between missions'**
  String get settingsSpiritHintsSub;

  /// No description provided for @settingsPassReminders.
  ///
  /// In en, this message translates to:
  /// **'Pass-device reminders'**
  String get settingsPassReminders;

  /// No description provided for @settingsPassRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'Extra prompts when handing off the phone'**
  String get settingsPassRemindersSub;

  /// No description provided for @settingsMissionTimer.
  ///
  /// In en, this message translates to:
  /// **'Mission timer'**
  String get settingsMissionTimer;

  /// No description provided for @settingsTimerShort.
  ///
  /// In en, this message translates to:
  /// **'Short (−25%)'**
  String get settingsTimerShort;

  /// No description provided for @settingsTimerStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get settingsTimerStandard;

  /// No description provided for @settingsTimerLong.
  ///
  /// In en, this message translates to:
  /// **'Long (+25%)'**
  String get settingsTimerLong;

  /// No description provided for @settingsCameraDefault.
  ///
  /// In en, this message translates to:
  /// **'Default camera bonus'**
  String get settingsCameraDefault;

  /// No description provided for @settingsCameraDefaultSub.
  ///
  /// In en, this message translates to:
  /// **'When a mode allows optional photo verify'**
  String get settingsCameraDefaultSub;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data & privacy'**
  String get settingsData;

  /// No description provided for @settingsResetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset expedition progress'**
  String get settingsResetProgress;

  /// No description provided for @settingsResetProgressSub.
  ///
  /// In en, this message translates to:
  /// **'Clears map, journal, and best score'**
  String get settingsResetProgressSub;

  /// No description provided for @settingsReplayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay introduction'**
  String get settingsReplayOnboarding;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @resetProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset progress?'**
  String get resetProgressTitle;

  /// No description provided for @resetProgressBody.
  ///
  /// In en, this message translates to:
  /// **'This clears your Raid Map nodes, journal stickers, and best score. It cannot be undone.'**
  String get resetProgressBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @progressResetDone.
  ///
  /// In en, this message translates to:
  /// **'Expedition progress reset'**
  String get progressResetDone;

  /// No description provided for @modeFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Mission'**
  String get modeFamilyTitle;

  /// No description provided for @modeFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle co-op at home'**
  String get modeFamilySubtitle;

  /// No description provided for @modeFamilyAudience.
  ///
  /// In en, this message translates to:
  /// **'Parents + kids · ages 5+'**
  String get modeFamilyAudience;

  /// No description provided for @modeFamilyIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome, explorers! We will hunt together — no rush, all teamwork.'**
  String get modeFamilyIntro;

  /// No description provided for @modeFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends Hunt'**
  String get modeFriendsTitle;

  /// No description provided for @modeFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Speed, streaks, laughs'**
  String get modeFriendsSubtitle;

  /// No description provided for @modeFriendsAudience.
  ///
  /// In en, this message translates to:
  /// **'Teens & adults · 2–6 players'**
  String get modeFriendsAudience;

  /// No description provided for @modeFriendsIntro.
  ///
  /// In en, this message translates to:
  /// **'Friends mode activated! Stack streaks and beat the clock — camera bonus optional.'**
  String get modeFriendsIntro;

  /// No description provided for @modePartyTitle.
  ///
  /// In en, this message translates to:
  /// **'Party Mission'**
  String get modePartyTitle;

  /// No description provided for @modePartySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Room hunt · camera off'**
  String get modePartySubtitle;

  /// No description provided for @modePartyAudience.
  ///
  /// In en, this message translates to:
  /// **'Game night · 4–8 players'**
  String get modePartyAudience;

  /// No description provided for @modePartyIntro.
  ///
  /// In en, this message translates to:
  /// **'Party time! Pass the device, hunt in the room, and confirm as a group.'**
  String get modePartyIntro;

  /// No description provided for @modeTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Expedition'**
  String get modeTeamTitle;

  /// No description provided for @modeTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workplace-safe missions'**
  String get modeTeamSubtitle;

  /// No description provided for @modeTeamAudience.
  ///
  /// In en, this message translates to:
  /// **'Colleagues · retreats'**
  String get modeTeamAudience;

  /// No description provided for @modeTeamIntro.
  ///
  /// In en, this message translates to:
  /// **'Team Expedition briefing. Neutral missions, shared scoreboard, no camera required.'**
  String get modeTeamIntro;

  /// No description provided for @modeKidsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kids Co-Op'**
  String get modeKidsTitle;

  /// No description provided for @modeKidsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Picture clues · shared meter'**
  String get modeKidsSubtitle;

  /// No description provided for @modeKidsAudience.
  ///
  /// In en, this message translates to:
  /// **'Siblings & classrooms · 5–10'**
  String get modeKidsAudience;

  /// No description provided for @modeKidsIntro.
  ///
  /// In en, this message translates to:
  /// **'Hi team! Use the picture clues and help each other — everyone wins together.'**
  String get modeKidsIntro;

  /// No description provided for @sessionSetupBox.
  ///
  /// In en, this message translates to:
  /// **'Hunt-Hue Box setup'**
  String get sessionSetupBox;

  /// No description provided for @sessionPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get sessionPlayers;

  /// No description provided for @sessionTeams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get sessionTeams;

  /// No description provided for @sessionTeamName.
  ///
  /// In en, this message translates to:
  /// **'Team {number} name'**
  String sessionTeamName(int number);

  /// No description provided for @sessionSummary.
  ///
  /// In en, this message translates to:
  /// **'{players} players · {teams} teams · {missions} missions'**
  String sessionSummary(int players, int teams, int missions);

  /// No description provided for @sessionCameraOptional.
  ///
  /// In en, this message translates to:
  /// **'Camera verify (optional bonus)'**
  String get sessionCameraOptional;

  /// No description provided for @sessionCameraOptionalSub.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Party, Team, Kids, and Box stay camera-free.'**
  String get sessionCameraOptionalSub;

  /// No description provided for @sessionCameraDisabled.
  ///
  /// In en, this message translates to:
  /// **'Camera disabled'**
  String get sessionCameraDisabled;

  /// No description provided for @sessionCameraDisabledSub.
  ///
  /// In en, this message translates to:
  /// **'Manual and group confirm only.'**
  String get sessionCameraDisabledSub;

  /// No description provided for @sessionFeatureHunts.
  ///
  /// In en, this message translates to:
  /// **'Hunts: objects, textures & combo cards'**
  String get sessionFeatureHunts;

  /// No description provided for @sessionFeaturePass.
  ///
  /// In en, this message translates to:
  /// **'Pass-device + group confirm'**
  String get sessionFeaturePass;

  /// No description provided for @sessionFeatureTurns.
  ///
  /// In en, this message translates to:
  /// **'Individual turns'**
  String get sessionFeatureTurns;

  /// No description provided for @sessionFeatureScoreboard.
  ///
  /// In en, this message translates to:
  /// **'Team scoreboard on every mission'**
  String get sessionFeatureScoreboard;

  /// No description provided for @sessionBeginBriefing.
  ///
  /// In en, this message translates to:
  /// **'Begin briefing'**
  String get sessionBeginBriefing;

  /// No description provided for @passDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Pass the device'**
  String get passDeviceTitle;

  /// No description provided for @passDeviceTeam.
  ///
  /// In en, this message translates to:
  /// **'Team {name}'**
  String passDeviceTeam(String name);

  /// No description provided for @passDevicePlayer.
  ///
  /// In en, this message translates to:
  /// **'Player {current} of {total}'**
  String passDevicePlayer(int current, int total);

  /// No description provided for @passDeviceNoPeek.
  ///
  /// In en, this message translates to:
  /// **'Don\'t peek at the next mission until it\'s your turn!'**
  String get passDeviceNoPeek;

  /// No description provided for @passDeviceReady.
  ///
  /// In en, this message translates to:
  /// **'I\'m ready — show mission'**
  String get passDeviceReady;

  /// No description provided for @chromaMapEmpty.
  ///
  /// In en, this message translates to:
  /// **'Complete a chapter to light up your first region on the map.'**
  String get chromaMapEmpty;

  /// No description provided for @chromaMapProgress.
  ///
  /// In en, this message translates to:
  /// **'Your expedition has unlocked {count} map nodes. Keep hunting to reveal more.'**
  String chromaMapProgress(int count);

  /// No description provided for @chromaMapRegions.
  ///
  /// In en, this message translates to:
  /// **'{count} regions explored'**
  String chromaMapRegions(int count);

  /// No description provided for @spiritBoxIntro.
  ///
  /// In en, this message translates to:
  /// **'Hunt-Hue Box mode! Draw object-led missions from your physical deck — Room Raiders is the scorekeeper.'**
  String get spiritBoxIntro;

  /// No description provided for @spiritMissionReady.
  ///
  /// In en, this message translates to:
  /// **'Mission {number} — {team}, ready?'**
  String spiritMissionReady(int number, String team);

  /// No description provided for @spiritExplorers.
  ///
  /// In en, this message translates to:
  /// **'Explorers'**
  String get spiritExplorers;

  /// No description provided for @spiritHuntGreat.
  ///
  /// In en, this message translates to:
  /// **'Stunning hunt! The Raid Meter surges.'**
  String get spiritHuntGreat;

  /// No description provided for @spiritHuntGood.
  ///
  /// In en, this message translates to:
  /// **'Nice find — keep the raid rolling.'**
  String get spiritHuntGood;

  /// No description provided for @spiritRematch.
  ///
  /// In en, this message translates to:
  /// **'Raid Rematch! Twist: try the object hunt another way.'**
  String get spiritRematch;

  /// No description provided for @spiritMapUnlock.
  ///
  /// In en, this message translates to:
  /// **'Brilliant sync! A new region glows on the Raid Map.'**
  String get spiritMapUnlock;

  /// No description provided for @spiritMapProgress.
  ///
  /// In en, this message translates to:
  /// **'Nice hunt — Room Raiders remembers this chapter.'**
  String get spiritMapProgress;

  /// No description provided for @huntHueBox.
  ///
  /// In en, this message translates to:
  /// **'Hunt-Hue Box'**
  String get huntHueBox;

  /// No description provided for @whatsInside.
  ///
  /// In en, this message translates to:
  /// **'What\'s inside'**
  String get whatsInside;

  /// No description provided for @boxCardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} mission cards (object, texture, combo hunts)'**
  String boxCardsCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
