extends Control


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("close"):
		get_tree().change_scene_to_file("res://scenes/main scene.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scene.tscn")
