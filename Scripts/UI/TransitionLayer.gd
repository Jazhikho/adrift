extends Control
class_name TransitionLayer

## Handles scene transitions with fade effects

@onready var transition_rect: ColorRect = $TransitionRect

const FADE_DURATION: float = 0.5

func _ready() -> void:
	transition_rect.modulate.a = 0.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE

## Fade to black
func fade_out(duration: float = FADE_DURATION) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1.0, duration)
	await tween.finished

## Fade from black
func fade_in(duration: float = FADE_DURATION) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 0.0, duration)
	await tween.finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE

## Quick flash effect
func flash(color: Color = Color.WHITE, duration: float = 0.2) -> void:
	transition_rect.color = color
	transition_rect.modulate.a = 0.8
	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 0.0, duration)
