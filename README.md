# Room Raiders

**Raid Missions** — NovaLumina Studio’s room-based scavenger platform.

Hunt real **objects, textures, and combos** — never colour-based hunts. **Spirit Forge** forges missions for your room; **Raid Captain** hosts game-show drops, sudden-death timers, secret objectives, decoys, and chaos twists.

**Platform spec:** [docs/ROOM_RAIDERS_V21_PLATFORM_SPEC.md](docs/ROOM_RAIDERS_V21_PLATFORM_SPEC.md)

## Run

```bash
cd hue_hunt
flutter pub get
flutter run
```

## v2.1 highlights

- **Room Raiders** branding (logo, orange/purple palette)
- **Secret objectives** per player
- **Sudden death** timers + chaos events (16 twists)
- **Decoy missions** mixed into chapters
- **Multi-stage clue chains** on select hunts
- **Raid awards** + MVP highlight share cards
- **No colour-category hunts** in app or box deck

## Primary path

**Home → Spirit Forge** → App or **Hunt-Hue Box** → pick venue → **Forge & launch**

## Documents

| Path | Purpose |
|------|---------|
| `docs/ROOM_RAIDERS_V21_PLATFORM_SPEC.md` | Product + mechanics spec |
| `assets/box/hunt_hue_box_rules.md` | Hunt-Hue Box tabletop rules |
| `documents/DOCUMENTS.txt` | Investor DOCX + deck regeneration index |
| `documents/generate_room_raiders_documents.py` | Regenerate business plan, roadmap, pitch |

## Version

`2.1.0` — see `pubspec.yaml` and `lib/constants/app_branding.dart`.
