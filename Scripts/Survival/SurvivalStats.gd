extends Resource
class_name SurvivalStats

## Resource class for storing survival stat values (Hunger, Thirst, Coherence)
## Values are stored as normalized floats (0.0 to 1.0)

signal hunger_changed(new_value: float)
signal thirst_changed(new_value: float)
signal coherence_changed(new_value: float)
signal stat_depleted(stat_name: String)

const MIN_VALUE: float = 0.0
const MAX_VALUE: float = 1.0

var _hunger: float = 1.0
var _thirst: float = 1.0
var _coherence: float = 1.0

@export var hunger: float = 1.0:
	get:
		return _hunger
	set(value):
		var old_value: float = _hunger
		var clamped_value: float = clamp(value, MIN_VALUE, MAX_VALUE)
		_hunger = clamped_value
		if old_value != clamped_value:
			hunger_changed.emit(_hunger)
			if _hunger <= MIN_VALUE:
				stat_depleted.emit("hunger")

@export var thirst: float = 1.0:
	get:
		return _thirst
	set(value):
		var old_value: float = _thirst
		var clamped_value: float = clamp(value, MIN_VALUE, MAX_VALUE)
		_thirst = clamped_value
		if old_value != clamped_value:
			thirst_changed.emit(_thirst)
			if _thirst <= MIN_VALUE:
				stat_depleted.emit("thirst")

@export var coherence: float = 1.0:
	get:
		return _coherence
	set(value):
		var old_value: float = _coherence
		var clamped_value: float = clamp(value, MIN_VALUE, MAX_VALUE)
		_coherence = clamped_value
		if old_value != clamped_value:
			coherence_changed.emit(_coherence)
			if _coherence <= MIN_VALUE:
				stat_depleted.emit("coherence")

## Initialize survival stats with starting values
func _init(start_hunger: float = 1.0, start_thirst: float = 1.0, start_coherence: float = 1.0) -> void:
	hunger = start_hunger
	thirst = start_thirst
	coherence = start_coherence

## Modify hunger by a delta amount (positive for restore, negative for drain)
func modify_hunger(delta: float) -> void:
	hunger += delta

## Modify thirst by a delta amount (positive for restore, negative for drain)
func modify_thirst(delta: float) -> void:
	thirst += delta

## Modify coherence by a delta amount (positive for restore, negative for drain)
func modify_coherence(delta: float) -> void:
	coherence += delta

## Set hunger to a specific value
func set_hunger(value: float) -> void:
	hunger = value

## Set thirst to a specific value
func set_thirst(value: float) -> void:
	thirst = value

## Set coherence to a specific value
func set_coherence(value: float) -> void:
	coherence = value

## Get all stats as a dictionary
func get_all_stats() -> Dictionary:
	return {
		"hunger": hunger,
		"thirst": thirst,
		"coherence": coherence
	}

## Check if any stat is critically low (below threshold)
func is_any_stat_critical(threshold: float = 0.2) -> bool:
	return hunger <= threshold or thirst <= threshold or coherence <= threshold

## Check if all stats are depleted
func are_all_stats_depleted() -> bool:
	return hunger <= MIN_VALUE and thirst <= MIN_VALUE and coherence <= MIN_VALUE
