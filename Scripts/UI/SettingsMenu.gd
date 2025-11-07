extends Control
class_name SettingsMenu

## Settings menu controller with tabs for UI/UX and Controls

signal closed()
signal settings_changed(settings: Dictionary)

@onready var close_button: Button = $SettingsPanel/VBoxContainer/HeaderContainer/CloseButton
@onready var apply_button: Button = $SettingsPanel/VBoxContainer/ButtonContainer/ApplyButton
@onready var back_button: Button = $SettingsPanel/VBoxContainer/ButtonContainer/BackButton
@onready var tab_container: TabContainer = $SettingsPanel/VBoxContainer/TabContainer

# UI/UX tab controls
@onready var resolution_option: OptionButton = $SettingsPanel/VBoxContainer/TabContainer/UI_UX/VBoxContainer/VideoSection/ResolutionContainer/ResolutionOption
@onready var fullscreen_check: CheckBox = $SettingsPanel/VBoxContainer/TabContainer/UI_UX/VBoxContainer/VideoSection/FullscreenContainer/FullscreenCheck
@onready var vsync_check: CheckBox = $SettingsPanel/VBoxContainer/TabContainer/UI_UX/VBoxContainer/VideoSection/VSyncContainer/VSyncCheck

@onready var master_slider: HSlider = $SettingsPanel/VBoxContainer/TabContainer/UI_UX/VBoxContainer/AudioSection/MasterVolumeContainer/MasterSlider
@onready var sfx_slider: HSlider = $SettingsPanel/VBoxContainer/TabContainer/UI_UX/VBoxContainer/AudioSection/SFXVolumeContainer/SFXSlider
@onready var music_slider: HSlider = $SettingsPanel/VBoxContainer/TabContainer/UI_UX/VBoxContainer/AudioSection/MusicVolumeContainer/MusicSlider

# Controls tab
@onready var controls_list: VBoxContainer = $SettingsPanel/VBoxContainer/TabContainer/Controls/VBoxContainer/ControlsList

var current_settings: Dictionary = {}
var control_remapping: Dictionary = {}

const RESOLUTIONS: Array[String] = [
	"1280x720",
	"1920x1080",
	"2560x1440",
	"3840x2160"
]

func _ready() -> void:
	close_button.pressed.connect(close)
	back_button.pressed.connect(close)
	apply_button.pressed.connect(_apply_settings)
	
	_setup_ui_controls()
	_setup_control_mappings()
	_load_current_settings()

func _setup_ui_controls() -> void:
	# Setup resolution options
	for res in RESOLUTIONS:
		resolution_option.add_item(res)
	
	# Connect UI control signals
	resolution_option.item_selected.connect(_on_resolution_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	vsync_check.toggled.connect(_on_vsync_toggled)
	
	master_slider.value_changed.connect(_on_master_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)

func _setup_control_mappings() -> void:
	# Create control mapping UI
	var action_list: Array[String] = [
		"move_forward",
		"move_backward",
		"move_left",
		"move_right",
		"jump",
		"sprint",
		"interact",
		"ui_inventory",
		"ui_pause"
	]
	
	for action in action_list:
		var control_item: ControlRemapItem = preload("res://ui/ControlRemapItem.tscn").instantiate()
		control_item.setup(action)
		control_item.remap_requested.connect(_on_remap_requested)
		controls_list.add_child(control_item)

func _load_current_settings() -> void:
	# Load current game settings
	var window_size: Vector2i = DisplayServer.window_get_size()
	var current_res: String = "%dx%d" % [window_size.x, window_size.y]
	
	for i in RESOLUTIONS.size():
		if RESOLUTIONS[i] == current_res:
			resolution_option.select(i)
			break
	
	fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	vsync_check.button_pressed = DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED
	
	# Load audio settings
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	# Assuming bus 1 is SFX and bus 2 is Music
	if AudioServer.bus_count > 1:
		sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	if AudioServer.bus_count > 2:
		music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func open() -> void:
	visible = true
	_load_current_settings()

func close() -> void:
	visible = false
	closed.emit()

func _apply_settings() -> void:
	settings_changed.emit(current_settings)
	close()

func _on_resolution_changed(index: int) -> void:
	var res_parts: Array = RESOLUTIONS[index].split("x")
	current_settings["resolution"] = Vector2i(int(res_parts[0]), int(res_parts[1]))

func _on_fullscreen_toggled(pressed: bool) -> void:
	current_settings["fullscreen"] = pressed
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vsync_toggled(pressed: bool) -> void:
	current_settings["vsync"] = pressed
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if pressed else DisplayServer.VSYNC_DISABLED
	)

func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	current_settings["master_volume"] = value

func _on_sfx_volume_changed(value: float) -> void:
	if AudioServer.bus_count > 1:
		AudioServer.set_bus_volume_db(1, linear_to_db(value))
	current_settings["sfx_volume"] = value

func _on_music_volume_changed(value: float) -> void:
	if AudioServer.bus_count > 2:
		AudioServer.set_bus_volume_db(2, linear_to_db(value))
	current_settings["music_volume"] = value

func _on_remap_requested(action: String, button: Button) -> void:
	# Handle control remapping
	print("Remapping requested for: ", action)
	# Implementation depends on your input remapping system
