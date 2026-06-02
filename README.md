# Hue Hunt: Family Mission

**The Chroma Expedition** — NovaLumina Studio’s first social scavenger rollout.

Hunt real **objects, textures, and combos** in any room, plus short on-device missions (Forge, Echo, Relay, Duel, Ritual). Five modes for family, friends, parties, teams, and kids. **Hunt-Hue Box** adds a device-optional tabletop path.

## Run the demo

```bash
cd hue_hunt
flutter pub get
flutter run
```

Recommended: iOS Simulator or Android emulator in portrait. First launch shows a short onboarding; use **Play Family Mission** for the fastest investor walkthrough.

## What to show investors

1. **Home** — logo, stats, primary **Play** CTA, five mode cards  
2. **Family Mission** — object-led hunt → group confirm → Chroma Meter → map unlock  
3. **Hunt-Hue Box** — retail SKU story, rules PDF, 48-card gallery  
4. **Chroma Map & Journal** — progression after one chapter  

Formal documents: [`documents/`](documents/) (business plan, roadmap, investor pitch DOCX).

## Settings & languages

Open **Settings** (gear on home) for game controls and language:

| Language | Code |
|----------|------|
| English | `en` |
| Español | `es` |
| Français | `fr` |
| Deutsch | `de` |
| 中文 (简体) | `zh` |

**Game controls:** sound effects, haptics, Hue Spirit hints, pass-device reminders, mission timer (short / standard / long), default camera bonus, reset progress, replay introduction.

Mission card text in JSON remains English in v1.0; all UI chrome follows the selected language.

## Version

`1.0.0` — pitch build (see `pubspec.yaml` and `lib/constants/app_branding.dart`).

## Tech

- Flutter · Provider · SharedPreferences  
- Mission content: `assets/missions/*.json`  
- Box rules: `assets/box/hunt_hue_box_rules.md`
