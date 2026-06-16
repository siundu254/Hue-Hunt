# Hue Hunt v1.5 — Perfect Flagship Spec

**Reference:** NL-HH-V15-2026-001  
**Status:** Approved direction (founder sync)  
**Fiscal window:** 30-day cashflow · 90-day Kickstarter  
**Strategy:** AI Host Platform + B2B first · Hue Hunt = only consumer face

---

## 1. Decision locks

| Question | Answer |
|----------|--------|
| Paying customers in 30 days? | **Yes** — Team Kits + venue pilots before mass UA |
| AI host as core IP? | **Yes** — Hue Spirit TTS → template host → optional LLM banter |
| One consumer brand? | **Hue Hunt** — Word Bridge & Room Sketch become *chapter packs*, not separate pitches |
| Crowdfunding in 90 days? | **Yes** — Gamefound/Kickstarter for Hunt-Hue Box MOQ |

**Category we own:** *AI-hosted indoor missions* — not “scavenger app,” not “colour game.”

**Positioning sentence:**

> Hue Hunt is the AI-voiced mission host for any room: the Hue Spirit runs object hunts in 15 minutes, Team Kits give HR a certificate, and one JSON pipeline powers the app, the box, and venue sponsor decks.

---

## 2. Why v1.0 isn’t “perfect” yet

v1.0 proves execution. It does **not** yet prove:

- **Sellability** — no Team certificate, no QR unlock, no facilitator kit in-app  
- **Surprise** — Hue Spirit is text-only; taxonomy hidden in briefing  
- **Depth** — ~30 digital missions; repeats on session 2  
- **Retail truth** — QR/copy promises bonus missions; scanner not shipped  
- **Demo risk** — camera toggle with no behavior  

v1.5 closes the gap between **investor walkthrough** and **first invoice + backer campaign**.

---

## 3. Perfect Hue Hunt — four pillars

### Pillar A: The Host (cutting edge)

Hue Spirit is the product—not the missions list.

| Layer | v1.0 | v1.5 Perfect |
|-------|------|----------------|
| Voice | Text banner | **On-device TTS** (system voice v1; premium voice v1.6) |
| Tone | Mode intros | **Tone packs:** Family / Party / Team / Kids |
| Intelligence | Static lines | **Template banter** from `objectPrompt` + optional 1-line LLM (fallback always) |
| Presence | Mood GIF | Briefing **speaks** mission type: Object / Texture / Combo |
| Host Mode | — | iPad presenter: large type, optional timer, no scores (HH-04) |

**Demo moment:** Spirit says *“Team Alpha — find something rough. You have 75 seconds. Go.”* — taxonomy badge on screen.

### Pillar B: Cashflow (30 days)

| SKU | Buyer | Price | In-app deliverable |
|-----|-------|-------|-------------------|
| **Team Kit** | HR, L&D | USD 199/event | Team Expedition → **certificate PDF** + facilitator script PDF |
| **Venue Deck v0** | Museum, café | USD 2.5k–8k/season | Import JSON / QR → 20-card sponsored chapter |
| **School pilot** | After-school | Free → USD 299/yr | Kids Co-Op + teacher PDF + camera-off default |

**30-day goal:** 3 Team Kit pilots OR 1 venue LOI + 1 school — not download count.

### Pillar C: Crowdfunding (90 days)

| Asset | Status v1.0 | v1.5 required |
|-------|-------------|---------------|
| Hunt-Hue Box (48 cards) | JSON + gallery | **Print-ready PDF** + component list |
| QR → bonus chapter | Copy only | **Scanner + unlock** in app |
| Pre-order CTA | — | Hunt-Hue Box screen → campaign URL |
| Social proof | Text share | **PNG expedition card** (meter, teams, Spirit quote) |
| Stretch goal | — | Holiday 24-card expansion JSON preview |

**Campaign target:** USD 15k–25k MOQ fund · 300–500 backers · ship Q4 FY26.

### Pillar D: Content factory (moat)

One schema → app + print + venue:

```
mission_decks.json / hunt_hue_box_deck.json / venue_{sponsor}.json
```

| Milestone | Count |
|-----------|-------|
| Digital missions (all modes) | **60+** |
| Box cards | 48 (ship) + 24 holiday stretch |
| Venue template | 1 white-label example (museum) |

---

## 4. v1.5 feature backlog (prioritized)

### P0 — Ship before any outreach (Weeks 1–3)

| ID | Feature | Acceptance |
|----|---------|------------|
| HH15-01 | Mission taxonomy on briefing + intro | Badge: Object / Texture / Combo / Forge / etc. |
| HH15-02 | Hue Spirit **TTS** | Speaks intro + meter reaction; respects mute setting |
| HH15-03 | Team **certificate PDF** | After Team Expedition complete; share/email |
| HH15-04 | Facilitator script PDF | 10-min host bundle linked from Team + Box |
| HH15-05 | **QR unlock** | Scan box/venue QR → load bonus JSON chapter |
| HH15-06 | PNG **share card** | Chapter complete → image export |
| HH15-07 | Content → **60 missions** | No repeat in 2 full family chapters |
| HH15-08 | Camera toggle | **Remove** or wire honor-only label (no fake ML) |

### P1 — Kickstarter-ready (Weeks 4–8)

| ID | Feature | Acceptance |
|----|---------|------------|
| HH15-09 | Host Mode | Settings → presenter layout for iPad |
| HH15-10 | Venue deck import | Load asset bundle or file URI |
| HH15-11 | Pre-order CTA | Box screen → Gamefound/Kickstarter |
| HH15-12 | Holiday pack JSON | 24 cards preview in app |
| HH15-13 | Box screen **l10n** | ES/FR/DE/ZH for retail story |
| HH15-14 | Tone packs | Team = neutral; Party = hype; Family = warm |

### P2 — Platform (post-campaign)

| ID | Feature |
|----|---------|
| HH15-15 | UGC local pack (5 missions + share code) |
| HH15-16 | Async Couch Link (weekend room code) |
| HH15-17 | LLM 1-line banter (cloud, opt-in) |
| HH15-18 | Venue Mission Builder (web upload) |

---

## 5. Word Bridge & Room Sketch (not killed — folded)

| Old IP | v1.5 role |
|--------|-----------|
| **Word Bridge** | *Literacy Expedition* — Hue Hunt chapter pack (clue missions use same session engine) |
| **Room Sketch** | *Spatial Expedition* — object placement missions as Forge/Echo variant |

Separate apps remain for demos; **investor + Kickstarter story = Hue Hunt only**.

---

## 6. Thirty-day revenue sprint

| Week | Build | Sell |
|------|-------|------|
| **1** | P0: taxonomy, TTS, certificate PDF | List 20 HR/education contacts |
| **2** | P0: QR unlock, share PNG, +20 missions | Send Team Kit offer (template in `INVESTOR_OUTREACH_EMAIL_TEMPLATES.md`) |
| **3** | P0: facilitator PDF, polish demo path | **3 discovery calls** · 1 paid pilot target |
| **4** | P1: venue import demo | **1 venue LOI** or **1 Team Kit invoice** |

**Success metric:** USD 500–2,000 booked revenue OR signed LOI + deposit.

---

## 7. Ninety-day Kickstarter arc

| Week | Milestone |
|------|-----------|
| 5–6 | Print proof PDF · campaign video (60s demo: Spirit speaks + box QR) |
| 7 | Gamefound page live · email list from Word Master cross-promo |
| 8–10 | Creator sends (5 micro) · school/camp mentions |
| 11–12 | Campaign end · MOQ to print partner |

**Campaign tiers (draft):**

| Tier | Price | Reward |
|------|-------|--------|
| Digital Spirit | USD 9 | App premium pass + bonus chapter |
| Hunt-Hue Box | USD 29 | 48 cards + timer + tokens + QR unlock |
| Host Bundle | USD 49 | Box + facilitator PDF + Team certificate templates |
| Venue Sponsor | USD 250 | Name on 1 card + digital deck for staff party |

---

## 8. Investor one-liner (updated)

> NovaLumina’s Hue Hunt is an **AI-hosted mission platform**: voiced Hue Spirit, B2B Team Kits with certificates, and Hunt-Hue Box retail—four live puzzle apps funnel players; we sell HR and venues before ad spend.

---

## 9. What we stop saying

- “Five apps in our social portfolio” → **one flagship + chapter packs**  
- “Colour scavenger” → **object / texture / combo missions**  
- “Narrator shipped” until **TTS ships**  
- Consumer soft launch before **Team Kit or Kickstarter** proof  

---

## 10. Related documents

- Business plan: NL-HH-2026-002  
- Innovation backlog: NL-INNOVATION-2026-001  
- Outreach emails: NL-OUTREACH-2026-001  
- Cross-promo: NL-XPROMO-2026-001  

---

© 2026 NovaLumina Studio · Confidential
