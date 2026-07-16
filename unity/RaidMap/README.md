# Raid Map — Unity 3D Board (Flutter embed)

Premium 3D tabletop view for **The Raid Map**. Flutter hosts the shell; Unity renders the board when exported.

## Quick start (no Unity yet)

The app **Orbit 3D** mode works today — tap the orbit icon on The Raid Table. Drag to rotate, pinch to zoom, SVG room art + gold shimmer.

## One-click Unity scene

1. Unity Hub → **New 2022 LTS** → folder `unity/RaidMap/`
2. Copy `Assets/Scripts/` and `Assets/Editor/` into the project
3. Menu: **Hunt-Hue → Create Raid Map Scene**
4. Press Play — procedural board builds automatically (`BoardSceneBuilder`)

## Scene scripts

| File | Role |
|------|------|
| `BoardSceneBuilder.cs` | **Procedural** felt board, vault, beams, tokens, lighting |
| `CameraOrbitController.cs` | Drag orbit + scroll zoom on vault |
| `BoardTapRelay.cs` | Raycast quadrant / vault taps → Flutter |
| `RaidMapController.cs` | Flutter messages, token lerp on `BeamPath` |
| `FlutterBridge.cs` | Unity → Flutter events |
| `ChaosCompassSpin.cs` | Compass animation |
| `VenueOverlayController.cs` | Per-venue quadrant colors |
| `BeamPath.cs` | 11 waypoint positions per team |
| `Editor/RaidMapSceneWizard.cs` | One-click scene creation |

## Flutter embed (after export)

```bash
./scripts/unity_export_checklist.sh
flutter pub add flutter_unity_widget
```

1. Export iOS/Android from Unity (flutter_unity_widget docs)
2. Uncomment `lib/widgets/board/raid_map_unity_native.dart`
3. Wire `RaidMapUnityNative.embed` in `raid_map_unity_view.dart`
4. Set `UnityBoardBridge.useUnity = true`

## Flutter ↔ Unity messages

| Flutter → Unity | Method | Payload |
|-----------------|--------|---------|
| `loadVenue` | `loadVenue` | `{ "venueId": "home" }` |
| `setScores` | `setScores` | `{ "scores": [0,2,1,0] }` |
| `setPhase` | `setPhase` | `{ "phase": "raid" }` |
| `spinCompass` | `spinCompass` | — |
| `crownWin` | `crownWin` | `{ "teamName": "Aurora" }` |

| Unity → Flutter | Event |
|-----------------|-------|
| `ready` | Scene loaded |
| `cornerTapped` | `{ teamIndex }` |
| `vaultTapped` | `{ zoneId }` |

## Print assets

SVG room masters: `assets/board/`. Export 300 DPI:

```bash
./scripts/export_board_print.sh
```

## Browser

`Board-Deck.html?table=1` — Raid Table fullscreen with animated board.
