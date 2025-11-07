# Adrift: Echoes

> A survival tragedy set upon an infinite ocean where the line between starvation and revelation blurs.

## Overview

**Adrift: Echoes** is a survival psychological horror game where you drift alone in a liferaft after the end. Food, water, and hope slowly fade. As your body weakens, the waves begin to whisper, showing visions that might be memories—or hallucinations. There is no victory condition; the only goal is endurance.

**Genre:** Survival / Psychological Horror / Narrative Exploration  
**Target Platform:** PC (Windows, Linux, macOS)  
**Target Audience:** Mature players, ages 16+  
**Engine:** Godot 4.5 (GDScript)

## Getting Started

### Prerequisites

- **Godot Engine 4.5** or later
- Git (for version control)
- A text editor or IDE with GDScript support

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd adrift
```

2. Open the project in Godot 4.5
3. Run the project from the editor

### Building

Export targets are configured for:
- Windows (64-bit)
- Linux (64-bit)
- macOS (Universal)

Target specifications:
- Resolution: 1080p
- Frame rate: 60 FPS
- Build size: <1GB

## Project Structure

```
adrift/
├── Scenes/              # Godot scene files (.tscn)
│   ├── Player/         # Player character scenes
│   ├── Environment/    # Ocean, raft, and world scenes
│   └── UI/             # User interface scenes
├── Scripts/            # GDScript gameplay scripts
│   ├── Survival/       # Hunger, thirst, coherence systems
│   ├── HallucinationSystem/  # Echoes and hallucination mechanics
│   ├── Ocean/         # Wave mechanics and procedural ocean
│   ├── Inventory/     # Item and inventory management
│   ├── Player/        # Player controller and movement
│   └── UI/            # User interface scripts
├── Autoload/          # Singleton scripts (global services)
├── Resources/         # Godot resource files (.tres/.res)
│   ├── Data/         # Game data assets
│   ├── Materials/    # Material resources
│   └── Configs/      # Configuration files
├── Shaders/           # Shader files (.gdshader)
├── Audio/             # Audio assets
│   ├── Music/        # Background music
│   ├── SFX/          # Sound effects
│   └── Ambience/     # Environmental audio
├── Art/               # Art assets
│   ├── Models/       # 3D models
│   ├── Textures/     # Texture files
│   └── Materials/    # Material definitions
├── Tests/             # Test scenes and scripts
└── Docs/              # Documentation and design references
```

## Game Controls

- **Move/Look:** WASD + Mouse
- **Interact:** E
- **Inventory:** Tab
- **Ping:** Q
- **Rest:** R
- **Pause:** Esc

## Core Gameplay Loop

1. **Scavenge** — Gather floating debris and resources
2. **Consume** — Manage hunger, thirst, and supplies
3. **Maintain** — Patch leaks, tighten ropes
4. **Endure** — Survive through days and nights
5. **Deteriorate** — Experience hallucinations and echoes
6. **End** — Accept the inevitable

## Key Systems

### Survival System
Manage hunger, thirst, and coherence. Gather debris, catch rainwater, and ration supplies.

### Hallucination System ("Echoes")
At low coherence, ocean sounds transform into human voices or music. Visual mirages appear dynamically tied to survival states.

### Ocean & Wave Mechanics
Procedurally animated ocean with wave height linked to weather and emotional state.

### Save System
Auto-save each dawn. One slot; death wipes save.

### Key Principles

- **Engine-First Configuration:** Use Godot's Inspector, Input Map, and Project Settings instead of hardcoding
- **Single Source of Truth:** Centralize IDs and shared data in Resources
- **Signals over Polling:** Use Godot Signals/Groups instead of polling
- **Performance:** Cache node references, avoid heavy allocation in per-frame loops

## Technical Specifications

- **Engine:** Godot 4.5
- **Language:** GDScript
- **Rendering:** Forward+ (Clustered Forward Rendering)
- **Platforms:** Windows, Linux, macOS
- **Target Resolution:** 1080p @ 60 FPS
- **Build Size:** <1GB

## Story Structure

- **Act I: Survival** — Early days, gathering resources
- **Act II: Scarcity** — Supplies dwindle, hallucinations begin
- **Act III: Collapse** — Final degradation and acceptance

## Audio & Visual Design

- **Style:** Realistic low-poly minimalism
- **Color Palette:** Desaturated
- **Audio:** Sparse ambient drones and wave SFX
- **UI:** Minimal HUD, contextual degradation, no map

## Development Status

**Version:** 0.9 (Jam Draft)  
**Status:** Pre-Production / Active Jam Development  
**Last Updated:** November 2025

## Known Risks & Challenges

- Wave shader instability
- Slow pacing requiring careful balance
- Ambiguous ending requiring thoughtful implementation

## Credits

**Lead Designer:** Chris D.  
**Studio:** ForgeWalker Studios  
**Project Type:** Solo project

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- [Game Design Document](./Docs/Adrift_Echoes_GDD.md)
- [Development Plan](./Docs/DevelopmentPlan.md)
- [Survival System Documentation](./Docs/SurvivalSystem.md)

---

*"The ocean is the antagonist. Nature, not narrative, drives tension."*

