extends Control
class_name HUD

## HUD controller managing stat displays, subtitles, compass, and interaction prompts

@onready var energy_bar: TextureProgressBar = $StatsContainer/EnergyBar/ProgressBar
@onready var hunger_bar: TextureProgressBar = $StatsContainer/HungerBar/ProgressBar
@onready var thirst_bar: TextureProgressBar = $StatsContainer/ThirstBar/ProgressBar
@onready var subtitle_label: RichTextLabel = $SubtitleContainer/SubtitlePanel/SubtitleLabel
@onready var subtitle_container: MarginContainer = $SubtitleContainer

# Compass elements
@onready var compass_container: CenterContainer = $CompassContainer
@onready var compass_bar: Control = $CompassContainer/CompassPanel/VBoxContainer/CompassBar
@onready var direction_markers: Control = $CompassContainer/CompassPanel/VBoxContainer/CompassBar/DirectionMarkers
@onready var degrees_label: Label = $CompassContainer/CompassPanel/VBoxContainer/DegreesLabel

# Interaction prompt elements
@onready var interaction_prompt_container: CenterContainer = $InteractionPromptContainer
@onready var prompt_panel: PanelContainer = $InteractionPromptContainer/PromptPanel
@onready var key_icon: Label = $InteractionPromptContainer/PromptPanel/HBoxContainer/KeyIcon
@onready var prompt_label: Label = $InteractionPromptContainer/PromptPanel/HBoxContainer/PromptLabel

var survival_system: SurvivalSystem
var subtitle_timer: Timer
var current_rotation: float = 0.0

# Compass settings
const COMPASS_WIDTH: float = 180.0
const COMPASS_DIRECTIONS: Array[String] = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
const COMPASS_ANGLES: Array[float] = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0]

func _ready() -> void:
	# Setup subtitle timer
	subtitle_timer = Timer.new()
	subtitle_timer.one_shot = true
	subtitle_timer.timeout.connect(_hide_subtitle)
	add_child(subtitle_timer)
	
	# Initially hide elements
	subtitle_container.visible = false
	prompt_panel.visible = false
	
	# Configure progress bars
	_setup_progress_bars()
	
	# Setup compass
	_setup_compass()

func _setup_progress_bars() -> void:
	# Configure progress bar properties
	for bar in [energy_bar, hunger_bar, thirst_bar]:
		bar.min_value = 0.0
		bar.max_value = 1.0
		bar.value = 1.0

func _setup_compass() -> void:
	# Create direction labels for compass
	for i in range(COMPASS_DIRECTIONS.size()):
		var label: Label = Label.new()
		label.text = COMPASS_DIRECTIONS[i]
		label.add_theme_font_size_override("font_size", 12)
		direction_markers.add_child(label)

func _process(_delta: float) -> void:
	# Update compass direction markers position based on rotation
	_update_compass_display()

## Set the survival system to monitor
func set_survival_system(system: SurvivalSystem) -> void:
	if survival_system:
		survival_system.stats_updated.disconnect(_on_stats_updated)
	
	survival_system = system
	survival_system.stats_updated.connect(_on_stats_updated)
	_on_stats_updated(survival_system.get_stats())

## Update stat displays
func _on_stats_updated(stats: SurvivalStats) -> void:
	energy_bar.value = stats.energy
	hunger_bar.value = stats.hunger
	thirst_bar.value = stats.thirst
	
	# Update bar colors based on critical levels
	_update_bar_color(energy_bar, stats.energy)
	_update_bar_color(hunger_bar, stats.hunger)
	_update_bar_color(thirst_bar, stats.thirst)

func _update_bar_color(bar: TextureProgressBar, value: float) -> void:
	if value <= 0.2:
		bar.tint_progress = Color.RED
	elif value <= 0.5:
		bar.tint_progress = Color.YELLOW
	else:
		bar.tint_progress = Color.GREEN

## Show subtitle text
func show_subtitle(text: String, duration: float = 3.0) -> void:
	subtitle_label.text = text
	subtitle_container.visible = true
	subtitle_timer.start(duration)

func _hide_subtitle() -> void:
	subtitle_container.visible = false
	subtitle_label.text = ""

## Update player rotation for compass
func update_player_rotation(rotation_degrees: float) -> void:
	current_rotation = rotation_degrees
	degrees_label.text = "%d°" % int(rotation_degrees)

func _update_compass_display() -> void:
	# Update positions of direction markers based on current rotation
	for i in range(direction_markers.get_child_count()):
		var label: Label = direction_markers.get_child(i)
		var angle: float = COMPASS_ANGLES[i]
		var relative_angle: float = wrapf(angle - current_rotation, -180.0, 180.0)
		
		# Calculate position on compass bar
		var x_position: float = (relative_angle / 180.0) * (COMPASS_WIDTH / 2.0) + (COMPASS_WIDTH / 2.0)
		
		# Hide labels that would be outside the compass bounds
		if abs(relative_angle) > 90:
			label.visible = false
		else:
			label.visible = true
			label.position.x = x_position - label.size.x / 2.0
			label.position.y = compass_bar.size.y / 2.0 - label.size.y / 2.0
			
			# Fade labels at edges
			var fade_distance: float = 75.0
			var alpha: float = 1.0 - (abs(relative_angle) - fade_distance) / (90.0 - fade_distance)
			label.modulate.a = clamp(alpha, 0.0, 1.0)

## Show interaction prompt
func show_interaction_prompt(action_name: String, prompt_text: String) -> void:
	var key_text: String = _get_action_key_text(action_name)
	key_icon.text = "[%s]" % key_text
	prompt_label.text = prompt_text
	prompt_panel.visible = true

## Hide interaction prompt
func hide_interaction_prompt() -> void:
	prompt_panel.visible = false

## Get the display text for an action's key binding
func _get_action_key_text(action_name: String) -> String:
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() > 0:
		var event: InputEvent = events[0]
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			return "Mouse%d" % event.button_index
		elif event is InputEventJoypadButton:
			return "Button%d" % event.button_index
	return "?"

## Toggle compass visibility
func set_compass_visible(visible: bool) -> void:
	compass_container.visible = visible
