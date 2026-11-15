class_name Alien_Ball
extends CharacterBody2D

const JUMP_VELOCITY = -250.0
enum sizes{very_big, big, medium, small, baby}

@export var size: sizes

var health: int = 125 

var random_movement = randi_range(-5, 5)
var random_multiplier = randi_range(3, 5)

@warning_ignore("unused_signal")
signal dead

func _ready() -> void:
	var rand_multiplier = randf()
	match size:
		0:
			scale = Vector2(2.0, 2.0)
			@warning_ignore("narrowing_conversion")
			health = (health * 2.5) * rand_multiplier
		1:
			scale = Vector2(1.5, 1.5)
			@warning_ignore("narrowing_conversion")
			health = (health * 2) * rand_multiplier
		2:
			scale = Vector2(1.0, 1.0)
			@warning_ignore("narrowing_conversion")
			health = (health * 1.7) * rand_multiplier
		3:
			scale = Vector2(0.7, 0.7)
			@warning_ignore("narrowing_conversion")
			health = (health * 1.3) * rand_multiplier
		4:
			scale = Vector2(0.3, 0.3)
			@warning_ignore("narrowing_conversion")
			health = (health * 1) * rand_multiplier
	
	set_sprite_base()
	set_sprite_eyes()

func _process(_delta: float) -> void:
	$health.text = str(health)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * delta) * 0.3
	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.x += (random_movement * delta) * random_multiplier
	
	move_and_slide()


func _on_movement_changer_timeout() -> void:
	random_movement = randi_range(-3, 3)
	random_multiplier = randi_range(1, 3)
	$"movement changer".wait_time = randi_range(3, 6)
	$"movement changer".start()

func take_damage() -> void:
	health -= 1
	$AudioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayer.play()
	$base.self_modulate = Color("000000ff")
	await get_tree().create_timer(0.2).timeout
	$base.self_modulate = Color("ffffff")
	Global.score += 1 * (size + 1)
	if health <= 0:
		Global.score += 30 * (size + 1)
		dead.emit()
		$base.self_modulate = Color("000000ff")
		await get_tree().create_timer(0.1).timeout
		scale -= scale * 0.5
		$base.self_modulate = Color("000000ff")
		await get_tree().create_timer(0.1).timeout
		scale -= scale * 0.3
		$base.self_modulate = Color("000000ff")
		await get_tree().create_timer(0.1).timeout
		scale -= scale * 0.1
		$base.self_modulate = Color("000000ff")
		await get_tree().create_timer(0.1).timeout
		queue_free()

func set_sprite_base() -> void:
	var rand_i = randi_range(1, 8)
	var new_texture = load(str("res://asset/circles/",rand_i,".png"))
	$base.texture = new_texture

func set_sprite_eyes() -> void:
	var rand_i = randi_range(1, 3)
	var new_texture = load(str("res://asset/eyes/",rand_i,".png"))
	$eyes.texture = new_texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("canon"):
		body.take_damage()
