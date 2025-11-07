extends Area3D
class_name Interactable

## Base class for interactable objects

signal interacted(player)

@export var interaction_prompt: String = "Interact"
@export var interaction_action: String = "interact"
@export var one_shot: bool = false
@export var interaction_distance: float = 3.0

var is_player_nearby: bool = false
var has_been_used: bool = false
var player_ref: Node3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Set collision layer/mask appropriately
	collision_layer = 4  # Interactables layer
	collision_mask = 1   # Player layer

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("is_player") or body.is_in_group("player"):
		is_player_nearby = true
		player_ref = body
		
		if not has_been_used or not one_shot:
			_show_interaction_prompt()

func _on_body_exited(body: Node3D) -> void:
	if body == player_ref:
		is_player_nearby = false
		player_ref = null
		_hide_interaction_prompt()

func _input(event: InputEvent) -> void:
	if is_player_nearby and event.is_action_pressed(interaction_action):
		if not has_been_used or not one_shot:
			interact(player_ref)

func interact(player: Node3D) -> void:
	interacted.emit(player)
	
	if one_shot:
		has_been_used = true
		_hide_interaction_prompt()
	
	_on_interact(player)

## Override this in derived classes
func _on_interact(player: Node3D) -> void:
	pass

func _show_interaction_prompt() -> void:
	if player_ref and player_ref.has_node("UI"):
		var ui: GameUI = player_ref.get_node("UI")
		ui.hud.show_interaction_prompt(interaction_action, interaction_prompt)

func _hide_interaction_prompt() -> void:
	if player_ref and player_ref.has_node("UI"):
		var ui: GameUI = player_ref.get_node("UI")
		ui.hud.hide_interaction_prompt()

## Check if player is within interaction distance
func is_within_interaction_distance() -> bool:
	if not is_player_nearby or not player_ref:
		return false
	
	return global_position.distance_to(player_ref.global_position) <= interaction_distance
