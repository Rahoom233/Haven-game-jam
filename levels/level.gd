extends Node2D

enum sizes{very_big, big, medium, small, baby}

@onready var canon: Node2D = $canon

@export var alien_sizes: Array[sizes]
@export var alien_ammount: Array[int]

var aliens_spawned: int = 0
var spawners

const ALIEN_BALL = preload("uid://chnfqgp31qo4u")

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawners = $"alien spawners".get_children()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str("SCORE: ", Global.score)

func spawn_alien() -> void:
	var alien: Alien_Ball = ALIEN_BALL.instantiate()
	
	var total_value = alien_sizes.size()
	total_value -= 1
	var random_value = randi_range(0, total_value)
	
	@warning_ignore("int_as_enum_without_cast")
	alien.size = random_value
	
	var remaining_ammount = alien_ammount[random_value]
	
	if remaining_ammount > 0 and aliens_spawned <= 5:
		var spawner = spawners.pick_random()
		var spawn_pos = spawner.position
		alien.position = spawn_pos
		alien.dead.connect(alien_died)
		add_child(alien)
		aliens_spawned += 1
	


func _on_timer_timeout() -> void:
	timer.wait_time = randi_range(1, 5)
	timer.start()
	spawn_alien()

func alien_died() -> void:
	aliens_spawned -= 1
