// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Hue Hunt';

  @override
  String get subBrand => 'Misión familiar';

  @override
  String get tagline => 'La expedición cromática';

  @override
  String get studioName => 'NovaLumina Studio';

  @override
  String get homeHeroBody =>
      'Encuentra objetos reales en cualquier habitación: dibuja, colecciona, relevos y duelos con el Espíritu del color como anfitrión.';

  @override
  String get statBestScore => 'Mejor puntuación';

  @override
  String get statMapNodes => 'Nodos del mapa';

  @override
  String get statStickers => 'Pegatinas';

  @override
  String playMode(String mode) {
    return 'Jugar $mode';
  }

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get chooseMode => 'Elige un modo';

  @override
  String get huntHueBoxButton => 'Hunt-Hue Box — mesa + app';

  @override
  String get chromaMap => 'Mapa cromático';

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Ajustes';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get startFamilyMission => 'Iniciar misión familiar';

  @override
  String get exploreAllModes => 'Explorar todos los modos';

  @override
  String get onboardingHuntTitle => 'Busca cosas reales';

  @override
  String get onboardingHuntBody =>
      'Cada misión pide encontrar objetos, texturas o combinaciones en la habitación, no muestras de color planas. Funciona en cualquier casa, oficina o fiesta.';

  @override
  String get onboardingPassTitle => 'Un teléfono, todo el grupo';

  @override
  String get onboardingPassBody =>
      'Pasa el dispositivo entre jugadores. Confirmen los hallazgos juntos. Equipos, puntuación y el Espíritu del color mantienen la energía sin que todos usen pantalla.';

  @override
  String get onboardingBoxTitle => 'Digital o de mesa';

  @override
  String get onboardingBoxBody =>
      'Juega en la app o usa la Hunt-Hue Box sin teléfonos. Las mismas misiones, las mismas risas: tú eliges.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Predeterminado del sistema';

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
  String get settingsGameControls => 'Controles del juego';

  @override
  String get settingsSoundEffects => 'Efectos de sonido';

  @override
  String get settingsSoundEffectsSub =>
      'Voz del Espíritu, Game Show Drop y señales de misión';

  @override
  String get settingsSpiritHost => 'Anfitrión Hue Spirit';

  @override
  String get settingsForgeDefaults => 'Spirit Forge';

  @override
  String get settingsDefaultOpenRoom => 'Abrir sala de expedición';

  @override
  String get settingsDefaultOpenRoomSub =>
      'Otros teléfonos se unen en la misma Wi‑Fi';

  @override
  String get settingsGameShowReveals => 'Revelaciones Game Show Drop';

  @override
  String get settingsGameShowRevealsSub =>
      'Cuenta atrás con voz a pantalla completa antes de cada misión';

  @override
  String get settingsMissionContentNote =>
      'Los textos de misión siguen en inglés; los menús usan tu idioma.';

  @override
  String get settingsHaptics => 'Vibración háptica';

  @override
  String get settingsHapticsSub => 'Al pasar el dispositivo y confirmar';

  @override
  String get settingsSpiritHints => 'Pistas del Espíritu del color';

  @override
  String get settingsSpiritHintsSub => 'Mensajes del narrador entre misiones';

  @override
  String get settingsPassReminders => 'Recordatorios al pasar el móvil';

  @override
  String get settingsPassRemindersSub => 'Avisos extra al entregar el teléfono';

  @override
  String get settingsMissionTimer => 'Temporizador de misión';

  @override
  String get settingsTimerShort => 'Corto (−25%)';

  @override
  String get settingsTimerStandard => 'Estándar';

  @override
  String get settingsTimerLong => 'Largo (+25%)';

  @override
  String get settingsCameraDefault => 'Cámara bonus por defecto';

  @override
  String get settingsCameraDefaultSub =>
      'Cuando el modo permite verificación opcional';

  @override
  String get settingsData => 'Datos y privacidad';

  @override
  String get settingsResetProgress => 'Restablecer progreso';

  @override
  String get settingsResetProgressSub =>
      'Borra mapa, diario y mejor puntuación';

  @override
  String get settingsReplayOnboarding => 'Ver introducción otra vez';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String settingsVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get resetProgressTitle => '¿Restablecer progreso?';

  @override
  String get resetProgressBody =>
      'Se borran nodos del mapa, pegatinas del diario y la mejor puntuación. No se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Restablecer';

  @override
  String get progressResetDone => 'Progreso restablecido';

  @override
  String get modeFamilyTitle => 'Misión familiar';

  @override
  String get modeFamilySubtitle => 'Cooperación suave en casa';

  @override
  String get modeFamilyAudience => 'Padres e hijos · desde 5 años';

  @override
  String get modeFamilyIntro =>
      '¡Bienvenidos, exploradores! Cazaremos juntos sin prisa, en equipo.';

  @override
  String get modeFriendsTitle => 'Caza con amigos';

  @override
  String get modeFriendsSubtitle => 'Velocidad, rachas, risas';

  @override
  String get modeFriendsAudience => 'Adolescentes y adultos · 2–6 jugadores';

  @override
  String get modeFriendsIntro =>
      '¡Modo amigos! Acumula rachas y vence el reloj; cámara opcional.';

  @override
  String get modePartyTitle => 'Misión fiesta';

  @override
  String get modePartySubtitle => 'Búsqueda en la sala · sin cámara';

  @override
  String get modePartyAudience => 'Noche de juegos · 4–8 jugadores';

  @override
  String get modePartyIntro =>
      '¡Hora de fiesta! Pasa el móvil, busca en la sala y confirmen en grupo.';

  @override
  String get modeTeamTitle => 'Expedición en equipo';

  @override
  String get modeTeamSubtitle => 'Misiones aptas para trabajo';

  @override
  String get modeTeamAudience => 'Colegas · retiros';

  @override
  String get modeTeamIntro =>
      'Briefing de equipo. Misiones neutras, marcador compartido, sin cámara.';

  @override
  String get modeKidsTitle => 'Cooperación infantil';

  @override
  String get modeKidsSubtitle => 'Pistas visuales · medidor compartido';

  @override
  String get modeKidsAudience => 'Hermanos y aulas · 5–10';

  @override
  String get modeKidsIntro =>
      '¡Hola equipo! Usen las pistas visuales y ayúdense: todos ganan juntos.';

  @override
  String get sessionSetupBox => 'Configuración Hunt-Hue Box';

  @override
  String get sessionPlayers => 'Jugadores';

  @override
  String get sessionTeams => 'Equipos';

  @override
  String sessionTeamName(int number) {
    return 'Nombre del equipo $number';
  }

  @override
  String sessionSummary(int players, int teams, int missions) {
    return '$players jugadores · $teams equipos · $missions misiones';
  }

  @override
  String get sessionCameraOptional =>
      'Verificación con cámara (bonus opcional)';

  @override
  String get sessionCameraOptionalSub =>
      'Desactivada por defecto. Fiesta, equipo, niños y caja sin cámara.';

  @override
  String get sessionCameraDisabled => 'Cámara desactivada';

  @override
  String get sessionCameraDisabledSub => 'Solo confirmación manual y en grupo.';

  @override
  String get sessionFeatureHunts => 'Caza: objetos, texturas y cartas combo';

  @override
  String get sessionFeaturePass => 'Pasar móvil + confirmación grupal';

  @override
  String get sessionFeatureTurns => 'Turnos individuales';

  @override
  String get sessionFeatureScoreboard => 'Marcador de equipo en cada misión';

  @override
  String get sessionBeginBriefing => 'Comenzar briefing';

  @override
  String get passDeviceTitle => 'Pasa el dispositivo';

  @override
  String passDeviceTeam(String name) {
    return 'Equipo $name';
  }

  @override
  String passDevicePlayer(int current, int total) {
    return 'Jugador $current de $total';
  }

  @override
  String get passDeviceNoPeek =>
      '¡No mires la siguiente misión hasta tu turno!';

  @override
  String get passDeviceReady => 'Listo — mostrar misión';

  @override
  String get chromaMapEmpty =>
      'Completa un capítulo para iluminar tu primera región en el mapa.';

  @override
  String chromaMapProgress(int count) {
    return 'Tu expedición ha desbloqueado $count nodos del mapa. Sigue cazando para descubrir más.';
  }

  @override
  String chromaMapRegions(int count) {
    return '$count regiones exploradas';
  }

  @override
  String get spiritBoxIntro =>
      '¡Modo Hunt-Hue Box! Saca misiones del mazo físico: este dispositivo lleva la puntuación.';

  @override
  String spiritMissionReady(int number, String team) {
    return 'Misión $number — $team, ¿listos?';
  }

  @override
  String get spiritExplorers => 'Exploradores';

  @override
  String get spiritHuntGreat =>
      '¡Caza impresionante! El medidor cromático sube.';

  @override
  String get spiritHuntGood => 'Buen hallazgo — sigue la expedición.';

  @override
  String get spiritRematch =>
      '¡Revancha del espíritu! Giro: prueba la caza de otra forma.';

  @override
  String get spiritMapUnlock =>
      '¡Sincronía brillante! Una nueva región brilla en el mapa.';

  @override
  String get spiritMapProgress =>
      'Buena caza — la expedición recuerda este capítulo.';

  @override
  String get huntHueBox => 'Hunt-Hue Box';

  @override
  String get whatsInside => 'Qué incluye';

  @override
  String boxCardsCount(int count) {
    return '$count cartas de misión (objeto, textura, combo)';
  }
}
