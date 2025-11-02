extends Node
class_name SurvivalSystem

## Node-based system managing Hunger, Thirst, and Coherence survival stats
## Handles stat decay over time and provides methods for restoration
## Add this node to the scene tree to enable automatic stat decay

signal stats_updated(stats: SurvivalStats)
signal player_died()

const DEFAULT_HUNGER_DECAY_RATE: float = 0.01 # Per second
const DEFAULT_THIRST_DECAY_RATE: float = 0.015 # Per second (thirst decays faster)
const DEFAULT_COHERENCE_DECAY_RATE: float = 0.005 # Per second

var stats: SurvivalStats = SurvivalStats.new()
var is_active: bool = true

## Decay rates per second (can be modified by game state)
var hunger_decay_rate: float = DEFAULT_HUNGER_DECAY_RATE
var thirst_decay_rate: float = DEFAULT_THIRST_DECAY_RATE
var coherence_decay_rate: float = DEFAULT_COHERENCE_DECAY_RATE

func _ready() -> void:
	stats.hunger_changed.connect(_on_hunger_changed)
	stats.thirst_changed.connect(_on_thirst_changed)
	stats.coherence_changed.connect(_on_coherence_changed)
	stats.stat_depleted.connect(_on_stat_depleted)

func _process(delta: float) -> void:
	if not is_active:
		return
	
	_decay_stats(delta)
	stats_updated.emit(stats)

## Apply decay to all stats based on time delta
func _decay_stats(delta: float) -> void:
	stats.modify_hunger(-hunger_decay_rate * delta)
	stats.modify_thirst(-thirst_decay_rate * delta)
	stats.modify_coherence(-coherence_decay_rate * delta)
	
	# Coherence also decays faster when hunger/thirst are low
	var hunger_thirst_factor: float = (stats.hunger + stats.thirst) / 2.0
	if hunger_thirst_factor < 0.5:
		var additional_coherence_decay: float = (0.5 - hunger_thirst_factor) * 0.01 * delta
		stats.modify_coherence(-additional_coherence_decay)

## Restore hunger by a specific amount
func restore_hunger(amount: float) -> void:
	if not is_active:
		return
	stats.modify_hunger(amount)

## Restore thirst by a specific amount
func restore_thirst(amount: float) -> void:
	if not is_active:
		return
	stats.modify_thirst(amount)

## Restore coherence by a specific amount (only works early game)
func restore_coherence(amount: float) -> void:
	if not is_active:
		return
	# Coherence restoration becomes less effective over time
	# Early game: full restoration, late game: minimal restoration
	var restoration_multiplier: float = 1.0
	if stats.coherence < 0.3:
		restoration_multiplier = 0.3 # Very limited restoration when low
	stats.modify_coherence(amount * restoration_multiplier)

## Set decay rates (useful for difficulty adjustments or game state changes)
func set_decay_rates(hunger_rate: float, thirst_rate: float, coherence_rate: float) -> void:
	hunger_decay_rate = max(0.0, hunger_rate)
	thirst_decay_rate = max(0.0, thirst_rate)
	coherence_decay_rate = max(0.0, coherence_rate)

## Reset all stats to full
func reset_stats() -> void:
	stats.set_hunger(1.0)
	stats.set_thirst(1.0)
	stats.set_coherence(1.0)

## Enable or disable the survival system
func set_active(active: bool) -> void:
	is_active = active

## Get current stats resource
func get_stats() -> SurvivalStats:
	return stats

func _on_hunger_changed(new_value: float) -> void:
	pass # Can be extended for game logic

func _on_thirst_changed(new_value: float) -> void:
	pass # Can be extended for game logic

func _on_coherence_changed(new_value: float) -> void:
	pass # Can be extended for game logic

func _on_stat_depleted(stat_name: String) -> void:
	print("STAT DEPLETED: ", stat_name)
	if stats.are_all_stats_depleted():
		player_died.emit()
