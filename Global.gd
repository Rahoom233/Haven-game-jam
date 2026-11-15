extends Node

var score: int = 0
var high_score: int = 0

func set_score() -> void:
	if score > high_score:
		high_score = score
