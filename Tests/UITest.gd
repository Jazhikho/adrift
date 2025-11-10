extends Node3D

## Comprehensive test script for UI system
## Add this to your test scene root node

var ui: GameUI
var survival_system: SurvivalSystem
var test_timer: Timer
var current_test: int = 0
var player_rotation: float = 0.0

# Test inventory items
var test_items: Array[InventoryItem] = []

func _ready() -> void:
	print("========================================")
	print("UI SYSTEM TEST")
	print("========================================")
	print("Controls:")
	print("- Press 'I' to toggle inventory")
	print("- Press 'ESC' to toggle pause menu")
	print("- Press '1-9' to run specific tests")
	print("- Press 'SPACE' to simulate interaction")
	print("- Use arrow keys to rotate compass")
	print("========================================")
	
	# Create UI
	_setup_ui()
	
	# Create survival system
	_setup_survival_system()
	
	# Create test timer
	test_timer = Timer.new()
	test_timer.wait_time = 2.0
	test_timer.timeout.connect(_run_next_test)
	add_child(test_timer)
	
	# Create test items
	_create_test_items()
	
	# Start automated tests
	await get_tree().create_timer(1.0).timeout
	print("\nStarting automated UI tests...")
	test_timer.start()

func _setup_ui() -> void:
	# Load and instantiate UI
	var ui_scene: PackedScene = preload("res://Scenes/UI/UI.tscn")
	ui = ui_scene.instantiate()
	add_child(ui)

func _setup_survival_system() -> void:
	survival_system = SurvivalSystem.new()
	add_child(survival_system)
	
	# Initialize UI with survival system
	ui.initialize(survival_system)
	
	# Set some initial stat values for testing
	survival_system.stats.set_hunger(0.75)
	survival_system.stats.set_thirst(0.5)
	survival_system.stats.set_energy(0.3)
	survival_system.stats.set_coherence(0.9)

func _create_test_items() -> void:
	# Create test food item
	var food_item: InventoryItem = InventoryItem.new()
	food_item.name = "Apple"
	food_item.description = "A fresh apple. Restores hunger."
	food_item.item_type = InventoryItem.ItemType.FOOD
	test_items.append(food_item)
	
	# Create test water item
	var water_item: InventoryItem = InventoryItem.new()
	water_item.name = "Water Bottle"
	water_item.description = "Clean drinking water. Restores thirst."
	water_item.item_type = InventoryItem.ItemType.WATER
	water_item.stack_size = 3
	test_items.append(water_item)
	
	# Create test tool item
	var tool_item: InventoryItem = InventoryItem.new()
	tool_item.name = "Flashlight"
	tool_item.description = "A battery-powered flashlight."
	tool_item.item_type = InventoryItem.ItemType.TOOL
	test_items.append(tool_item)
	
	# Create test key item
	var key_item: InventoryItem = InventoryItem.new()
	key_item.name = "Mysterious Key"
	key_item.description = "An old key. What does it open?"
	key_item.item_type = InventoryItem.ItemType.KEY
	test_items.append(key_item)

func _input(event: InputEvent) -> void:
	# Manual test controls
	if event.is_action_pressed("ui_select"):  # Space
		_test_interaction_prompt()
	
	# Compass rotation with arrow keys
	if event.is_action_pressed("ui_left"):
		player_rotation -= 15.0
		ui.hud.update_player_rotation(wrapf(player_rotation, 0.0, 360.0))
	elif event.is_action_pressed("ui_right"):
		player_rotation += 15.0
		ui.hud.update_player_rotation(wrapf(player_rotation, 0.0, 360.0))
	
	# Number keys for specific tests
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				_test_stat_display()
			KEY_2:
				_test_subtitles()
			KEY_3:
				_test_inventory()
			KEY_4:
				_test_pause_menu()
			KEY_5:
				_test_settings_menu()
			KEY_6:
				_test_transitions()
			KEY_7:
				_test_compass()
			KEY_8:
				_test_interaction_prompt()
			KEY_9:
				_test_critical_stats()

func _run_next_test() -> void:
	match current_test:
		0:
			_test_stat_display()
		1:
			_test_subtitles()
		2:
			_test_inventory()
		3:
			_test_compass()
		4:
			_test_interaction_prompt()
		5:
			_test_critical_stats()
		6:
			_test_energy_movement()
		7:
			_test_energy_restoration()
		_:
			print("\nAutomated tests complete!")
			test_timer.stop()
			return
	
	current_test += 1

func _test_stat_display() -> void:
	print("\n[TEST] Stat Display")
	print("- Setting various stat values...")
	
	survival_system.stats.set_hunger(0.8)
	survival_system.stats.set_thirst(0.4)
	survival_system.stats.set_energy(0.15)
	
	await get_tree().create_timer(0.5).timeout
	print("✓ Stats should show: Hunger=80% (green), Thirst=40% (yellow), Energy=15% (red)")

func _test_subtitles() -> void:
	print("\n[TEST] Subtitles")
	print("- Showing subtitle...")
	
	ui.show_subtitle("This is a test subtitle that should appear for 3 seconds.", 3.0)
	
	await get_tree().create_timer(1.0).timeout
	ui.show_subtitle("This is a shorter subtitle.", 1.5)
	
	print("✓ Subtitles displayed")

func _test_inventory() -> void:
	print("\n[TEST] Inventory System")
	print("- Opening inventory with test items...")
	
	ui.inventory_menu.update_inventory(test_items)
	ui.toggle_inventory()
	
	await get_tree().create_timer(2.0).timeout
	ui.toggle_inventory()
	
	print("✓ Inventory opened and closed")

func _test_pause_menu() -> void:
	print("\n[TEST] Pause Menu")
	print("- Opening pause menu...")
	
	ui.toggle_pause()
	
	await get_tree().create_timer(1.5).timeout
	ui.pause_menu.resume()
	
	print("✓ Pause menu tested (game was paused)")

func _test_settings_menu() -> void:
	print("\n[TEST] Settings Menu")
	print("- Opening settings...")
	
	ui.open_settings()
	
	await get_tree().create_timer(2.0).timeout
	ui.settings_menu.close()
	
	print("✓ Settings menu tested")

func _test_transitions() -> void:
	print("\n[TEST] Transitions")
	print("- Testing fade effects...")
	
	await ui.transition_layer.fade_out(0.5)
	await get_tree().create_timer(0.5).timeout
	await ui.transition_layer.fade_in(0.5)
	
	await get_tree().create_timer(0.5).timeout
	ui.transition_layer.flash(Color.WHITE, 0.3)
	
	print("✓ Transition effects tested")

func _test_compass() -> void:
	print("\n[TEST] Compass")
	print("- Rotating compass through cardinal directions...")
	
	var directions: Array[float] = [0.0, 90.0, 180.0, 270.0, 45.0, 135.0, 225.0, 315.0]
	
	for dir in directions:
		ui.hud.update_player_rotation(dir)
		await get_tree().create_timer(0.3).timeout
	
	print("✓ Compass rotation tested")

func _test_interaction_prompt() -> void:
	print("\n[TEST] Interaction Prompt")
	print("- Showing interaction prompt...")
	
	ui.hud.show_interaction_prompt("interact", "Open Door")
	
	await get_tree().create_timer(1.5).timeout
	
	ui.hud.show_interaction_prompt("interact", "Pick Up Item")
	
	await get_tree().create_timer(1.5).timeout
	
	ui.hud.hide_interaction_prompt()
	
	print("✓ Interaction prompts tested")

func _test_critical_stats() -> void:
	print("\n[TEST] Critical Stats Warning")
	print("- Setting stats to critical levels...")
	
	survival_system.stats.set_hunger(0.15)
	survival_system.stats.set_thirst(0.1)
	survival_system.stats.set_energy(0.05)
	
	ui.show_subtitle("WARNING: Critical survival stats!", 3.0)
	
	await get_tree().create_timer(2.0).timeout
	print("✓ All stat bars should be red")

func _test_energy_movement() -> void:
	print("\n[TEST] Energy Movement System")
	print("- Simulating movement...")
	
	survival_system.set_movement_state(true, false)
	ui.show_subtitle("Walking...", 2.0)
	
	await get_tree().create_timer(2.0).timeout
	
	survival_system.set_movement_state(true, true)
	ui.show_subtitle("Sprinting!", 2.0)
	
	await get_tree().create_timer(2.0).timeout
	
	survival_system.set_movement_state(false)
	print("✓ Energy should have decreased from movement")

func _test_energy_restoration() -> void:
	print("\n[TEST] Energy Restoration")
	print("- Testing rest mechanic...")
	
	survival_system.set_resting(true)
	ui.show_subtitle("Resting... Energy recovering based on hunger/thirst", 3.0)
	
	await get_tree().create_timer(3.0).timeout
	
	survival_system.set_resting(false)
	print("✓ Energy should have increased while resting")

func _on_item_used(item: InventoryItem) -> void:
	print("Item used: ", item.name)
	ui.show_subtitle("Used " + item.name, 2.0)
	
	# Apply item effects based on type
	match item.item_type:
		InventoryItem.ItemType.FOOD:
			survival_system.restore_hunger(0.3)
		InventoryItem.ItemType.WATER:
			survival_system.restore_thirst(0.4)
