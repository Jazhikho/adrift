extends Control
class_name InventoryMenu

## Inventory menu controller

signal closed()
signal item_used(item: InventoryItem)
signal item_selected(item: InventoryItem)

@onready var item_grid: GridContainer = $InventoryPanel/VBoxContainer/ScrollContainer/ItemGrid
@onready var item_info_label: RichTextLabel = $InventoryPanel/VBoxContainer/ItemInfoPanel/ItemInfoLabel
@onready var use_button: Button = $InventoryPanel/VBoxContainer/ActionContainer/UseButton
@onready var close_button: Button = $InventoryPanel/VBoxContainer/HeaderContainer/CloseButton

const INVENTORY_SLOT_SCENE: PackedScene = preload("res://Scenes/UI/InventorySlot.tscn")
const GRID_SIZE: int = 24

var selected_slot: InventorySlot
var inventory_slots: Array[InventorySlot] = []

func _ready() -> void:
	close_button.pressed.connect(close)
	use_button.pressed.connect(_on_use_pressed)
	use_button.disabled = true
	
	# Create inventory grid
	_create_inventory_grid()

func _create_inventory_grid() -> void:
	for i in GRID_SIZE:
		var slot: InventorySlot = INVENTORY_SLOT_SCENE.instantiate()
		slot.slot_index = i
		slot.selected.connect(_on_slot_selected)
		item_grid.add_child(slot)
		inventory_slots.append(slot)

## Open the inventory menu
func open() -> void:
	visible = true
	use_button.disabled = true
	item_info_label.text = ""
	
	# Deselect any selected slot
	if selected_slot:
		selected_slot.set_selected(false)
		selected_slot = null

## Close the inventory menu
func close() -> void:
	visible = false
	closed.emit()

## Update inventory display with items
func update_inventory(items: Array[InventoryItem]) -> void:
	# Clear all slots
	for slot in inventory_slots:
		slot.set_item(null)
	
	# Add items to slots
	for i in min(items.size(), inventory_slots.size()):
		inventory_slots[i].set_item(items[i])

func _on_slot_selected(slot: InventorySlot) -> void:
	# Deselect previous slot
	if selected_slot and selected_slot != slot:
		selected_slot.set_selected(false)
	
	selected_slot = slot
	
	if slot.item:
		_display_item_info(slot.item)
		use_button.disabled = false
		item_selected.emit(slot.item)
	else:
		item_info_label.text = ""
		use_button.disabled = true

func _display_item_info(item: InventoryItem) -> void:
	item_info_label.text = "[b]%s[/b]\n%s" % [item.name, item.description]

func _on_use_pressed() -> void:
	if selected_slot and selected_slot.item:
		item_used.emit(selected_slot.item)
		# Optionally remove item after use
		# selected_slot.set_item(null)
