extends RayCast3D

func _process(_delta):
	var collider = get_collider()

	if is_colliding() and collider is Interactable:
		if Input.is_action_just_pressed("interact"):
			var interactor = get_tree().get_first_node_in_group("player")
			collider.interact(interactor)
