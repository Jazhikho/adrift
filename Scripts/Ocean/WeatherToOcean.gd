class_name OceanWeatherBridge
extends Node

## Bridges the Weather System to the Boujie Water Shader, dynamically adjusting
## ocean wave intensity based on current weather conditions.

signal wave_intensity_changed(intensity: float)

## Reference to the WeatherController (C# node)
@export var weather_controller: Node

## Reference to the WaterMaterialDesigner that controls the ocean shader
@export var water_material_designer: WaterMaterialDesigner

@export_group("Wave Intensity")
## Baseline wave multiplier during calm weather (fine/clear skies)
@export_range(0.1, 2.0) var calm_intensity: float = 1.0

## Wave multiplier during stormy weather (heavy rain/high winds)
@export_range(1.0, 5.0) var storm_intensity: float = 3.0

## How quickly waves transition between intensities (lower = smoother)
@export_range(0.01, 1.0) var transition_smoothness: float = 0.1

@export_group("Weather Thresholds")
## Cloud cover above this value is considered stormy
@export_range(0.0, 1.0) var storm_cloud_threshold: float = 0.7

## Fog density above this value increases wave intensity
@export_range(0.0, 1.0) var fog_intensity_threshold: float = 0.02

var _base_height_waves: Array[GerstnerWave] = []
var _base_foam_waves: Array[GerstnerWave] = []
var _base_uv_waves: Array[GerstnerWave] = []
var _current_intensity: float = 1.0
var _target_intensity: float = 1.0


## Caches base wave configurations and connects to the weather system.
func _ready() -> void:
	if weather_controller == null:
		push_error("OceanWeatherBridge: weather_controller is null. Assign WeatherController node.")
		return
	
	if water_material_designer == null:
		push_error("OceanWeatherBridge: water_material_designer is null. Assign WaterMaterialDesigner node.")
		return
	
	_cache_base_waves()
	_connect_to_weather_system()
	_current_intensity = calm_intensity
	_target_intensity = calm_intensity


## Updates wave intensity smoothly toward the target based on current weather.
func _process(delta: float) -> void:
	if _current_intensity != _target_intensity:
		_current_intensity = lerp(_current_intensity, _target_intensity, transition_smoothness)
		_apply_wave_intensity(_current_intensity)
		wave_intensity_changed.emit(_current_intensity)


## Stores the initial wave configurations as baseline values.
func _cache_base_waves() -> void:
	for wave in water_material_designer.height_waves:
		if wave != null:
			_base_height_waves.append(wave.duplicate())
	
	for wave in water_material_designer.foam_waves:
		if wave != null:
			_base_foam_waves.append(wave.duplicate())
	
	for wave in water_material_designer.uv_waves:
		if wave != null:
			_base_uv_waves.append(wave.duplicate())


## Subscribes to the C# WeatherController's onWeatherChange action.
func _connect_to_weather_system() -> void:
	var callable: Callable = Callable(self, "_on_weather_changed")
	weather_controller.onWeatherChange += callable


## Handles weather changes from the WeatherController and calculates new intensity.
## @param weather_resource: The WeatherResource from the C# weather system
func _on_weather_changed(weather_resource: Resource) -> void:
	if weather_resource == null:
		push_warning("OceanWeatherBridge: Received null weather_resource.")
		return
	
	var intensity: float = _calculate_intensity_from_weather(weather_resource)
	_target_intensity = intensity


## Calculates wave intensity based on weather parameters.
## @param weather_resource: The current WeatherResource
## @returns: Float intensity multiplier between calm_intensity and storm_intensity
func _calculate_intensity_from_weather(weather_resource: Resource) -> float:
	var cloud_cover: float = _get_weather_property(weather_resource, "smallCloudCover", 0.0)
	cloud_cover = max(cloud_cover, _get_weather_property(weather_resource, "largeCloudCover", 0.0))
	
	var fog_density: float = _get_weather_property(weather_resource, "fogDensity", 0.0)
	var cloud_speed: float = _get_weather_property(weather_resource, "cloudSpeed", 0.001)
	
	var storm_factor: float = 0.0
	
	if cloud_cover > storm_cloud_threshold:
		storm_factor = (cloud_cover - storm_cloud_threshold) / (1.0 - storm_cloud_threshold)
	
	if fog_density > fog_intensity_threshold:
		var fog_contribution: float = (fog_density - fog_intensity_threshold) / (1.0 - fog_intensity_threshold)
		storm_factor = max(storm_factor, fog_contribution * 0.7)
	
	var wind_factor: float = clamp(cloud_speed / 0.01, 0.0, 1.0)
	storm_factor = max(storm_factor, wind_factor * 0.5)
	
	return lerp(calm_intensity, storm_intensity, storm_factor)


## Safely retrieves a property from the C# weather resource.
## @param resource: The resource to query
## @param property_name: Name of the property to retrieve
## @param default_value: Fallback value if property doesn't exist
## @returns: Property value or default
func _get_weather_property(resource: Resource, property_name: String, default_value: float) -> float:
	if resource.get(property_name) != null:
		return resource.get(property_name)
	return default_value


## Applies intensity multiplier to all cached wave arrays.
## @param intensity: Multiplier for wave amplitude, steepness, and speed
func _apply_wave_intensity(intensity: float) -> void:
	_apply_intensity_to_wave_group(
		water_material_designer.height_waves,
		_base_height_waves,
		intensity
	)
	
	_apply_intensity_to_wave_group(
		water_material_designer.foam_waves,
		_base_foam_waves,
		intensity
	)
	
	_apply_intensity_to_wave_group(
		water_material_designer.uv_waves,
		_base_uv_waves,
		intensity
	)
	
	water_material_designer.update()


## Scales wave parameters based on intensity multiplier.
## @param target_waves: Live wave array to modify
## @param base_waves: Original wave configurations
## @param intensity: Multiplier for amplitude, steepness, and speed
func _apply_intensity_to_wave_group(
	target_waves: Array,
	base_waves: Array,
	intensity: float
) -> void:
	var count: int = min(target_waves.size(), base_waves.size())
	for i in range(count):
		if target_waves[i] == null or base_waves[i] == null:
			continue
		
		target_waves[i].amplitude = base_waves[i].amplitude * intensity
		target_waves[i].steepness = base_waves[i].steepness * clamp(intensity, 0.5, 2.0)
		target_waves[i].speed = base_waves[i].speed * intensity