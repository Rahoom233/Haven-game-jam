extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$score.text = str("SCORE: ", Global.score)
	$"high score".text = str("HIGH SCORE: ", Global.high_score)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scene.tscn")
