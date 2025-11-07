extends PanelContainer
class_name InventorySlot

## Individual inventory slot

signal selected(slot: InventorySlot)

@onready var item_icon: TextureRect = $ItemIcon
@onready var item_count: Label = $ItemCount
@onready var selection_highlight: NinePatchRect = $SelectionHighlight

var slot_index: int = -1
var item: InventoryItem
var is_selected: bool = false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	selection_highlight.visible = false
	item_count.visible = false

## Set the item in this slot
func set_item(new_item: InventoryItem) -> void:
	item = new_item
	
	if item:
		item_icon.texture = item.icon
		item_icon.visible = true
		
		if item.stack_size > 1:
			item_count.text = str(item.stack_size)
			item_count.visible = true
		else:
			item_count.visible = false
	else:
		item_icon.visible = false
		item_count.visible = false

## Set selection state
func set_selected(selected: bool) -> void:
	is_selected = selected
	selection_highlight.visible = selected

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selected.emit(self)
			set_selected(true)
