extends Resource
class_name InventoryItem

## Resource representing an inventory item

@export var name: String = "Item"
@export var description: String = "An item."
@export var icon: Texture2D
@export var stack_size: int = 1
@export var consumable: bool = true
@export var item_type: ItemType = ItemType.MISC

enum ItemType {
	FOOD,
	WATER,
	MEDICAL,
	TOOL,
	KEY,
	MISC
}

## Use the item (override in derived classes)
func use(player) -> bool:
	return false
