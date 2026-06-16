// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Hue Hunt';

  @override
  String get subBrand => 'Mission familiale';

  @override
  String get tagline => 'L\'expédition chromatique';

  @override
  String get studioName => 'NovaLumina Studio';

  @override
  String get homeHeroBody =>
      'Cherchez de vrais objets dans n\'importe quelle pièce — croquis, collecte, relais et duels avec l\'Esprit des teintes comme hôte.';

  @override
  String get statBestScore => 'Meilleur score';

  @override
  String get statMapNodes => 'Nœuds carte';

  @override
  String get statStickers => 'Autocollants';

  @override
  String playMode(String mode) {
    return 'Jouer $mode';
  }

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get chooseMode => 'Choisir un mode';

  @override
  String get huntHueBoxButton => 'Hunt-Hue Box — plateau + appli';

  @override
  String get chromaMap => 'Carte chroma';

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Réglages';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get startFamilyMission => 'Lancer mission familiale';

  @override
  String get exploreAllModes => 'Explorer tous les modes';

  @override
  String get onboardingHuntTitle => 'Chassez de vraies choses';

  @override
  String get onboardingHuntBody =>
      'Chaque mission demande de trouver objets, textures ou combinaisons — pas des pastilles de couleur. Fonctionne partout : maison, bureau, fête.';

  @override
  String get onboardingPassTitle => 'Un téléphone, tout le groupe';

  @override
  String get onboardingPassBody =>
      'Passez l\'appareil entre joueurs. Validez les trouvailles ensemble. Équipes, score et l\'Esprit des couleurs sans écran pour tous.';

  @override
  String get onboardingBoxTitle => 'Numérique ou plateau';

  @override
  String get onboardingBoxBody =>
      'Jouez dans l\'appli ou avec la Hunt-Hue Box sans téléphone. Mêmes missions, mêmes rires — à vous de choisir.';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue du système';

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
  String get settingsGameControls => 'Contrôles de jeu';

  @override
  String get settingsSoundEffects => 'Effets sonores';

  @override
  String get settingsSoundEffectsSub =>
      'Voix de l\'Esprit, Game Show Drop et signaux de mission';

  @override
  String get settingsSpiritHost => 'Animateur Hue Spirit';

  @override
  String get settingsForgeDefaults => 'Spirit Forge';

  @override
  String get settingsDefaultOpenRoom => 'Ouvrir la salle d\'expédition';

  @override
  String get settingsDefaultOpenRoomSub =>
      'D\'autres téléphones rejoignent sur le même Wi‑Fi';

  @override
  String get settingsGameShowReveals => 'Annonces Game Show Drop';

  @override
  String get settingsGameShowRevealsSub =>
      'Compte à rebours vocal plein écran avant chaque mission';

  @override
  String get settingsMissionContentNote =>
      'Les cartes de mission restent en anglais ; l\'interface suit votre langue.';

  @override
  String get settingsHaptics => 'Retour haptique';

  @override
  String get settingsHapticsSub => 'Vibration au passage du téléphone';

  @override
  String get settingsSpiritHints => 'Indices de l\'Esprit des couleurs';

  @override
  String get settingsSpiritHintsSub => 'Messages du narrateur entre missions';

  @override
  String get settingsPassReminders => 'Rappels passage du téléphone';

  @override
  String get settingsPassRemindersSub =>
      'Invites supplémentaires au changement de joueur';

  @override
  String get settingsMissionTimer => 'Minuteur de mission';

  @override
  String get settingsTimerShort => 'Court (−25 %)';

  @override
  String get settingsTimerStandard => 'Standard';

  @override
  String get settingsTimerLong => 'Long (+25 %)';

  @override
  String get settingsCameraDefault => 'Bonus caméra par défaut';

  @override
  String get settingsCameraDefaultSub =>
      'Quand le mode autorise la vérification photo';

  @override
  String get settingsData => 'Données et confidentialité';

  @override
  String get settingsResetProgress => 'Réinitialiser la progression';

  @override
  String get settingsResetProgressSub =>
      'Efface carte, journal et meilleur score';

  @override
  String get settingsReplayOnboarding => 'Revoir l\'introduction';

  @override
  String get settingsAbout => 'À propos';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get resetProgressTitle => 'Réinitialiser la progression ?';

  @override
  String get resetProgressBody =>
      'Efface les nœuds de carte, autocollants du journal et le meilleur score. Irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get progressResetDone => 'Progression réinitialisée';

  @override
  String get modeFamilyTitle => 'Mission familiale';

  @override
  String get modeFamilySubtitle => 'Coop douce à la maison';

  @override
  String get modeFamilyAudience => 'Parents et enfants · dès 5 ans';

  @override
  String get modeFamilyIntro =>
      'Bienvenue, explorateurs ! Chasse ensemble, sans stress, en équipe.';

  @override
  String get modeFriendsTitle => 'Chasse entre amis';

  @override
  String get modeFriendsSubtitle => 'Vitesse, séries, rires';

  @override
  String get modeFriendsAudience => 'Ados et adultes · 2–6 joueurs';

  @override
  String get modeFriendsIntro =>
      'Mode amis activé ! Enchaînez les séries — bonus caméra optionnel.';

  @override
  String get modePartyTitle => 'Mission fête';

  @override
  String get modePartySubtitle => 'Chasse en salle · sans caméra';

  @override
  String get modePartyAudience => 'Soirée jeux · 4–8 joueurs';

  @override
  String get modePartyIntro =>
      'C\'est la fête ! Passez le téléphone, cherchez dans la pièce, validez en groupe.';

  @override
  String get modeTeamTitle => 'Expédition d\'équipe';

  @override
  String get modeTeamSubtitle => 'Missions adaptées au travail';

  @override
  String get modeTeamAudience => 'Collègues · séminaires';

  @override
  String get modeTeamIntro =>
      'Briefing d\'équipe. Missions neutres, tableau partagé, pas de caméra.';

  @override
  String get modeKidsTitle => 'Coop enfants';

  @override
  String get modeKidsSubtitle => 'Indices visuels · jauge partagée';

  @override
  String get modeKidsAudience => 'Fratrie et classes · 5–10';

  @override
  String get modeKidsIntro =>
      'Salut l\'équipe ! Utilisez les indices visuels — tout le monde gagne ensemble.';

  @override
  String get sessionSetupBox => 'Configuration Hunt-Hue Box';

  @override
  String get sessionPlayers => 'Joueurs';

  @override
  String get sessionTeams => 'Équipes';

  @override
  String sessionTeamName(int number) {
    return 'Nom équipe $number';
  }

  @override
  String sessionSummary(int players, int teams, int missions) {
    return '$players joueurs · $teams équipes · $missions missions';
  }

  @override
  String get sessionCameraOptional => 'Vérification caméra (bonus optionnel)';

  @override
  String get sessionCameraOptionalSub =>
      'Désactivée par défaut. Fête, équipe, enfants et boîte sans caméra.';

  @override
  String get sessionCameraDisabled => 'Caméra désactivée';

  @override
  String get sessionCameraDisabledSub =>
      'Confirmation manuelle et de groupe uniquement.';

  @override
  String get sessionFeatureHunts =>
      'Chasses : objets, textures et cartes combo';

  @override
  String get sessionFeaturePass => 'Passage du téléphone + validation groupe';

  @override
  String get sessionFeatureTurns => 'Tours individuels';

  @override
  String get sessionFeatureScoreboard => 'Tableau d\'équipe à chaque mission';

  @override
  String get sessionBeginBriefing => 'Commencer le briefing';

  @override
  String get passDeviceTitle => 'Passez l\'appareil';

  @override
  String passDeviceTeam(String name) {
    return 'Équipe $name';
  }

  @override
  String passDevicePlayer(int current, int total) {
    return 'Joueur $current sur $total';
  }

  @override
  String get passDeviceNoPeek =>
      'Ne regardez pas la mission suivante avant votre tour !';

  @override
  String get passDeviceReady => 'Prêt — afficher la mission';

  @override
  String get chromaMapEmpty =>
      'Terminez un chapitre pour illuminer votre première région sur la carte.';

  @override
  String chromaMapProgress(int count) {
    return 'Votre expédition a débloqué $count nœuds de carte. Continuez la chasse.';
  }

  @override
  String chromaMapRegions(int count) {
    return '$count régions explorées';
  }

  @override
  String get spiritBoxIntro =>
      'Mode Hunt-Hue Box ! Piochez dans le paquet physique — cet appareil tient le score.';

  @override
  String spiritMissionReady(int number, String team) {
    return 'Mission $number — $team, prêts ?';
  }

  @override
  String get spiritExplorers => 'Explorateurs';

  @override
  String get spiritHuntGreat => 'Chasse magnifique ! Le compteur chroma monte.';

  @override
  String get spiritHuntGood => 'Belle trouvaille — l\'expédition continue.';

  @override
  String get spiritRematch =>
      'Revanche de l\'esprit ! Astuce : retentez la chasse autrement.';

  @override
  String get spiritMapUnlock =>
      'Synchronisation brillante ! Une nouvelle région s\'allume sur la carte.';

  @override
  String get spiritMapProgress =>
      'Belle chasse — l\'expédition se souvient de ce chapitre.';

  @override
  String get huntHueBox => 'Hunt-Hue Box';

  @override
  String get whatsInside => 'Contenu de la boîte';

  @override
  String boxCardsCount(int count) {
    return '$count cartes mission (objet, texture, combo)';
  }
}
