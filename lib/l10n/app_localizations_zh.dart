// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Hue Hunt';

  @override
  String get subBrand => '家庭任务';

  @override
  String get tagline => '色彩远征';

  @override
  String get studioName => 'NovaLumina Studio';

  @override
  String get homeHeroBody => '在任何房间寻找真实物品——速写、收集、接力与团队竞赛，由色彩精灵主持。';

  @override
  String get statBestScore => '最高分';

  @override
  String get statMapNodes => '地图节点';

  @override
  String get statStickers => '贴纸';

  @override
  String playMode(String mode) {
    return '开始$mode';
  }

  @override
  String get howItWorks => '玩法说明';

  @override
  String get chooseMode => '选择模式';

  @override
  String get huntHueBoxButton => 'Hunt-Hue Box — 桌游 + 应用';

  @override
  String get chromaMap => '色彩地图';

  @override
  String get journal => '探险日志';

  @override
  String get settings => '设置';

  @override
  String get next => '下一步';

  @override
  String get skip => '跳过';

  @override
  String get startFamilyMission => '开始家庭任务';

  @override
  String get exploreAllModes => '浏览所有模式';

  @override
  String get onboardingHuntTitle => '寻找真实物品';

  @override
  String get onboardingHuntBody => '每项任务要求在房间内找到物品、质地或组合——不是平面色块。适用于家庭、办公室或派对。';

  @override
  String get onboardingPassTitle => '一部手机，全员参与';

  @override
  String get onboardingPassBody =>
      '在玩家之间传递设备，共同确认发现。队伍、得分与色彩精灵让聚会更有趣，无需每人盯着屏幕。';

  @override
  String get onboardingBoxTitle => '数字或桌游';

  @override
  String get onboardingBoxBody =>
      '在应用中游玩，或使用 Hunt-Hue Box 无需手机。相同任务，相同乐趣——由你选择。';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

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
  String get settingsGameControls => '游戏控制';

  @override
  String get settingsSoundEffects => '音效';

  @override
  String get settingsSoundEffectsSub => '色彩精灵语音、Game Show Drop 与任务提示音';

  @override
  String get settingsSpiritHost => '色彩精灵主持';

  @override
  String get settingsForgeDefaults => 'Spirit Forge';

  @override
  String get settingsDefaultOpenRoom => '默认开启远征房间';

  @override
  String get settingsDefaultOpenRoomSub => '同一 Wi‑Fi 下其他手机可加入';

  @override
  String get settingsGameShowReveals => 'Game Show Drop 揭晓';

  @override
  String get settingsGameShowRevealsSub => '每次任务前全屏语音倒计时';

  @override
  String get settingsMissionContentNote => '任务卡文本仍为英文；界面跟随所选语言。';

  @override
  String get settingsHaptics => '触觉反馈';

  @override
  String get settingsHapticsSub => '传递设备与确认时振动';

  @override
  String get settingsSpiritHints => '色彩精灵提示';

  @override
  String get settingsSpiritHintsSub => '任务之间的旁白信息';

  @override
  String get settingsPassReminders => '传递设备提醒';

  @override
  String get settingsPassRemindersSub => '交手机时的额外提示';

  @override
  String get settingsMissionTimer => '任务计时';

  @override
  String get settingsTimerShort => '短（−25%）';

  @override
  String get settingsTimerStandard => '标准';

  @override
  String get settingsTimerLong => '长（+25%）';

  @override
  String get settingsCameraDefault => '默认开启相机加分';

  @override
  String get settingsCameraDefaultSub => '当模式允许可选拍照验证时';

  @override
  String get settingsData => '数据与隐私';

  @override
  String get settingsResetProgress => '重置探险进度';

  @override
  String get settingsResetProgressSub => '清除地图、日志与最高分';

  @override
  String get settingsReplayOnboarding => '重新观看介绍';

  @override
  String get settingsAbout => '关于';

  @override
  String settingsVersion(String version) {
    return '版本 $version';
  }

  @override
  String get resetProgressTitle => '重置进度？';

  @override
  String get resetProgressBody => '将清除地图节点、日志贴纸与最高分，且无法撤销。';

  @override
  String get cancel => '取消';

  @override
  String get reset => '重置';

  @override
  String get progressResetDone => '进度已重置';

  @override
  String get modeFamilyTitle => '家庭任务';

  @override
  String get modeFamilySubtitle => '温馨居家合作';

  @override
  String get modeFamilyAudience => '家长与孩子 · 5 岁+';

  @override
  String get modeFamilyIntro => '欢迎，探险家！我们一起狩猎——不着急，团队合作。';

  @override
  String get modeFriendsTitle => '好友狩猎';

  @override
  String get modeFriendsSubtitle => '速度、连击、欢笑';

  @override
  String get modeFriendsAudience => '青少年与成人 · 2–6 人';

  @override
  String get modeFriendsIntro => '好友模式启动！累积连击、挑战计时——相机加分可选。';

  @override
  String get modePartyTitle => '派对任务';

  @override
  String get modePartySubtitle => '室内狩猎 · 无相机';

  @override
  String get modePartyAudience => '游戏之夜 · 4–8 人';

  @override
  String get modePartyIntro => '派对时间！传递设备，在房间内寻找，集体确认。';

  @override
  String get modeTeamTitle => '团队远征';

  @override
  String get modeTeamSubtitle => '适合职场的任务';

  @override
  String get modeTeamAudience => '同事 · 团建';

  @override
  String get modeTeamIntro => '团队简报。中性任务、共享记分，无需相机。';

  @override
  String get modeKidsTitle => '儿童合作';

  @override
  String get modeKidsSubtitle => '图画提示 · 共享计量';

  @override
  String get modeKidsAudience => '兄弟姐妹与课堂 · 5–10 人';

  @override
  String get modeKidsIntro => '大家好！使用图画提示，互相帮助——人人共赢。';

  @override
  String get sessionSetupBox => 'Hunt-Hue Box 设置';

  @override
  String get sessionPlayers => '玩家数';

  @override
  String get sessionTeams => '队伍数';

  @override
  String sessionTeamName(int number) {
    return '队伍 $number 名称';
  }

  @override
  String sessionSummary(int players, int teams, int missions) {
    return '$players 名玩家 · $teams 支队伍 · $missions 项任务';
  }

  @override
  String get sessionCameraOptional => '相机验证（可选加分）';

  @override
  String get sessionCameraOptionalSub => '默认关闭。派对、团队、儿童与盒装模式均无相机。';

  @override
  String get sessionCameraDisabled => '相机已禁用';

  @override
  String get sessionCameraDisabledSub => '仅手动与集体确认。';

  @override
  String get sessionFeatureHunts => '狩猎：物品、质地与组合卡';

  @override
  String get sessionFeaturePass => '传递设备 + 集体确认';

  @override
  String get sessionFeatureTurns => '个人回合';

  @override
  String get sessionFeatureScoreboard => '每项任务显示队伍得分';

  @override
  String get sessionBeginBriefing => '开始简报';

  @override
  String get passDeviceTitle => '请传递设备';

  @override
  String passDeviceTeam(String name) {
    return '队伍 $name';
  }

  @override
  String passDevicePlayer(int current, int total) {
    return '第 $current 位，共 $total 人';
  }

  @override
  String get passDeviceNoPeek => '轮到你之前不要偷看下一项任务！';

  @override
  String get passDeviceReady => '准备好了 — 显示任务';

  @override
  String get chromaMapEmpty => '完成一章即可点亮地图上的第一个区域。';

  @override
  String chromaMapProgress(int count) {
    return '你的远征已解锁 $count 个地图节点。继续狩猎以发现更多。';
  }

  @override
  String chromaMapRegions(int count) {
    return '已探索 $count 个区域';
  }

  @override
  String get spiritBoxIntro => 'Hunt-Hue Box 模式！从实体牌堆抽任务——本设备负责记分。';

  @override
  String spiritMissionReady(int number, String team) {
    return '任务 $number — $team，准备好了吗？';
  }

  @override
  String get spiritExplorers => '探险家';

  @override
  String get spiritHuntGreat => '精彩狩猎！色彩计量表飙升。';

  @override
  String get spiritHuntGood => '发现不错——远征继续。';

  @override
  String get spiritRematch => '精灵再战！转折：换种方式完成物品狩猎。';

  @override
  String get spiritMapUnlock => '完美同步！色彩地图上亮起新区域。';

  @override
  String get spiritMapProgress => '狩猎顺利——远征铭记这一章。';

  @override
  String get huntHueBox => 'Hunt-Hue Box';

  @override
  String get whatsInside => '盒内物品';

  @override
  String boxCardsCount(int count) {
    return '$count 张任务卡（物品、质地、组合狩猎）';
  }
}
