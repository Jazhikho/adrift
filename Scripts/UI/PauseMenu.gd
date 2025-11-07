extends Control
class_name PauseMenu

## Pause menu controller

signal resumed()
signal settings_requested()
signal main_menu_requested()
signal quit_requested()

@onready var resume_button: Button = $MenuPanel/VBoxContainer/ResumeButton
@onready var settings_button: Button = $MenuPanel/VBoxContainer/SettingsButton
@onready var main_menu_button: Button = $MenuPanel/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $MenuPanel/VBoxContainer/QuitButton

func _ready() -> void:
	resume_button.pressed.connect(resume)
	settings_button.pressed.connect(_on_settings_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func open() -> void:
	visible = true
	resume_button.grab_focus()

func close() -> void:
	visible = false

func resume() -> void:
	close()
	resumed.emit()

func _on_settings_pressed() -> void:
	settings_requested.emit()

func _on_main_menu_pressed() -> void:
	main_menu_requested.emit()

func _on_quit_pressed() -> void:
	quit_requested.emit()
