extends Node2D

const SPEED = 1200
const DISSAPER_RANGE = 1500
var travelled_distance: float

func _ready() -> void:
	var rand_i = randi_range(1, 3)
	match rand_i:
		1:
			var rasgulla1 = load("res://asset/rasgulle/rasgulla1.png")
			$Sprite2D.texture = rasgulla1
		2:
			var rasgulla2 = load("res://asset/rasgulle/rasgulla2.png")
			$Sprite2D.texture = rasgulla2
		3:
			var rasgulla3 = load("res://asset/rasgulle/rasgulla3.png")
			$Sprite2D.texture = rasgulla3
	
	

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance > DISSAPER_RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		
		queue_free()
