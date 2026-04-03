extends Area3D

@export var sceneName := "Level 1"

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.get_name() == "Player":
		var scene_path := _resolve_scene_path(sceneName)
		if scene_path != "":
			get_tree().change_scene_to_file(scene_path)

func _resolve_scene_path(scene_name: String) -> String:
	var trimmed := scene_name.strip_edges()
	if trimmed == "":
		return ""

	# Support direct path and several naming styles (e.g. "Level 1" -> "level_1.tscn").
	if trimmed.begins_with("res://") and ResourceLoader.exists(trimmed):
		return trimmed

	var candidates := [
		"res://scenes/%s.tscn" % trimmed,
		"res://scenes/%s.tscn" % trimmed.to_lower(),
		"res://scenes/%s.tscn" % trimmed.replace(" ", "_"),
		"res://scenes/%s.tscn" % trimmed.to_lower().replace(" ", "_")
	]

	for path in candidates:
		if ResourceLoader.exists(path):
			return path

	push_warning("AreaTrigger could not find scene: %s" % scene_name)
	return ""
