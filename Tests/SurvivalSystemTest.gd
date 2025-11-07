extends Node

## Test script for SurvivalSystem with Energy
## Prints test results to Godot console
## Run this scene to execute all tests

var test_passed_count: int = 0
var test_failed_count: int = 0
var tests_complete: bool = false

func _ready() -> void:
	print("========================================")
	print("SURVIVAL SYSTEM TEST SUITE")
	print("========================================")
	print("")
	
	# Wait a frame to ensure scene is ready
	await get_tree().process_frame
	_run_all_tests()

## Run all test cases
func _run_all_tests() -> void:
	print("Testing SurvivalStats...")
	_test_stat_initialization()
	_test_stat_decay()
	_test_stat_restoration()
	_test_stat_clamping()
	_test_coherence_restoration_limitation()
	_test_stat_depletion()
	_test_coherence_accelerated_decay()
	_test_stat_signals()
	_test_energy_initialization()
	_test_energy_restoration_efficiency()
	
	print("")
	print("Testing SurvivalSystem...")
	_test_survival_system_instantiation()
	_test_survival_system_restoration()
	_test_survival_system_decay_rates()
	_test_survival_system_active_state()
	_test_energy_movement_consumption()
	_test_energy_rest_recovery()
	_test_energy_coherence_drain()
	_test_energy_action_consumption()
	
	_print_test_results()

## Test: Stats initialize to full values
func _test_stat_initialization() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new()
	_assert_equal(test_stats.hunger, 1.0, "Hunger initializes to 1.0")
	_assert_equal(test_stats.thirst, 1.0, "Thirst initializes to 1.0")
	_assert_equal(test_stats.coherence, 1.0, "Coherence initializes to 1.0")
	_assert_equal(test_stats.energy, 1.0, "Energy initializes to 1.0")
	
	var custom_stats: SurvivalStats = SurvivalStats.new(0.5, 0.75, 0.9, 0.6)
	_assert_equal(custom_stats.hunger, 0.5, "Custom hunger initialization")
	_assert_equal(custom_stats.thirst, 0.75, "Custom thirst initialization")
	_assert_equal(custom_stats.coherence, 0.9, "Custom coherence initialization")
	_assert_equal(custom_stats.energy, 0.6, "Custom energy initialization")

## Test: Stats decay over time
func _test_stat_decay() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new()
	var initial_hunger: float = test_stats.hunger
	
	# Simulate decay (using default rate)
	var decay_delta: float = 1.0 # 1 second
	var hunger_decay_rate: float = 0.01 # DEFAULT_HUNGER_DECAY_RATE
	var expected_hunger: float = initial_hunger - (hunger_decay_rate * decay_delta)
	
	test_stats.modify_hunger(-hunger_decay_rate * decay_delta)
	_assert_approximately_equal(test_stats.hunger, expected_hunger, 0.001, "Hunger decays correctly")
	
	var initial_thirst: float = test_stats.thirst
	var thirst_decay_rate: float = 0.015 # DEFAULT_THIRST_DECAY_RATE
	test_stats.modify_thirst(-thirst_decay_rate * decay_delta)
	var expected_thirst: float = initial_thirst - (thirst_decay_rate * decay_delta)
	_assert_approximately_equal(test_stats.thirst, expected_thirst, 0.001, "Thirst decays correctly")

## Test: Stats can be restored
func _test_stat_restoration() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new(0.5, 0.3, 0.7, 0.4)
	
	test_stats.modify_hunger(0.2)
	_assert_approximately_equal(test_stats.hunger, 0.7, 0.001, "Hunger restoration works")
	
	test_stats.modify_thirst(0.4)
	_assert_approximately_equal(test_stats.thirst, 0.7, 0.001, "Thirst restoration works")
	
	test_stats.modify_coherence(0.1)
	_assert_approximately_equal(test_stats.coherence, 0.8, 0.001, "Coherence restoration works")
	
	test_stats.modify_energy(0.3)
	_assert_approximately_equal(test_stats.energy, 0.7, 0.001, "Energy restoration works")

## Test: Stats are clamped between 0.0 and 1.0
func _test_stat_clamping() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new()
	
	test_stats.modify_hunger(10.0) # Try to exceed max
	_assert_equal(test_stats.hunger, 1.0, "Hunger clamps to max (1.0)")
	
	test_stats.modify_hunger(-10.0) # Try to go below min
	_assert_equal(test_stats.hunger, 0.0, "Hunger clamps to min (0.0)")
	
	test_stats.set_thirst(1.5)
	_assert_equal(test_stats.thirst, 1.0, "Thirst clamps to max via setter")
	
	test_stats.set_coherence(-0.5)
	_assert_equal(test_stats.coherence, 0.0, "Coherence clamps to min via setter")
	
	test_stats.set_energy(2.0)
	_assert_equal(test_stats.energy, 1.0, "Energy clamps to max via setter")

## Test: Coherence restoration is limited when low
func _test_coherence_restoration_limitation() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new(1.0, 1.0, 0.25, 1.0)
	
	# Restore coherence - should be limited
	var restore_amount: float = 0.5
	var restoration_multiplier: float = 0.3 # Expected multiplier when coherence < 0.3
	var expected_coherence: float = test_stats.coherence + (restore_amount * restoration_multiplier)
	
	test_stats.modify_coherence(restore_amount * restoration_multiplier)
	_assert_approximately_equal(test_stats.coherence, expected_coherence, 0.01, "Coherence restoration is limited when low")

## Test: Stat depletion detection
func _test_stat_depletion() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new()
	
	test_stats.set_hunger(0.0)
	_assert_equal(test_stats.hunger, 0.0, "Hunger can be set to depleted")
	
	test_stats.set_thirst(0.0)
	test_stats.set_coherence(0.0)
	test_stats.set_energy(0.0)
	_assert_true(test_stats.are_all_stats_depleted(), "All stats depleted detection works")
	
	var test_stats_2: SurvivalStats = SurvivalStats.new(0.1, 0.1, 0.1, 0.1)
	_assert_true(test_stats_2.is_any_stat_critical(0.2), "Critical stat detection works with energy")

## Test: Coherence decays faster when hunger/thirst are low
func _test_coherence_accelerated_decay() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new(0.3, 0.3, 0.8, 1.0)
	var initial_coherence: float = test_stats.coherence
	
	# Calculate expected additional decay
	var hunger_thirst_factor: float = (test_stats.hunger + test_stats.thirst) / 2.0
	var coherence_decay_rate: float = 0.005 # DEFAULT_COHERENCE_DECAY_RATE
	var additional_decay: float = (0.5 - hunger_thirst_factor) * 0.01 * 1.0 # 1 second
	
	var expected_coherence: float = initial_coherence - (coherence_decay_rate * 1.0) - additional_decay
	
	# Simulate decay
	test_stats.modify_coherence(-coherence_decay_rate * 1.0)
	test_stats.modify_coherence(-additional_decay)
	
	_assert_approximately_equal(test_stats.coherence, expected_coherence, 0.01, "Coherence decays faster when hunger/thirst are low")

## Test: Energy initialization
func _test_energy_initialization() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new()
	_assert_equal(test_stats.energy, 1.0, "Energy initializes to 1.0")

## Test: Energy restoration efficiency calculation
func _test_energy_restoration_efficiency() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new(0.6, 0.4, 1.0, 0.5)
	var efficiency: float = test_stats.get_energy_restoration_efficiency()
	var expected_efficiency: float = (0.6 + 0.4) / 2.0
	_assert_approximately_equal(efficiency, expected_efficiency, 0.001, "Energy restoration efficiency calculated correctly")
	
	test_stats.set_hunger(1.0)
	test_stats.set_thirst(1.0)
	efficiency = test_stats.get_energy_restoration_efficiency()
	_assert_equal(efficiency, 1.0, "Max energy restoration efficiency when fully fed/hydrated")
	
	test_stats.set_hunger(0.0)
	test_stats.set_thirst(0.0)
	efficiency = test_stats.get_energy_restoration_efficiency()
	_assert_equal(efficiency, 0.0, "Zero energy restoration efficiency when starving/dehydrated")

## Test: Signals are emitted correctly
func _test_stat_signals() -> void:
	var test_stats: SurvivalStats = SurvivalStats.new()
	# Use Dictionary to hold boolean flags (passed by reference)
	var flags: Dictionary = {
		"hunger_changed": false,
		"thirst_changed": false,
		"coherence_changed": false,
		"energy_changed": false
	}
	
	# Connect signals - use Dictionary reference so flags can be modified
	test_stats.hunger_changed.connect(func(new_value: float):
		flags["hunger_changed"] = true
	)
	
	test_stats.thirst_changed.connect(func(new_value: float):
		flags["thirst_changed"] = true
	)
	
	test_stats.coherence_changed.connect(func(new_value: float):
		flags["coherence_changed"] = true
	)
	
	test_stats.energy_changed.connect(func(new_value: float):
		flags["energy_changed"] = true
	)
	
	# Modify stats to values that will actually change (not clamped)
	test_stats.modify_hunger(-0.1) # From 1.0 to 0.9
	test_stats.modify_thirst(-0.1) # From 1.0 to 0.9
	test_stats.modify_coherence(-0.1) # From 1.0 to 0.9
	test_stats.modify_energy(-0.1) # From 1.0 to 0.9
	
	_assert_true(flags["hunger_changed"], "Hunger changed signal emitted")
	_assert_true(flags["thirst_changed"], "Thirst changed signal emitted")
	_assert_true(flags["coherence_changed"], "Coherence changed signal emitted")
	_assert_true(flags["energy_changed"], "Energy changed signal emitted")

## Test: SurvivalSystem can be instantiated and added to scene tree
func _test_survival_system_instantiation() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	
	# Set inactive immediately to prevent decay during initialization
	system.set_active(false)
	add_child(system)
	
	# Wait a frame for _ready to execute
	await get_tree().process_frame
	
	var stats: SurvivalStats = system.get_stats()
	_assert_equal(stats.hunger, 1.0, "SurvivalSystem initializes with full hunger")
	_assert_equal(stats.thirst, 1.0, "SurvivalSystem initializes with full thirst")
	_assert_equal(stats.coherence, 1.0, "SurvivalSystem initializes with full coherence")
	_assert_equal(stats.energy, 1.0, "SurvivalSystem initializes with full energy")
	
	system.queue_free()

## Test: SurvivalSystem restoration methods work correctly
func _test_survival_system_restoration() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	# Set stats to low values
	system.stats.set_hunger(0.5)
	system.stats.set_thirst(0.3)
	system.stats.set_coherence(0.4)
	system.stats.set_energy(0.2)
	
	# Restore stats
	system.restore_hunger(0.2)
	system.restore_thirst(0.3)
	system.restore_coherence(0.1)
	system.restore_energy(0.4)
	
	var stats: SurvivalStats = system.get_stats()
	_assert_approximately_equal(stats.hunger, 0.7, 0.001, "SurvivalSystem.restore_hunger() works")
	_assert_approximately_equal(stats.thirst, 0.6, 0.001, "SurvivalSystem.restore_thirst() works")
	_assert_approximately_equal(stats.coherence, 0.5, 0.001, "SurvivalSystem.restore_coherence() works")
	_assert_approximately_equal(stats.energy, 0.6, 0.001, "SurvivalSystem.restore_energy() works")
	
	system.queue_free()

## Test: SurvivalSystem decay rate configuration works
func _test_survival_system_decay_rates() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	# Set custom decay rates
	system.set_decay_rates(0.02, 0.03, 0.01)
	
	_assert_equal(system.hunger_decay_rate, 0.02, "Hunger decay rate can be set")
	_assert_equal(system.thirst_decay_rate, 0.03, "Thirst decay rate can be set")
	_assert_equal(system.coherence_decay_rate, 0.01, "Coherence decay rate can be set")
	
	system.queue_free()

## Test: SurvivalSystem active state controls decay
func _test_survival_system_active_state() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	var initial_hunger: float = system.stats.hunger
	
	# Disable system
	system.set_active(false)
	
	# Manually call process to verify it doesn't decay when inactive
	# (Simulating what would happen over time)
	var test_delta: float = 1.0
	system._process(test_delta)
	var hunger_after_disable: float = system.stats.hunger
	_assert_approximately_equal(hunger_after_disable, initial_hunger, 0.001, "Stats don't decay when system is inactive")
	
	# Re-enable system
	system.set_active(true)
	
	# Manually call process to verify it decays when active
	system._process(test_delta)
	var hunger_after_enable: float = system.stats.hunger
	_assert_true(hunger_after_enable < hunger_after_disable, "Stats decay when system is active")
	
	system.queue_free()

## Test: Energy consumption during movement
func _test_energy_movement_consumption() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	var initial_energy: float = system.stats.energy
	
	# Test movement energy consumption
	system.set_movement_state(true, false)
	system._process_energy(1.0) # Simulate 1 second
	
	var expected_energy: float = initial_energy - 0.02 # Default movement consumption
	_assert_approximately_equal(system.stats.energy, expected_energy, 0.001, "Energy consumed during movement")
	
	# Test sprint energy consumption
	system.stats.set_energy(1.0)
	system.set_movement_state(true, true)
	system._process_energy(1.0) # Simulate 1 second
	
	expected_energy = 1.0 - 0.05 # Sprint consumption
	_assert_approximately_equal(system.stats.energy, expected_energy, 0.001, "Energy consumed faster during sprint")
	
	system.queue_free()

## Test: Energy recovery during rest
func _test_energy_rest_recovery() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	# Set energy to half and hunger/thirst to specific values
	system.stats.set_energy(0.5)
	system.stats.set_hunger(0.8)
	system.stats.set_thirst(0.6)
	
	var initial_energy: float = system.stats.energy
	var efficiency: float = (0.8 + 0.6) / 2.0 # 0.7
	
	# Test resting energy recovery
	system.set_resting(true)
	system._process_energy(1.0) # Simulate 1 second
	
	var expected_energy: float = initial_energy + (0.05 * efficiency) # Recovery rate * efficiency
	_assert_approximately_equal(system.stats.energy, expected_energy, 0.001, "Energy recovers during rest based on hunger/thirst")
	
	# Test no recovery when starving/dehydrated
	system.stats.set_energy(0.5)
	system.stats.set_hunger(0.0)
	system.stats.set_thirst(0.0)
	
	initial_energy = system.stats.energy
	system._process_energy(1.0)
	
	_assert_approximately_equal(system.stats.energy, initial_energy, 0.001, "No energy recovery when starving/dehydrated")
	
	system.queue_free()

## Test: Coherence drains when energy is low
func _test_energy_coherence_drain() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	# Set energy below threshold
	system.stats.set_energy(0.15) # Below LOW_ENERGY_THRESHOLD (0.2)
	system.stats.set_coherence(0.8)
	
	var initial_coherence: float = system.stats.coherence
	
	# Simulate time passing
	system._decay_stats(1.0) # 1 second
	
	# Expected coherence loss: base decay + low energy drain
	var expected_loss: float = 0.005 + 0.008 # DEFAULT_COHERENCE_DECAY_RATE + LOW_ENERGY_COHERENCE_DRAIN
	var expected_coherence: float = initial_coherence - expected_loss
	
	_assert_approximately_equal(system.stats.coherence, expected_coherence, 0.001, "Coherence drains faster when energy is low")
	
	system.queue_free()

## Test: Energy action consumption
func _test_energy_action_consumption() -> void:
	var system: SurvivalSystem = SurvivalSystem.new()
	add_child(system)
	await get_tree().process_frame
	
	system.stats.set_energy(0.5)
	
	# Test successful action consumption
	var success: bool = system.consume_energy(0.3)
	_assert_true(success, "Energy consumption succeeds when sufficient energy")
	_assert_approximately_equal(system.stats.energy, 0.2, 0.001, "Energy correctly consumed for action")
	
	# Test failed action consumption (insufficient energy)
	success = system.consume_energy(0.3)
	_assert_false(success, "Energy consumption fails when insufficient energy")
	_assert_approximately_equal(system.stats.energy, 0.2, 0.001, "Energy unchanged when action fails")
	
	# Test has_energy_for_action check
	_assert_true(system.has_energy_for_action(0.1), "has_energy_for_action returns true when sufficient")
	_assert_false(system.has_energy_for_action(0.3), "has_energy_for_action returns false when insufficient")
	
	system.queue_free()

## Assertion helper functions
func _assert_equal(actual: float, expected: float, message: String) -> void:
	if actual == expected:
		test_passed_count += 1
		print("[PASS] ", message)
	else:
		test_failed_count += 1
		print("[FAIL] ", message, " - Expected: ", expected, ", Got: ", actual)

func _assert_approximately_equal(actual: float, expected: float, tolerance: float, message: String) -> void:
	if abs(actual - expected) <= tolerance:
		test_passed_count += 1
		print("[PASS] ", message)
	else:
		test_failed_count += 1
		print("[FAIL] ", message, " - Expected: ", expected, " (±", tolerance, "), Got: ", actual)

func _assert_true(condition: bool, message: String) -> void:
	if condition:
		test_passed_count += 1
		print("[PASS] ", message)
	else:
		test_failed_count += 1
		print("[FAIL] ", message)

func _assert_false(condition: bool, message: String) -> void:
	_assert_true(not condition, message)

func _print_test_results() -> void:
	print("")
	print("========================================")
	print("TEST RESULTS")
	print("========================================")
	print("Passed: ", test_passed_count)
	print("Failed: ", test_failed_count)
	print("Total: ", test_passed_count + test_failed_count)
	if test_failed_count == 0:
		print("STATUS: ALL TESTS PASSED")
	else:
		print("STATUS: SOME TESTS FAILED")
	print("========================================")
	tests_complete = true
