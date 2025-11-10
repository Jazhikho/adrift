## Overview

Adrift targets Godot 4.x and assumes a desktop runtime (Windows recommended for development). The project combines survival, exploration, and narrative systems around a persistent ocean environment. This document captures high-level requirements and enumerates external dependencies that must be present in every build or development environment.

## Core Requirements

1. Load and simulate an open-ocean environment with dynamic weather that influences wave height, visibility, and ambient audio.
2. Support player-controlled movement across the ocean scene, including interaction with UI overlays for inventory, stats, and narrative prompts.
3. Ensure survival mechanics (nutrition, hydration, sanity) tick at deterministic rates and synchronize with visual feedback in the HUD.
4. Provide automated test scenes that validate critical gameplay systems and regression-test ocean/weather integrations.

## External Dependencies

The following addons must be present in `addons/` and enabled via the Godot project settings:

- **Boujie Water Shader** (`addons/boujie_water_shader`)  
  Supplies shader logic and supporting assets for advanced ocean rendering, including foam animation, wave deformation, and editor tooling.

- **Godot Weather System** (`addons/GodotWeatherSystem`)  
  Provides configurable weather presets, seasonal variation data, and runtime controllers used to drive both visual and gameplay weather effects.

- **Terrain3D** (`addons/terrain_3d`)  
  Adds high-performance, editable terrain support backed by a GDExtension, enabling large-scale landmasses, sculpting workflows, and multi-LOD rendering for shoreline and island content.

## Tooling Requirements

- Godot Engine 4.2 or newer with Mono support (for integrated C# scripts bundled with third-party addons).
- Git LFS configured for large binary assets (audio, models, high-resolution textures).
- Automated test runner capable of executing headless Godot scenes defined in `Tests/`.

## Non-Functional Requirements

- Maintain sub-5 second scene load time on a mid-range development machine (Ryzen 5 / 16 GB RAM / SSD).
- Ensure stable 60 FPS in the graybox test scene with default weather settings.
- Keep CI linting and static analysis free from warnings; treat warnings as build failures.

## Change Control

- Every new dependency or addon must be documented in this file and added to version control tracking rules.
- Large binary assets introduced by addons must be evaluated for Git LFS eligibility prior to commit.

