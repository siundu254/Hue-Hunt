# Hue Hunt — Spirit Forge Platform

**The Chroma Expedition** — NovaLumina Studio’s AI-hosted mission platform for any room.

Hunt real **objects, textures, and combos** — not colour swatches. **Spirit Forge** is the default way to play: the Hue Spirit forges missions for your room, runs a game-show countdown, and can host **multiple phones** plus **Hunt-Hue Box** tabletop.

Platform spec: [docs/HUE_HUNT_V20_PLATFORM_SPEC.md](docs/HUE_HUNT_V20_PLATFORM_SPEC.md)

## Run

```bash
cd hue_hunt
flutter pub get
flutter run
```

## Primary path (v2.0)

**Home → Spirit Forge** → App or **Hunt-Hue Box** → pick venue → **Forge & launch**

Optional: **Open expedition room** → lobby QR → team/spectator phones join on same Wi‑Fi.

## Multi-device

| Role | Action |
|------|--------|
| Host | Spirit Forge → open room → start chapter |
| Team phone | Join expedition → Team |
| Spectator | Join expedition → Spectator → vote ★1–5 on finds |

## Board game

**Hunt-Hue Box** → **Spirit Forge with Hunt-Hue Box** — draw physical cards; app is AI host + scorekeeper. Same JSON pipeline as digital (`hunt_hue_box_deck.json`).

Classic box scorekeeper (no forge) still available under Hunt-Hue Box.

## Classic modes

Home → **Classic: Family Mission** (or mode cards) — original chapter decks without Spirit Forge.

## Version

`2.0.0` — Spirit Forge core, expedition room LAN, box integration. See `pubspec.yaml` and `lib/constants/app_branding.dart`.

## Tech

- Flutter · Provider · LAN HTTP room sync (port 8765)
- Mission content: `assets/missions/*.json`
- Box rules: `assets/box/hunt_hue_box_rules.md`
