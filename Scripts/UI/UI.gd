extends CanvasLayer
class_name GameUI

## Main UI controller that manages all UI subsystems

@onready var hud: HUD = $HUD
@onready var inventory_menu: InventoryMenu = $InventoryMenu
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var transition_layer: TransitionLayer = $TransitionLayer

var survival_system: SurvivalSystem
var is_any_menu_open: bool = false

signal ui_opened(menu_name: String)
signal ui_closed(menu_name: String)

func _ready() -> void:
	# Connect menu signals
	inventory_menu.closed.connect(_on_inventory_closed)
	inventory_menu.item_used.connect(_on_item_used)
	
	pause_menu.resumed.connect(_on_pause_menu_resumed)
	pause_menu.settings_requested.connect(_on_settings_requested)
	pause_menu.main_menu_requested.connect(_on_main_menu_requested)
	pause_menu.quit_requested.connect(_on_quit_requested)
	
	settings_menu.closed.connect(_on_settings_closed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		if is_any_menu_open and not pause_menu.visible:
			# Close other menus if open
			close_all_menus()
		else:
			toggle_pause()
	elif event.is_action_pressed("ui_inventory"):
		if not pause_menu.visible:
			toggle_inventory()

## Initialize UI with required systems
func initialize(survival_sys: SurvivalSystem) -> void:
	survival_system = survival_sys
	hud.set_survival_system(survival_system)

## Show subtitle text
func show_subtitle(text: String, duration: float = 3.0) -> void:
	hud.show_subtitle(text, duration)

## Toggle inventory menu
func toggle_inventory() -> void:
	if inventory_menu.visible:
		inventory_menu.close()
	else:
		inventory_menu.open()
		is_any_menu_open = true
		ui_opened.emit("inventory")

## Toggle pause menu
func toggle_pause() -> void:
	if pause_menu.visible:
		pause_menu.resume()
	else:
		pause_menu.open()
		get_tree().paused = true
		is_any_menu_open = true
		ui_opened.emit("pause")

## Open settings menu
func open_settings() -> void:
	settings_menu.open()
	is_any_menu_open = true
	ui_opened.emit("settings")

## Close all menus
func close_all_menus() -> void:
	inventory_menu.close()
	pause_menu.close()
	settings_menu.close()
	is_any_menu_open = false

## Transition to a new scene
func transition_to_scene(scene_path: String) -> void:
	await transition_layer.fade_out()
	get_tree().change_scene_to_file(scene_path)
	await transition_layer.fade_in()

func _on_inventory_closed() -> void:
	is_any_menu_open = pause_menu.visible or settings_menu.visible
	ui_closed.emit("inventory")

func _on_pause_menu_resumed() -> void:
	get_tree().paused = false
	is_any_menu_open = false
	ui_closed.emit("pause")

func _on_settings_requested() -> void:
	pause_menu.close()
	open_settings()

func _on_settings_closed() -> void:
	if get_tree().paused:
		pause_menu.open()
	else:
		is_any_menu_open = false
	ui_closed.emit("settings")

func _on_main_menu_requested() -> void:
	get_tree().paused = false
	transition_to_scene("res://scenes/MainMenu.tscn")

func _on_quit_requested() -> void:
	get_tree().quit()

func _on_item_used(item: InventoryItem) -> void:
	# Forward to game logic
	print("Item used: ", item.name)
