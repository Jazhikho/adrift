# GAME DESIGN DOCUMENT

---

## Document Information

**Game Title:** *Adrift: Echoes*
**Version:** 0.9 (Jam Draft)
**Last Updated:** November 2025
**Lead Designer:** Chris D.
**Document Owner:** ForgeWalker Studios
**Status:** Pre-Production / Active Jam Development

---

## 1. EXECUTIVE SUMMARY

### 1.1 High Concept

*A survival tragedy set upon an infinite ocean where the line between starvation and revelation blurs.*
You drift alone in a liferaft after the end. Food, water, and hope slowly fade. As your body weakens, the waves begin to whisper, showing visions that might be memories—or hallucinations. There is no victory condition; the only goal is endurance.

### 1.2 Game Overview

* **Genre:** Survival / Psychological Horror / Narrative Exploration
* **Target Platform(s):** PC (Windows, Linux, macOS)
* **Target Audience:** Mature players, ages 16+; fans of narrative survival and slow existential horror
* **Target Rating:** Teen / Mature (themes of isolation, starvation, mental collapse)
* **Comparable Titles:**

  * *Raft* (mechanical loop)
  * *ABZÛ* (ocean ambience)
  * *Return of the Obra Dinn* (aesthetic restraint)
  * *SOMA* (philosophical horror)
  * *Dear Esther* (tone)
* **Unique Selling Points (USPs):**

  * No “win” condition—only endurance and acceptance
  * Hallucinations and echoes dynamically tied to survival states
  * Atmospheric storytelling through ocean, sound, and light

### 1.3 Design Pillars

1. **Endurance Without Victory:** The player endures, but cannot conquer the sea.
2. **The Ocean Is the Antagonist:** Nature, not narrative, drives tension.
3. **Psychological Degradation:** Starvation births hallucinations—“echoes”—that merge sound, light, and memory.
4. **Minimalism as Honesty:** Fewer mechanics, deeper emotional resonance.

---

## 2. GAME CONCEPT

### 2.1 Story & Setting

#### 2.1.1 Narrative Synopsis

You awaken alone in a liferaft, adrift on a boundless sea. Early on, you gather floating debris and catch rain. As days pass, supplies dwindle, and the waves begin to speak. You start to see other rafts, other survivors—none are real. Eventually, you either fade quietly into the calm or hallucinate rescue.

#### 2.1.2 World / Setting

A procedural, day-night-cycled ocean rendered with simple shaders. No visible land. The raft, the sky, and the water are the entire world.

#### 2.1.3 Tone & Theme

Bleak serenity; cosmic insignificance. Themes of endurance, denial, and dissolution.

---

### 2.2 Core Gameplay Loop

1. **Scavenge**: Collect debris (food, water, supplies).
2. **Consume**: Manage hunger, thirst, and coherence.
3. **Maintain**: Patch leaks and balance the raft.
4. **Endure**: Survive storms and dehydration.
5. **Deteriorate**: Hallucinations and echoes increase.
6. **End**: Death, surrender, or ambiguous “rescue.”

---

### 2.3 Player Experience Goals

* Feel the futility of endurance.
* Sense awe and dread at the living sea.
* Question the boundaries between mind and environment.

---

## 3. GAMEPLAY MECHANICS

### 3.1 Core Mechanics

#### 3.1.1 Survival Loop

* **Description:** The player manages three survival meters: Hunger, Thirst, Coherence (sanity).
* **Player Action:** Gather debris, catch rainwater, ration supplies.
* **System Response:** Stats decay; low values trigger hallucinations.
* **Purpose:** Drive tension and narrative pacing through attrition.

#### 3.1.2 Hallucination System (“Echoes”)

* **Description:** At low coherence, ocean sounds transform into human voices or music. Visual mirages (ships, islands) appear.
* **Player Action:** The player can ignore or interact with illusions (attempt to grab, follow).
* **System Response:** Interaction drains remaining coherence faster; ignoring causes loneliness penalties.
* **Purpose:** Represent psychological collapse through interactive ambiguity.

#### 3.1.3 Ocean & Wave Mechanics

* **Description:** Procedurally animated ocean plane; wave height linked to weather and emotional state.
* **Player Action:** Balance, patch, steer; higher waves threaten capsizing.
* **System Response:** Boat tilts, camera sways, movement restricted.
* **Purpose:** Make the ocean feel alive and merciless.

#### 3.1.4 Maintenance

* **Description:** Simple input rhythm mechanic for patching leaks or tightening ropes.
* **Purpose:** Give moments of tactile interaction amid stillness.

---

### 3.2 Game Controls

**PC Keyboard/Mouse**

* Move/look: WASD + Mouse
* Interact: E
* Inventory: Tab
* Ping (listen to sea): Q
* Rest: R
* Pause/Menu: Esc

---

### 3.3 Camera System

* **Camera Type:** First-person
* **Behavior:** Smooth head-bob synced with raft tilt; limited pitch to avoid motion sickness.

---

## 4. GAME SYSTEMS

### 4.1 Progression System

* **Type:** Time-based degradation
* **Progression Path:** Linear, measured in “days survived”
* **Unlocks:** Hallucination tiers, new ambient sounds, altered lighting

### 4.2 Resource Management

* **Food:** Found debris, finite supply.
* **Water:** Catch rain or collect drift bottles.
* **Coherence:** Drains slowly; refills slightly with successful survival actions early on, impossible later.

### 4.3 Inventory & Items

* **Consumables:** Food tins, bottled water
* **Tools:** Rope, tarp, patch kit
* **Special Items:** Radio (static transmissions that devolve into voices), flare gun (illusory rescue trigger)

### 4.4 Save System

* Auto-save each dawn.
* One slot; death wipes save.

---

## 5. GAME CONTENT

### 5.1 Level Design

* **World Type:** Infinite procedural ocean
* **Level Flow:** Time passage marked by day/night and weather; no physical progression, only temporal decay.
* **Environmental Storytelling:**

  * Personal items float by, hinting at a wider catastrophe.

### 5.2 Characters

* **The Drifter:** Silent protagonist; genderless, nameless.
* **The Ocean:** The true antagonist and unreliable narrator.

### 5.3 Story Structure

**Act I – Survival**

* Learn mechanics; ocean feels neutral.
* Debris plentiful.

**Act II – Scarcity**

* Food and water decline; storms frequent.
* First hallucinations appear (distant ship lights, muffled music).

**Act III – Collapse**

* Echoes multiply; day/night lose meaning.
* Ocean calms unnaturally; false rescues appear.
* Endings trigger based on survival state: surrender, death, or hallucinated salvation.

---

## 6. USER INTERFACE

### 6.1 HUD

* Minimalist overlay:

  * Hunger / Thirst / Coherence bars bottom left.
  * Subtle fade at low health.
  * No compass or map.

### 6.2 Menus

* **Main Menu:** New Drift / Continue / Settings / Quit
* **Pause Menu:** Resume / Settings / Quit to Main
* **Settings:** Audio sliders, motion sensitivity, accessibility toggles.

### 6.3 UI/UX Principles

* Diegetic sound cues replace traditional UI feedback.
* Information minimal and degrading—UI distortion at low coherence.

---

## 7. AUDIO & VISUAL DESIGN

### 7.1 Art Direction

* **Visual Style:** Realistic low-poly minimalism (clean silhouettes, muted textures).
* **Color Palette:** Blues, greys, desaturated sunlight; occasional warm glows during hallucination phases.

### 7.2 Environment Design

* Dynamic ocean plane with shader-based waves.
* Raft model (cloth, rope, wet wood).
* Procedural skybox shifting hue based on coherence.

### 7.3 Audio Design

* **Music:** Sparse ambient drones; shifts to harmonic swells as sanity fades.
* **SFX:**

  * Water impact, creaks, wind loops.
  * Distant whispers blended with wave frequencies.
* **Voice Acting:** None—hallucinated “voices” generated from modulated environmental sounds.

---

## 8. MONETIZATION

* **Business Model:** Free / Jam build.
* **No Purchases.**

---

## 9. TECHNICAL SPECIFICATIONS

### 9.1 Development Tools

* **Engine:** Godot 4.5 (GDScript)
* **Version Control:** Git + GitHub

### 9.2 Target Platforms

#### PC

* **OS:** Windows 10+, Linux, macOS
* **Minimum Specs:**

  * CPU: i5 3.0GHz
  * GPU: GTX 1050 / RX 560
  * RAM: 8GB
* **Recommended Specs:**

  * CPU: i7 / Ryzen 5
  * GPU: GTX 1660 / RX 6600
  * RAM: 16GB

### 9.3 Performance Target

* 1080p, 60 FPS
* <1GB build size

---

## 10. DEVELOPMENT ROADMAP

### 10.1 Milestones

**Pre-Production (Days 1–2)**

* Create project, ocean shader, raft prototype.

**Vertical Slice (Days 3–6)**

* Add hunger/thirst, debris spawn, UI, day/night cycle.

**Alpha (Days 7–10)**

* Add coherence system, hallucination triggers, weather patterns.

**Beta (Days 11–13)**

* Add audio mixing, death states, polish lighting.

**Gold (Days 14)**

* Final build, itch.io release.

### 10.2 Feature Priority Matrix

| Priority | Feature                         | Notes                  |
| -------- | ------------------------------- | ---------------------- |
| P0       | Hunger/Thirst/Coherence systems | Core survival loop     |
| P0       | Raft physics and buoyancy       | Core gameplay          |
| P1       | Hallucination visuals and audio | Philosophical tone     |
| P1       | Weather and wave dynamics       | Mood                   |
| P2       | Rare rescue event               | Optional secret ending |
| P3       | Expanded debris types           | Post-jam update        |

---

## 11. RISK ASSESSMENT

### Technical Risks

| Risk                                          | Likelihood | Impact | Mitigation                                    |
| --------------------------------------------- | ---------- | ------ | --------------------------------------------- |
| Wave shader instability                       | Med        | Med    | Keep visuals simple; use noise, not fluid sim |
| Audio memory leaks (looping hallucinations)   | Low        | High   | Limit concurrency; stop old instances         |
| Build performance drops at high object counts | Med        | High   | Cull distant debris                           |

### Design Risks

| Risk                           | Likelihood | Impact | Mitigation                                |
| ------------------------------ | ---------- | ------ | ----------------------------------------- |
| Slow pacing may bore players   | High       | Med    | Use pacing curve: calm → chaos → calm     |
| Ambiguous ending misunderstood | Med        | Low    | Reinforce tone through environmental cues |

---

## 12. TEAM & RESOURCES

* **Creative Director:** Chris D.
* **Lead Designer:** Chris D.
* **Programmer:** Chris D.
* **Artist:** Chris D.
* **Audio Designer:** Chris D.
* **QA:** Peer feedback via itch.io comments

---

## 13. APPENDICES

**Appendix A: Glossary**

* **Coherence:** Mental stability meter.
* **Echoes:** Hallucinated voices triggered by low coherence.

**Appendix B: Reference Materials**

* Research: Sleep deprivation studies, maritime survival accounts.
* Visual: *All Is Lost*, *The Lighthouse*, *The Old Man and the Sea.*

**Appendix C: Change Log**

| Version | Date       | Author   | Changes           |
| ------- | ---------- | -------- | ----------------- |
| 0.9     | 2025-11-01 | Chris D. | Initial GDD draft |
