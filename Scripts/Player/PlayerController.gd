extends CharacterBody3D

# Movement settings
@export var walk_speed: float = 4.0
@export var crouch_speed: float = 1.5
@export var acceleration: float = 10.0
@export var friction: float = 15.0
@export var gravity: float = 9.8

# Mouse and controller sensitivity
@export var mouse_sensitivity: float = 0.003
@export var controller_sensitivity: float = 3.0
@export var look_up_max: float = 70.0  # degrees
@export var look_down_max: float = 80.0  # degrees
@export var sitting_look_horizontal_max: float = 80.0  # degrees

# Posture settings
@export var posture_hold_time: float = 0.5  # Time to hold for sitting
@export var camera_height_tween_duration: float = 1.5  # Duration for camera height transitions

# Posture enum
enum Posture {SITTING, CROUCHING, STANDING}
var current_posture: Posture = Posture.STANDING

# Camera references
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

# State tracking
var is_in_water: bool = false
var camera_x_rotation: float = 0.0
var sitting_y_rotation: float = 0.0  # Track horizontal look when sitting
var current_animation: String = "idle"
var posture_down_timer: float = 0.0
var is_holding_posture_down: bool = false
var toggle_posture_timer: float = 0.0
var is_holding_toggle_posture: bool = false
var camera_height_tween: Tween = null

func _ready():
	# Capture the mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Handle mouse movement
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		handle_mouse_look(event.relative)
	
	# Handle ESC to release mouse (useful for testing)
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Handle controller look
	handle_controller_look(delta)
	
	# Handle input
	handle_action_inputs()
	handle_posture_inputs(delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle movement
	handle_movement(delta)
	
	# Move the character
	move_and_slide()

func handle_mouse_look(relative_motion: Vector2):
	if current_posture == Posture.SITTING:
		# When sitting, only look around (no body rotation)
		# Vertical look (X-axis rotation)
		camera_x_rotation -= relative_motion.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, 
			deg_to_rad(-look_down_max), 
			deg_to_rad(look_up_max))
		camera_pivot.rotation.x = camera_x_rotation
		
		# Horizontal look (limited to ±80 degrees from forward)
		sitting_y_rotation -= relative_motion.x * mouse_sensitivity
		sitting_y_rotation = clamp(sitting_y_rotation, 
			deg_to_rad(-sitting_look_horizontal_max), 
			deg_to_rad(sitting_look_horizontal_max))
		camera_pivot.rotation.y = sitting_y_rotation
	else:
		# When standing or crouching, rotate body horizontally and camera vertically
		# Vertical look (X-axis rotation on camera pivot)
		camera_x_rotation -= relative_motion.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, 
			deg_to_rad(-look_down_max), 
			deg_to_rad(look_up_max))
		camera_pivot.rotation.x = camera_x_rotation
		
		# Horizontal look (Y-axis rotation on character body)
		rotate_y(-relative_motion.x * mouse_sensitivity)
		camera_pivot.rotation.y = 0  # Keep camera pivot straight

func handle_controller_look(delta):
	# Get right stick input for looking
	var look_input = Vector2(
		Input.get_axis("look_left", "look_right"),
		Input.get_axis("look_up", "look_down")
	)
	
	# Apply deadzone
	if look_input.length() < 0.2:
		return
	
	# Apply sensitivity and delta (inverted for natural feel)
	var look_motion = look_input * controller_sensitivity * delta
	
	if current_posture == Posture.SITTING:
		# Vertical look (inverted: up on stick = look up)
		camera_x_rotation -= look_motion.y
		camera_x_rotation = clamp(camera_x_rotation, 
			deg_to_rad(-look_down_max), 
			deg_to_rad(look_up_max))
		camera_pivot.rotation.x = camera_x_rotation
		
		# Horizontal look (inverted: right on stick = look right)
		sitting_y_rotation -= look_motion.x
		sitting_y_rotation = clamp(sitting_y_rotation, 
			deg_to_rad(-sitting_look_horizontal_max), 
			deg_to_rad(sitting_look_horizontal_max))
		camera_pivot.rotation.y = sitting_y_rotation
	else:
		# Vertical look (inverted: up on stick = look up)
		camera_x_rotation -= look_motion.y
		camera_x_rotation = clamp(camera_x_rotation, 
			deg_to_rad(-look_down_max), 
			deg_to_rad(look_up_max))
		camera_pivot.rotation.x = camera_x_rotation
		
		# Horizontal look (inverted: right on stick = turn right)
		rotate_y(-look_motion.x)
		camera_pivot.rotation.y = 0

func handle_action_inputs():
	# Inventory
	if Input.is_action_just_pressed("inventory"):
		print("Inventory opened")
	
	# Interact
	if Input.is_action_just_pressed("interact"):
		print("Interact")
	
	# Search
	if Input.is_action_just_pressed("search"):
		print("Search")
	
	# Ping
	if Input.is_action_just_pressed("ping"):
		print("Ping")
	
	# Rest
	if Input.is_action_just_pressed("rest"):
		print("Rest")

func handle_posture_inputs(delta):
	# Handle keyboard posture up (always goes to standing)
	if Input.is_action_just_pressed("posture_up"):
		if current_posture != Posture.STANDING:
			change_posture(Posture.STANDING)
	
	# Handle keyboard posture down (tap for crouch, hold for sit)
	if Input.is_action_just_pressed("posture_down"):
		if current_posture == Posture.STANDING:
			is_holding_posture_down = true
			posture_down_timer = 0.0
	
	if Input.is_action_pressed("posture_down") and is_holding_posture_down:
		if current_posture == Posture.STANDING:
			posture_down_timer += delta
			if posture_down_timer >= posture_hold_time:
				# Held long enough, go to sitting
				change_posture(Posture.SITTING)
				is_holding_posture_down = false
	
	if Input.is_action_just_released("posture_down") and is_holding_posture_down:
		if current_posture == Posture.STANDING and posture_down_timer < posture_hold_time:
			# Released before hold time, just crouch
			change_posture(Posture.CROUCHING)
		is_holding_posture_down = false
		posture_down_timer = 0.0
	
	# Handle controller toggle_posture
	if Input.is_action_just_pressed("toggle_posture"):
		is_holding_toggle_posture = true
		toggle_posture_timer = 0.0
		
		# If sitting, immediately go to standing
		if current_posture == Posture.SITTING:
			change_posture(Posture.STANDING)
			is_holding_toggle_posture = false
	
	if Input.is_action_pressed("toggle_posture") and is_holding_toggle_posture:
		toggle_posture_timer += delta
		if toggle_posture_timer >= posture_hold_time:
			# Held long enough, go to sitting (from either standing or crouching)
			if current_posture != Posture.SITTING:
				change_posture(Posture.SITTING)
				is_holding_toggle_posture = false
	
	if Input.is_action_just_released("toggle_posture") and is_holding_toggle_posture:
		if toggle_posture_timer < posture_hold_time:
			# Released before hold time, toggle between standing and crouching
			if current_posture == Posture.STANDING:
				change_posture(Posture.CROUCHING)
			elif current_posture == Posture.CROUCHING:
				change_posture(Posture.STANDING)
		is_holding_toggle_posture = false
		toggle_posture_timer = 0.0

func change_posture(new_posture: Posture):
	var old_posture = current_posture
	
	# Don't transition if already in that posture
	if old_posture == new_posture:
		return
	
	current_posture = new_posture
	
	# Reset sitting rotation when leaving sitting posture
	if old_posture == Posture.SITTING:
		# Transfer the sitting rotation to the body rotation
		rotate_y(sitting_y_rotation)
		sitting_y_rotation = 0.0
		camera_pivot.rotation.y = 0.0
	
	# Play transition animation based on posture change
	match [old_posture, new_posture]:
		[Posture.STANDING, Posture.SITTING]:
			play_animation("standing_to_sitting")
		[Posture.SITTING, Posture.STANDING]:
			play_animation("sitting_to_standing")
		[Posture.STANDING, Posture.CROUCHING]:
			play_animation("standing_to_crouching")
		[Posture.CROUCHING, Posture.STANDING]:
			play_animation("crouching_to_standing")
		[Posture.CROUCHING, Posture.SITTING]:
			# Crouch to sit: transition through standing
			play_animation("crouching_to_standing")
			# You might want to queue sitting animation after
		[Posture.SITTING, Posture.CROUCHING]:
			# Sit to crouch: transition through standing
			play_animation("sitting_to_standing")
			# You might want to queue crouching animation after
	
	# Tween camera height based on posture
	var target_height: float
	match new_posture:
		Posture.SITTING:
			target_height = 1.0
		Posture.CROUCHING:
			target_height = 1.2
		Posture.STANDING:
			target_height = 1.67
	
	# Cancel existing tween if any
	if camera_height_tween:
		camera_height_tween.kill()
	
	# Create new tween for smooth camera height transition
	camera_height_tween = create_tween()
	camera_height_tween.tween_property(camera_pivot, "position:y", target_height, camera_height_tween_duration)
	camera_height_tween.set_trans(Tween.TRANS_SINE)
	camera_height_tween.set_ease(Tween.EASE_IN_OUT)
	
	print("Posture changed to: ", Posture.keys()[new_posture])

func handle_movement(delta):
	# Can't move when sitting
	if current_posture == Posture.SITTING:
		apply_friction(delta)
		if velocity.length() < 0.1:
			play_animation("idle")
		return
	
	# Get input direction
	var input_dir = Vector2.ZERO
	
	if is_in_water:
		# In water, only forward movement
		if Input.is_action_pressed("move_forward"):
			input_dir.y = 1.0
	else:
		# Normal movement
		input_dir.x = Input.get_axis("strafe_left", "strafe_right")
		input_dir.y = Input.get_axis("move_back", "move_forward")
	
	# Normalize input direction
	if input_dir.length() > 1.0:
		input_dir = input_dir.normalized()
	
	# Calculate movement direction relative to character's rotation
	var direction = transform.basis * Vector3(input_dir.x, 0, -input_dir.y)
	direction.y = 0
	direction = direction.normalized()
	
	# Determine speed based on posture
	var current_speed = walk_speed
	if current_posture == Posture.CROUCHING:
		current_speed = crouch_speed
	
	# Apply movement
	if direction.length() > 0:
		# Accelerate
		velocity.x = move_toward(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, acceleration * delta)
		
		# Determine animation based on movement direction and posture
		var forward_dot = direction.dot(-global_transform.basis.z)
		if current_posture == Posture.STANDING:
			if forward_dot > 0.5:
				play_animation("standing_walk_forward")
			elif forward_dot < -0.5:
				play_animation("standing_walk_backward")
			else:
				play_animation("standing_walk_forward")  # Strafing uses forward animation
		elif current_posture == Posture.CROUCHING:
			if forward_dot > 0.5:
				play_animation("crouching_walk_forward")
			elif forward_dot < -0.5:
				play_animation("crouching_walk_backward")
			else:
				play_animation("crouching_walk_forward")  # Strafing uses forward animation
	else:
		# Apply friction and play idle
		apply_friction(delta)
		if velocity.length() < 0.1:
			play_animation("idle")

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	velocity.z = move_toward(velocity.z, 0, friction * delta)

func play_animation(animation_name: String):
	if current_animation != animation_name:
		current_animation = animation_name
		print("Playing animation: ", animation_name)
		# When you add AnimationPlayer, call it here:
		# $AnimationPlayer.play(animation_name)

# Helper function to set water state (call from water areas)
func set_in_water(in_water: bool):
	is_in_water = in_water
	if in_water:
		print("Entered water")
	else:
		print("Exited water")
