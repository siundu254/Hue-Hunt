# Hue Hunt v2.0 — Platform Spec

**Reference:** NL-HH-V20-2026-001  
**Status:** Shipped in app v2.0.0  
**Extends:** [HUE_HUNT_V15_PERFECT_SPEC.md](HUE_HUNT_V15_PERFECT_SPEC.md)

---

## Positioning (10/10 innovation target)

> **One JSON pipeline. Three surfaces. The Hue Spirit hosts all of them.**

| Surface | What players experience |
|---------|-------------------------|
| **Spirit Forge (app)** | Pick room → AI forges bespoke chapter → Game Show Drop → Chaos Twist |
| **Expedition Room (LAN)** | Host phone + team phones + spectator voters on same Wi‑Fi |
| **Hunt-Hue Box (tabletop)** | Physical 48-card deck; app is AI host + scorekeeper via Spirit Forge |

This matches innovation backlog items **HH-04** (Host Mode), **HH-05** (multi-device couch link, LAN v1), and retail **SP-05** (box QR → digital).

---

## Core loop (default — not optional demo)

```
Home → Spirit Forge
  → Format: App | Hunt-Hue Box
  → Venue DNA (living room, office, party, …)
  → Open expedition room? (LAN)
  → Forge & launch
  → [Lobby: room code + QR] (if multi-device)
  → Chapter: Game Show Drops + Chaos Twist
  → Complete → share PNG / Team PDF
```

**Classic mode chapters** remain for regression and school pilots — secondary on home.

---

## Expedition Room (LAN multi-device)

| Role | Device | Capability |
|------|--------|------------|
| **Host** | 1 phone/tablet | Forge, score, Game Show Drop, Host Mode panel |
| **Team** | 0–4 phones | Live mission prompt sync |
| **Spectator** | 0–N phones | ★1–5 vote on finds → bonus points on host |

**Join:** Scan host QR (`huehunt://join?code=…&host=…`) or enter IP + 6-digit code.  
**Requirement:** Same Wi‑Fi (HTTP LAN on port 8765).

---

## Hunt-Hue Box integration

- Spirit Forge **Box** format shuffles object-led cards from `hunt_hue_box_deck.json` (colour-only cards filtered).
- Briefing instructs: draw physical card **or** mirror on host screen.
- Box screen primary CTA: **Spirit Forge with Hunt-Hue Box**.
- QR unlock → bonus chapter unchanged.

---

## Host Mode (HH-04)

When expedition room is open, chapter session shows **Host Mode** panel: large mission prompt, spectator vote average, connected device count.

---

## Content factory (unchanged schema)

```
mission_decks.json     → classic digital modes
hunt_hue_box_deck.json → retail 48 + Spirit Forge box path
SpiritForgeService     → venue DNA pools (42 missions × 6 venues)
bonus_chapter.json     → QR unlock
```

---

## Pitch demo script (2 minutes)

1. **Spirit Forge** → Office → "Acme retreat" → open room  
2. Show **QR** — second phone joins as **Spectator**  
3. **Start chapter** — Game Show Drop speaks mission  
4. Mission 2 — **Chaos Twist** fires  
5. Spectator votes ★★★★ — host confirms find, bonus points apply  
6. Toggle **Hunt-Hue Box** format — same Spirit, physical cards  

**Line:** *"We're not a scavenger app. We're an AI game-show host that runs on phones, spectators, and a board game SKU from one mission pipeline."*

---

## Roadmap to cloud (P2)

| ID | Feature |
|----|---------|
| HH20-01 | Cloud expedition room (weekend codes, no LAN) |
| HH20-02 | LLM room photo → forge |
| HH20-03 | Venue sponsor JSON import |
| HH20-04 | UGC pack share codes |

---

© 2026 NovaLumina Studio · Confidential
