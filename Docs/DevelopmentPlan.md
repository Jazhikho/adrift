# Development Plan: Adrift: Echoes

**Version:** 1.0  
**Last Updated:** November 2025  
**Status:** Active Development

---

## Overview

This document provides a comprehensive step-by-step plan for bringing *Adrift: Echoes* from its current state to a complete, playable game. Items marked with ✓ have been completed. Items marked with 🔄 are in progress. Items without marks are pending.

---

## Phase 1: Foundation & Core Systems ✅

### 1.1 Project Setup
- [x] ✓ Create Godot project structure
- [x] ✓ Set up folder organization (Scripts/, Scenes/, Resources/, etc.)
- [x] ✓ Configure project.godot with correct settings
- [x] ✓ Create Game Design Document
- [x] ✓ Create README.md

### 1.2 Survival System
- [x] ✓ Implement `SurvivalStats` Resource class
- [x] ✓ Implement `SurvivalSystem` Node class
- [x] ✓ Add stat decay mechanics (hunger, thirst, coherence)
- [x] ✓ Add stat restoration methods
- [x] ✓ Implement accelerated coherence decay when hunger/thirst low
- [x] ✓ Implement coherence restoration limitations
- [x] ✓ Add signal system for stat changes
- [x] ✓ Create comprehensive test suite
- [x] ✓ Write survival system documentation

### 1.3 Documentation
- [x] ✓ Create GDD (Game Design Document)
- [x] ✓ Document survival system architecture
- [x] ✓ Create README with project overview

---

## Phase 2: Player & Controls 🔄

### 2.1 Player Controller
- [x] Create `PlayerController.gd` script
- [x] Implement first-person camera with mouse look
- [x] Add WASD movement controls
- [ ] Implement head-bob (basic version, raft sync pending)
- [ ] Add limited pitch to prevent motion sickness
- [ ] Configure camera smoothing and sensitivity
- [ ] Add camera sway based on raft tilt

### 2.2 Player Scene
- [x] ✓ Create `Player.tscn` scene
- [x] ✓ Set up CharacterBody3D
- [x] ✓ Add camera as child node
- [x] ✓ Configure collision shapes
- [x] ✓ Test player movement in empty scene

### 2.3 Interaction System
- [ ] Create `Interactable.gd` base class/interface
- [ ] Implement interaction detection (raycast)
- [ ] Add interaction prompt UI
- [ ] Create `InteractionManager.gd` to handle interactions
- [ ] Implement E key binding via Input Map
- [ ] Add interaction feedback (visual/audio)

---

## Phase 3: Ocean & Environment

### 3.1 Ocean Shader
- [ ] Create `OceanShader.gdshader`
- [ ] Implement procedural wave generation using noise
- [ ] Add wave height variation based on weather
- [ ] Add wave movement/animation
- [ ] Implement color transitions (day/night, weather)
- [ ] Add foam/whitecap effects
- [ ] Optimize for performance (LOD if needed)

### 3.2 Ocean System
- [ ] Create `OceanSystem.gd` script
- [ ] Implement procedural ocean plane
- [ ] Add wave height calculation based on weather/emotional state
- [ ] Create ocean mesh generation (or use PlaneMesh with shader)
- [ ] Add infinite scrolling/illusion
- [ ] Implement wave-to-player interaction (raft buoyancy)

### 3.3 Weather System
- [ ] Create `WeatherSystem.gd` script
- [ ] Implement weather states (calm, storm, rain)
- [ ] Add weather transitions
- [ ] Connect weather to wave height
- [ ] Add weather visual effects (rain particles, fog)
- [ ] Implement weather audio mixing

### 3.4 Day/Night Cycle
- [ ] Create `DayNightCycle.gd` script
- [ ] Implement time progression system
- [ ] Add skybox rotation/color changes
- [ ] Implement lighting transitions
- [ ] Add day/night audio mixing
- [ ] Connect to save system (auto-save at dawn)

---

## Phase 4: Raft & Physics

### 4.1 Raft Model
- [ ] Create or import raft 3D model
- [ ] Set up materials (wet wood, cloth, rope)
- [ ] Add raft collision shape
- [ ] Create raft scene (`Raft.tscn`)

### 4.2 Raft Physics
- [ ] Create `RaftPhysics.gd` script
- [ ] Implement buoyancy system
- [ ] Add raft tilt based on waves
- [ ] Implement capsizing risk (high waves)
- [ ] Add balance mechanics (player weight distribution)
- [ ] Connect raft tilt to camera sway

### 4.3 Raft Maintenance
- [ ] Create `RaftMaintenance.gd` script
- [ ] Implement leak detection system
- [ ] Add patching mechanic (rhythm/input pattern)
- [ ] Create rope tightening mechanic
- [ ] Add maintenance UI prompts
- [ ] Implement maintenance failure consequences

### 4.4 Player-Raft Integration
- [ ] Constrain player to raft surface
- [ ] Sync player movement with raft motion
- [ ] Add raft-relative movement (local space)
- [ ] Implement balance loss on high tilt

---

## Phase 5: Inventory & Items

### 5.1 Item System
- [ ] Create `Item.gd` Resource class
- [ ] Define item types (consumables, tools, special)
- [ ] Add item properties (hunger_value, thirst_value, etc.)
- [ ] Create item data resources in `Resources/Data/`

### 5.2 Inventory System
- [ ] Create `Inventory.gd` script
- [ ] Implement item storage (Array/Dictionary)
- [ ] Add item stacking logic
- [ ] Create inventory capacity limits
- [ ] Add item removal/addition methods
- [ ] Connect to survival system (consumption)

### 5.3 Inventory UI
- [ ] Create `InventoryUI.tscn` scene
- [ ] Design inventory grid/slots
- [ ] Implement item display (icons/sprites)
- [ ] Add drag-and-drop or selection system
- [ ] Add item tooltips/descriptions
- [ ] Implement Tab key binding for inventory toggle

### 5.4 Item Interaction
- [ ] Create consumable item usage
- [ ] Implement item effects (restore stats)
- [ ] Add item consumption feedback
- [ ] Create special item effects (radio, flare gun)

---

## Phase 6: Debris & Scavenging

### 6.1 Debris Spawner
- [ ] Create `DebrisSpawner.gd` script
- [ ] Implement procedural debris spawning
- [ ] Add spawn zones (visible distance from player)
- [ ] Create debris type variety (food, water, supplies)
- [ ] Implement spawn rate/density controls
- [ ] Add culling for distant debris

### 6.2 Debris Models
- [ ] Create/import debris models (food tins, bottles, etc.)
- [ ] Add debris materials
- [ ] Create debris prefabs/scenes
- [ ] Add debris collision shapes

### 6.3 Debris Collection
- [ ] Create `DebrisItem.gd` script
- [ ] Implement collection detection (proximity/interaction)
- [ ] Add collection animation/feedback
- [ ] Connect collection to inventory
- [ ] Implement debris despawn after collection

### 6.4 Scavenging Balance
- [ ] Tune spawn rates (plentiful early, scarce later)
- [ ] Add spawn location variety (floating, visible)
- [ ] Implement debris drift animation
- [ ] Add scavenging audio feedback

---

## Phase 7: Hallucination System

### 7.1 Hallucination Manager
- [ ] Create `HallucinationSystem.gd` script
- [ ] Implement hallucination tier system (based on coherence)
- [ ] Add hallucination trigger conditions
- [ ] Create hallucination duration/cooldown system
- [ ] Connect to survival system (coherence signals)

### 7.2 Visual Hallucinations
- [ ] Create visual mirage system (ships, islands, other rafts)
- [ ] Implement hallucination fade-in/fade-out
- [ ] Add hallucination models/sprites
- [ ] Create hallucination shader effects (distortion, shimmer)
- [ ] Add interaction attempts (player tries to grab/follow)

### 7.3 Audio Hallucinations (Echoes)
- [ ] Create `EchoSystem.gd` script
- [ ] Implement ocean sound modulation (voices/music)
- [ ] Add echo frequency based on coherence level
- [ ] Create whisper/voice generation from environmental sounds
- [ ] Implement audio layering (real sounds + hallucinations)
- [ ] Add echo audio mixing

### 7.4 Hallucination Consequences
- [ ] Implement coherence drain on interaction attempts
- [ ] Add loneliness penalty for ignoring hallucinations
- [ ] Create hallucination intensity scaling
- [ ] Add false rescue events (high-tier hallucinations)

---

## Phase 8: UI Systems

### 8.1 HUD
- [ ] Create `HUD.tscn` scene
- [ ] Design minimalist HUD layout
- [ ] Create hunger/thirst/coherence bars (bottom left)
- [ ] Add health indicator (subtle fade at low health)
- [ ] Implement UI degradation at low coherence (distortion)
- [ ] Create `HUD.gd` script to manage HUD updates

### 8.2 Main Menu
- [ ] Create `MainMenu.tscn` scene
- [ ] Design menu layout (New Drift / Continue / Settings / Quit)
- [ ] Implement menu navigation
- [ ] Add menu background/atmosphere
- [ ] Connect buttons to game flow
- [ ] Create `MainMenu.gd` script

### 8.3 Pause Menu
- [ ] Create `PauseMenu.tscn` scene
- [ ] Add pause menu UI (Resume / Settings / Quit to Main)
- [ ] Implement pause functionality (Esc key)
- [ ] Add pause menu script
- [ ] Connect to game state management

### 8.4 Settings Menu
- [ ] Create `SettingsMenu.tscn` scene
- [ ] Add audio sliders (Master, Music, SFX, Ambience)
- [ ] Add motion sensitivity slider
- [ ] Implement accessibility toggles
- [ ] Add settings persistence (ConfigFile)
- [ ] Create `SettingsManager.gd` autoload

### 8.5 UI Polish
- [ ] Implement diegetic sound cues (replace UI feedback)
- [ ] Add UI animation/transitions
- [ ] Create contextual UI degradation
- [ ] Test UI across different coherence levels

---

## Phase 9: Audio Integration

### 9.1 Audio Manager
- [ ] Create `AudioManager.gd` autoload
- [ ] Implement audio bus routing
- [ ] Add volume control methods
- [ ] Create audio mixing system

### 9.2 Music System
- [ ] Set up music tracks (already have files)
- [ ] Implement dynamic music switching
- [ ] Add music transitions based on game state
- [ ] Connect music to coherence levels (harmonic swells)

### 9.3 Sound Effects
- [ ] Implement water impact sounds
- [ ] Add raft creaks and wind loops
- [ ] Create interaction sound effects
- [ ] Add consumption sounds (eating, drinking)

### 9.4 Ambience
- [ ] Set up ambience tracks (already have files)
- [ ] Implement layered ambience mixing
- [ ] Add weather-based ambience transitions
- [ ] Create echo/hallucination audio integration

---

## Phase 10: Save System

### 10.1 Save Manager
- [ ] Create `SaveManager.gd` autoload
- [ ] Implement save file structure
- [ ] Add auto-save at dawn functionality
- [ ] Create single save slot system
- [ ] Implement death wipe save logic

### 10.2 Save Data
- [ ] Serialize survival stats
- [ ] Save inventory state
- [ ] Save game time/day count
- [ ] Save player position/raft state
- [ ] Save weather/time of day

### 10.3 Load System
- [ ] Implement save file loading
- [ ] Restore game state from save
- [ ] Add save file validation
- [ ] Create "Continue" menu functionality

---

## Phase 11: Game Flow & Scenes

### 11.1 Main Game Scene
- [ ] Create `MainGame.tscn` scene
- [ ] Integrate all systems (player, raft, ocean, UI)
- [ ] Set up scene hierarchy
- [ ] Configure autoloads (AudioManager, SaveManager)
- [ ] Test complete game loop

### 11.2 Scene Manager
- [ ] Create `SceneManager.gd` autoload
- [ ] Implement scene transitions
- [ ] Add loading screen/splash
- [ ] Handle scene persistence

### 11.3 Game State Manager
- [ ] Create `GameStateManager.gd` autoload
- [ ] Implement game state machine (menu, playing, paused, dead)
- [ ] Add state transitions
- [ ] Manage game flow

---

## Phase 12: End Game & Death States

### 12.1 Death Conditions
- [ ] Implement death trigger (all stats depleted)
- [ ] Create death sequence/animation
- [ ] Add death screen UI
- [ ] Implement save wipe on death

### 12.2 End Game States
- [ ] Create surrender ending (player chooses to stop)
- [ ] Create death ending (stats depleted)
- [ ] Create ambiguous rescue ending (hallucination)
- [ ] Add ending credits/sequence

### 12.3 End Game Polish
- [ ] Write ending text/narration
- [ ] Add ending audio/ambience
- [ ] Create ending transitions
- [ ] Test all ending paths

---

## Phase 13: Visual Effects & Shaders

### 13.1 Visual Effects
- [ ] Create rain particle system (expand RainShowcase)
- [ ] Add fog effects
- [ ] Implement screen effects (vignette, color grading)
- [ ] Add coherence-based visual distortion

### 13.2 Shader Effects
- [ ] Create hallucination distortion shader
- [ ] Add UI degradation shader
- [ ] Implement water caustics
- [ ] Add skybox shader transitions

### 13.3 Lighting
- [ ] Set up day/night lighting
- [ ] Add dynamic light sources (flare, matches)
- [ ] Implement weather-based lighting
- [ ] Create mood lighting for hallucinations

---

## Phase 14: Polish & Optimization

### 14.1 Performance
- [ ] Profile game performance
- [ ] Optimize debris culling
- [ ] Optimize ocean shader
- [ ] Reduce draw calls
- [ ] Optimize audio memory usage

### 14.2 Bug Fixing
- [ ] Fix wave shader instability (if present)
- [ ] Fix audio memory leaks
- [ ] Fix build performance issues
- [ ] Test edge cases

### 14.3 Balancing
- [ ] Tune survival decay rates
- [ ] Balance debris spawn rates
- [ ] Adjust hallucination triggers
- [ ] Fine-tune pacing curve

### 14.4 Accessibility
- [ ] Add motion sensitivity options
- [ ] Implement colorblind support
- [ ] Add subtitles/captions (if needed)
- [ ] Test with different input methods

---

## Phase 15: Build & Release

### 15.1 Export Configuration
- [ ] Configure Windows export settings
- [ ] Configure Linux export settings
- [ ] Configure macOS export settings
- [ ] Test exports on target platforms

### 15.2 Build Optimization
- [ ] Minimize build size (<1GB target)
- [ ] Optimize asset compression
- [ ] Remove debug code/prints
- [ ] Test release builds

### 15.3 Release Preparation
- [ ] Create game icon
- [ ] Write itch.io page description
- [ ] Create screenshots/video
- [ ] Prepare attribution file (ATTRIBUTION.md already exists)
- [ ] Add MIT license
- [ ] Create build packages

### 15.4 Release
- [ ] Upload to itch.io
- [ ] Test download and installation
- [ ] Gather feedback
- [ ] Plan post-release updates

---

## Technical Debt & Future Enhancements

### Post-Release Considerations
- [ ] Expand debris types
- [ ] Add rare rescue event (secret ending)
- [ ] Implement expanded narrative elements
- [ ] Add more hallucination variants
- [ ] Create difficulty settings
- [ ] Add more weather types

---

## Milestones Summary

### Milestone 1: Vertical Slice (Current Target)
- [x] ✓ Survival system complete
- [ ] Player controller and movement
- [ ] Basic ocean/wave system
- [ ] Simple raft physics
- [ ] Basic UI (HUD, menus)
- [ ] Debris spawning and collection

### Milestone 2: Alpha
- [ ] Hallucination system (visual + audio)
- [ ] Weather system
- [ ] Day/night cycle
- [ ] Inventory system
- [ ] Save system

### Milestone 3: Beta
- [ ] All systems integrated
- [ ] Audio mixing complete
- [ ] Death states implemented
- [ ] Polish pass

### Milestone 4: Gold
- [ ] Final balancing
- [ ] Bug fixes
- [ ] Build optimization
- [ ] Release preparation

---

## Notes

- **Engine-First Configuration:** Always prefer Inspector/Project Settings over hardcoding
- **Single Source of Truth:** Centralize IDs and shared data in Resources
- **Signals over Polling:** Use Godot Signals/Groups for communication
- **Performance:** Cache node references, avoid heavy allocation in per-frame loops
- **Testing:** Test each system independently before integration

---

**Last Updated:** November 2025  
**Next Review:** After each milestone completion

