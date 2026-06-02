import 'package:flutter/material.dart';

enum SessionMode { family, friends, party, team, kids }

class ModeProfile {
  const ModeProfile({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.audience,
    required this.icon,
    required this.gradient,
    required this.cameraAllowed,
    required this.cameraDefault,
    required this.usePictureClues,
    required this.useGroupConfirm,
    required this.showStreaks,
    required this.neutralCopy,
    required this.missionSeconds,
    required this.chapterLength,
    required this.spiritIntro,
  });

  final SessionMode mode;
  final String title;
  final String subtitle;
  final String audience;
  final IconData icon;
  final List<Color> gradient;
  final bool cameraAllowed;
  final bool cameraDefault;
  final bool usePictureClues;
  final bool useGroupConfirm;
  final bool showStreaks;
  final bool neutralCopy;
  final int missionSeconds;
  final int chapterLength;
  final String spiritIntro;

  static ModeProfile forMode(SessionMode mode) =>
      profiles.firstWhere((p) => p.mode == mode);

  static const profiles = [
    ModeProfile(
      mode: SessionMode.family,
      title: 'Family Mission',
      subtitle: 'Gentle co-op at home',
      audience: 'Parents + kids · ages 5+',
      icon: Icons.family_restroom,
      gradient: [Color(0xFF2D6A4F), Color(0xFF95D5B2)],
      cameraAllowed: true,
      cameraDefault: false,
      usePictureClues: false,
      useGroupConfirm: false,
      showStreaks: false,
      neutralCopy: false,
      missionSeconds: 90,
      chapterLength: 4,
      spiritIntro:
          'Welcome, explorers! We will hunt colours together — no rush, all teamwork.',
    ),
    ModeProfile(
      mode: SessionMode.friends,
      title: 'Friends Hunt',
      subtitle: 'Speed, streaks, laughs',
      audience: 'Teens & adults · 2–6 players',
      icon: Icons.groups_2,
      gradient: [Color(0xFF5A189A), Color(0xFFFF6B9D)],
      cameraAllowed: true,
      cameraDefault: false,
      usePictureClues: false,
      useGroupConfirm: false,
      showStreaks: true,
      neutralCopy: false,
      missionSeconds: 60,
      chapterLength: 4,
      spiritIntro:
          'Friends mode activated! Stack streaks and beat the clock — camera bonus optional.',
    ),
    ModeProfile(
      mode: SessionMode.party,
      title: 'Party Mission',
      subtitle: 'Room hunt · camera off',
      audience: 'Game night · 4–8 players',
      icon: Icons.celebration,
      gradient: [Color(0xFFB5179E), Color(0xFFF72585)],
      cameraAllowed: false,
      cameraDefault: false,
      usePictureClues: false,
      useGroupConfirm: true,
      showStreaks: false,
      neutralCopy: false,
      missionSeconds: 45,
      chapterLength: 5,
      spiritIntro:
          'Party time! Pass the device, hunt colours in the room, and confirm as a group.',
    ),
    ModeProfile(
      mode: SessionMode.team,
      title: 'Team Expedition',
      subtitle: 'Workplace-safe missions',
      audience: 'Colleagues · retreats',
      icon: Icons.business_center,
      gradient: [Color(0xFF1B263B), Color(0xFF415A77)],
      cameraAllowed: false,
      cameraDefault: false,
      usePictureClues: false,
      useGroupConfirm: true,
      showStreaks: false,
      neutralCopy: true,
      missionSeconds: 75,
      chapterLength: 4,
      spiritIntro:
          'Team Expedition briefing. Neutral missions, shared scoreboard, no camera required.',
    ),
    ModeProfile(
      mode: SessionMode.kids,
      title: 'Kids Co-Op',
      subtitle: 'Picture clues · shared meter',
      audience: 'Siblings & classrooms · 5–10',
      icon: Icons.child_care,
      gradient: [Color(0xFF0077B6), Color(0xFF90E0EF)],
      cameraAllowed: false,
      cameraDefault: false,
      usePictureClues: true,
      useGroupConfirm: true,
      showStreaks: false,
      neutralCopy: false,
      missionSeconds: 120,
      chapterLength: 4,
      spiritIntro:
          'Hi team! Use the picture clues and help each other — everyone wins together.',
    ),
  ];
}
