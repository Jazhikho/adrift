# Survival System Documentation

## Overview

The Survival System manages three core survival statistics for the player: **Hunger**, **Thirst**, and **Coherence** (mental stability/sanity). All values are normalized floats ranging from `0.0` (depleted) to `1.0` (full). The system automatically decays these stats over time and provides methods for restoration through gameplay actions.

## Architecture

The survival system consists of two main components:

1. **`SurvivalStats`** - A Resource class that stores and manages the three stat values
2. **`SurvivalSystem`** - A Node class that handles automatic decay and provides restoration methods

## Components

### SurvivalStats (Resource)

**Location:** `Scripts/Survival/SurvivalStats.gd`

A Resource class that holds the three survival stat values. All stats are automatically clamped between 0.0 and 1.0. The class emits signals when stats change or become depleted.

#### Properties

- `hunger` (float): Hunger level (0.0 = starving, 1.0 = full)
- `thirst` (float): Thirst level (0.0 = dehydrated, 1.0 = hydrated)
- `coherence` (float): Mental stability (0.0 = broken, 1.0 = stable)

#### Signals

- `hunger_changed(new_value: float)` - Emitted when hunger value changes
- `thirst_changed(new_value: float)` - Emitted when thirst value changes
- `coherence_changed(new_value: float)` - Emitted when coherence value changes
- `stat_depleted(stat_name: String)` - Emitted when any stat reaches 0.0

#### Methods

**Modification:**
- `modify_hunger(delta: float)` - Add/subtract from hunger (positive restores, negative drains)
- `modify_thirst(delta: float)` - Add/subtract from thirst
- `modify_coherence(delta: float)` - Add/subtract from coherence

**Direct Setting:**
- `set_hunger(value: float)` - Set hunger to a specific value
- `set_thirst(value: float)` - Set thirst to a specific value
- `set_coherence(value: float)` - Set coherence to a specific value

**Query:**
- `get_all_stats() -> Dictionary` - Returns all stats as a dictionary
- `is_any_stat_critical(threshold: float = 0.2) -> bool` - Checks if any stat is below threshold
- `are_all_stats_depleted() -> bool` - Checks if all stats are at 0.0

### SurvivalSystem (Node)

**Location:** `Scripts/Survival/SurvivalSystem.gd`

A Node-based system that manages automatic stat decay and provides restoration methods. Add this node to your scene tree to enable automatic stat decay during gameplay.

#### Properties

- `stats: SurvivalStats` - The stats resource being managed
- `is_active: bool` - Whether the system is currently decaying stats
- `hunger_decay_rate: float` - Decay rate per second (default: 0.01)
- `thirst_decay_rate: float` - Decay rate per second (default: 0.015)
- `coherence_decay_rate: float` - Decay rate per second (default: 0.005)

#### Signals

- `stats_updated(stats: SurvivalStats)` - Emitted every frame when stats are updated
- `player_died()` - Emitted when all stats reach 0.0

#### Methods

**Restoration:**
- `restore_hunger(amount: float)` - Restore hunger by a specific amount
- `restore_thirst(amount: float)` - Restore thirst by a specific amount
- `restore_coherence(amount: float)` - Restore coherence (limited when low)

**Configuration:**
- `set_decay_rates(hunger_rate: float, thirst_rate: float, coherence_rate: float)` - Set custom decay rates
- `set_active(active: bool)` - Enable/disable automatic decay
- `reset_stats()` - Reset all stats to full (1.0)

**Access:**
- `get_stats() -> SurvivalStats` - Get the current stats resource

## How It Works

### Automatic Decay

When `SurvivalSystem` is active and in the scene tree, it automatically decays stats every frame based on delta time:

- **Hunger:** Decays at `hunger_decay_rate` per second (default: 0.01)
- **Thirst:** Decays at `thirst_decay_rate` per second (default: 0.015, faster than hunger)
- **Coherence:** Decays at `coherence_decay_rate` per second (default: 0.005, slowest)

### Accelerated Coherence Decay

When hunger and thirst combined average below 0.5, coherence decays faster. The additional decay is calculated as:

```
additional_decay = (0.5 - average_hunger_thirst) * 0.01 * delta
```

This creates a cascading effect where physical deprivation accelerates mental collapse.

### Coherence Restoration Limitation

Coherence restoration becomes less effective as the player's mental state deteriorates:

- **Above 0.3 coherence:** Full restoration (100% of restoration amount)
- **Below 0.3 coherence:** Limited restoration (30% of restoration amount)

This reflects the narrative theme that mental collapse is difficult to reverse once it begins.

## Usage Examples

### Basic Setup

```gdscript
# In your game scene, add SurvivalSystem as a child node
var survival_system: SurvivalSystem = SurvivalSystem.new()
add_child(survival_system)

# Connect to signals
survival_system.player_died.connect(_on_player_died)
survival_system.stats_updated.connect(_on_stats_updated)
survival_system.stats.hunger_changed.connect(_on_hunger_changed)
```

### Restoring Stats

```gdscript
# Player eats food
survival_system.restore_hunger(0.3)  # Restore 30% hunger

# Player drinks water
survival_system.restore_thirst(0.5)  # Restore 50% thirst

# Player finds hope/rests
survival_system.restore_coherence(0.1)  # Restore 10% coherence (limited if low)
```

### Checking Stat Status

```gdscript
var current_stats: SurvivalStats = survival_system.get_stats()

# Check individual stats
if current_stats.hunger < 0.2:
    print("Warning: Hunger critical!")

# Check if any stat is critical
if current_stats.is_any_stat_critical(0.2):
    show_warning_ui()

# Check if player is dead
if current_stats.are_all_stats_depleted():
    trigger_death_sequence()
```

### Adjusting Decay Rates

```gdscript
# Make survival harder (faster decay)
survival_system.set_decay_rates(0.02, 0.03, 0.01)  # Hunger, Thirst, Coherence

# Make survival easier (slower decay)
survival_system.set_decay_rates(0.005, 0.008, 0.002)

# Pause decay during cutscenes
survival_system.set_active(false)
```

### Listening to Stat Changes

```gdscript
func _ready() -> void:
    survival_system.stats.hunger_changed.connect(_on_hunger_changed)
    survival_system.stats.thirst_changed.connect(_on_thirst_changed)
    survival_system.stats.coherence_changed.connect(_on_coherence_changed)
    survival_system.stats.stat_depleted.connect(_on_stat_depleted)

func _on_hunger_changed(new_value: float) -> void:
    update_hunger_bar(new_value)
    if new_value < 0.3:
        play_hunger_warning_sound()

func _on_stat_depleted(stat_name: String) -> void:
    match stat_name:
        "hunger":
            trigger_starvation_effects()
        "thirst":
            trigger_dehydration_effects()
        "coherence":
            trigger_madness_effects()
```

## Design Decisions

### Normalized Values (0.0 to 1.0)

All stats use normalized values to simplify:
- UI display (multiply by 100 for percentages)
- Shader-based visual effects
- Math calculations
- Serialization/saving

### Signal-Based Architecture

Stats emit signals when values change, enabling:
- Decoupled UI updates
- Event-driven gameplay responses
- Easy integration with other systems
- No polling required

### Separate Resource and Node

- **SurvivalStats** (Resource): Pure data storage, can be saved/loaded, referenced by multiple systems
- **SurvivalSystem** (Node): Gameplay logic, scene-tree integration, automatic decay

This separation allows stats to be saved independently and shared across different contexts.

### Automatic Decay Rates

Default decay rates are tuned for gameplay:
- **Thirst decays fastest** (most immediate survival need)
- **Hunger decays moderately** (sustained need)
- **Coherence decays slowest** (long-term psychological pressure)

These can be adjusted per difficulty level or game state.

### Cascading Failure

Low hunger/thirst accelerate coherence decay, creating a cascading failure mechanic:
- Physical deprivation → Mental collapse
- Reflects real-world survival psychology
- Creates tension and urgency
- Encourages proactive resource management

## Integration Points

### UI System

Connect to `stats_updated` or individual stat change signals to update HUD elements:

```gdscript
func _on_stats_updated(stats: SurvivalStats) -> void:
    hunger_bar.value = stats.hunger * 100
    thirst_bar.value = stats.thirst * 100
    coherence_bar.value = stats.coherence * 100
```

### Hallucination System

Connect to `coherence_changed` to trigger hallucination effects:

```gdscript
func _on_coherence_changed(new_value: float) -> void:
    if new_value < 0.3:
        hallucination_system.enable_tier_1()
    elif new_value < 0.1:
        hallucination_system.enable_tier_2()
```

### Save System

SurvivalStats is a Resource, so it can be easily saved:

```gdscript
# Save
ResourceSaver.save(survival_system.stats, "user://save_stats.tres")

# Load
var loaded_stats: SurvivalStats = load("user://save_stats.tres") as SurvivalStats
survival_system.stats = loaded_stats
```

### Item System

Items can restore stats when consumed:

```gdscript
func consume_food(item: Item) -> void:
    survival_system.restore_hunger(item.hunger_value)
    inventory.remove_item(item)
```

## Testing

A comprehensive test suite is available at `Tests/SurvivalSystemTest.tscn`. Run this scene to validate:
- Stat initialization and modification
- Signal emission
- Clamping behavior
- Coherence restoration limitations
- Decay mechanics
- System active/inactive states

All tests print results to the Godot console.

## Performance Considerations

- **Minimal overhead:** Decay calculations are simple arithmetic operations
- **Signal optimization:** Signals only emit when values actually change (not on every frame)
- **No allocations:** Stat modifications use existing resources, no garbage collection pressure
- **Scene tree integration:** Only runs when `is_active` is true

## Future Enhancements

Potential additions to consider:
- Weather/environment modifiers to decay rates
- Time-of-day effects (hunger/thirst decay faster during day)
- Activity modifiers (resting slows decay, swimming increases thirst decay)
- Stat thresholds for gameplay events (stomach rumbling at 0.5 hunger)
- Visual/audio feedback tied to stat levels

## References

- **Source Code:** `Scripts/Survival/`
- **Tests:** `Tests/SurvivalSystemTest.tscn`
- **Game Design Document:** `Docs/Adrift_Echoes_GDD.md`

---

**Last Updated:** November 2025  
**Version:** 1.0

