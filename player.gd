extends CharacterBody3D

@export var speed: float = 10.0
@export var sprint_multiplier: float = 1.6
@export var crouch_multiplier: float = 0.45
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var crouch_head_offset: float = 0.45
@export var crouch_transition_speed: float = 10.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var camera_x_rotation: float = 0.0
var standing_head_y: float
var standing_collision_shape_y: float
var standing_capsule_height: float
var inventory: Dictionary = {}


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	standing_head_y = head.position.y
	standing_collision_shape_y = collision_shape.position.y
	if collision_shape.shape is CapsuleShape3D:
		standing_capsule_height = (collision_shape.shape as CapsuleShape3D).height

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation


func _physics_process(delta):
	var movement_vector = Vector3.ZERO
	var target_speed = speed
	var wants_crouch := _is_crouch_pressed()
	var wants_sprint := _is_sprint_pressed()

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	if wants_crouch:
		target_speed = speed * crouch_multiplier
	elif wants_sprint and movement_vector != Vector3.ZERO:
		target_speed = speed * sprint_multiplier

	_update_crouch_visual(delta, wants_crouch)

	velocity.x = lerp(velocity.x, movement_vector.x * target_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * target_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()

func _is_sprint_pressed() -> bool:
	return Input.is_action_pressed("sprint") or Input.is_key_pressed(KEY_SHIFT)

func _is_crouch_pressed() -> bool:
	return Input.is_action_pressed("crouch") or Input.is_key_pressed(KEY_CTRL)

func _update_crouch_visual(delta: float, crouching: bool) -> void:
	var target_head_y = standing_head_y - crouch_head_offset if crouching else standing_head_y
	head.position.y = lerp(head.position.y, target_head_y, crouch_transition_speed * delta)

	if standing_capsule_height > 0.0 and collision_shape.shape is CapsuleShape3D:
		var capsule := collision_shape.shape as CapsuleShape3D
		var target_height = standing_capsule_height * crouch_multiplier if crouching else standing_capsule_height
		capsule.height = lerp(capsule.height, target_height, crouch_transition_speed * delta)
		collision_shape.position.y = standing_collision_shape_y - ((standing_capsule_height - capsule.height) * 0.5)

func add_item_to_inventory(item_id: String, amount: int, item_display_name: String = "") -> void:
	if not inventory.has(item_id):
		inventory[item_id] = 0
	inventory[item_id] += max(amount, 1)

	var label = item_display_name if item_display_name != "" else item_id
	print("Picked up %dx %s. Inventory: %s" % [max(amount, 1), label, inventory])

func get_inventory() -> Dictionary:
	return inventory.duplicate()
