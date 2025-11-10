class_name TerrainOceanInteraction
extends Node

## Manages the interaction between terrain shoreline and ocean waves.
## Adjusts wave intensity near shores and provides shoreline foam data.

@export var terrain: Terrain3D
@export var water_designer: WaterMaterialDesigner
@export var ocean_y_position: float = 0.0

## Distance from shore where waves start to reduce
@export var shore_influence_distance: float = 50.0

## Minimum wave intensity at the shore (percentage of open water)
@export_range(0.1, 1.0) var shore_wave_reduction: float = 0.3

var _terrain_data: Resource


## Caches terrain data reference on ready.
func _ready() -> void:
	if terrain == null:
		push_error("TerrainOceanInteraction: terrain is null")
		return
	
	if water_designer == null:
		push_error("TerrainOceanInteraction: water_designer is null")
		return
	
	_terrain_data = terrain.get("data")
	if _terrain_data == null:
		push_error("TerrainOceanInteraction: Could not get terrain data")
		return
	
	# Connect to terrain changes if we want dynamic updates
	if _terrain_data.has_signal("maps_edited"):
		_terrain_data.maps_edited.connect(_on_terrain_edited)


## Handles terrain edits by updating shore parameters.
func _on_terrain_edited(edited_area: AABB) -> void:
	# Could update shore foam maps here if needed
	pass


## Gets the terrain height at a world position.
## @param world_pos: Global position to query
## @returns: Terrain height at position, or ocean_y_position if outside terrain
func get_terrain_height(world_pos: Vector3) -> float:
	if _terrain_data and _terrain_data.has_method("get_height"):
		return _terrain_data.get_height(world_pos)
	return ocean_y_position


## Calculates wave intensity reduction based on proximity to shore.
## @param world_pos: Position to check
## @returns: Multiplier from shore_wave_reduction to 1.0
func get_shore_wave_multiplier(world_pos: Vector3) -> float:
	var height: float = get_terrain_height(world_pos)
	var depth: float = ocean_y_position - height
	
	# Above water or very shallow
	if depth <= 0.5:
		return shore_wave_reduction
	
	# Calculate falloff based on depth/distance
	var factor: float = clamp(depth / shore_influence_distance, 0.0, 1.0)
	return lerp(shore_wave_reduction, 1.0, factor)
