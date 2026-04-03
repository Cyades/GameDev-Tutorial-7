extends Interactable

class_name PickupItem

@export var item_id: String = "battery"
@export var item_display_name: String = "Battery"
@export var amount: int = 1
@export var destroy_on_pickup: bool = true
@export var destroy_parent_on_pickup: bool = false

func interact(interactor: Node = null):
	if interactor != null and interactor.has_method("add_item_to_inventory"):
		interactor.add_item_to_inventory(item_id, amount, item_display_name)
		if destroy_on_pickup:
			if destroy_parent_on_pickup and get_parent() != null:
				get_parent().queue_free()
			else:
				queue_free()
