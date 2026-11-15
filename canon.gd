class_name Canon
extends CharacterBody2D

const RASGULLA = preload("uid://b6hld1gijnrss")

var next_bullet_cooldown: bool = false
var reloading: bool = false
var shoots_per_round: int = 45
var remining_rasgullas: int

var is_invincible: bool = false
var health: int = 25

@export var speed: int = 0
@export var tilt_speed: float = 0

@onready var marker_2d: Marker2D = $Marker2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remining_rasgullas = shoots_per_round
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# move canon -----------------------------------------
	if Input.is_action_pressed("right"):
		position.x += speed * _delta
		animated_sprite.play("default")
	elif Input.is_action_pressed("left"):
		position.x += -speed * _delta
		animated_sprite.play_backwards("default")
	else:
		animated_sprite.pause()
	#----------------------------------------------------
	
	#look at mouse---------------------------------------
	var mouse_position: Vector2 = get_global_mouse_position()
	
	marker_2d.look_at(mouse_position)
	var rotate_value = marker_2d.rotation_degrees + 90
	rotate_value = clampi(rotate_value, -45, 45)
	marker_2d.rotation_degrees = rotate_value
	#------------------------------------------------------
	
	#fire--------------------------------------------------
	if Input.is_action_pressed("fire") and !reloading and !next_bullet_cooldown:
		next_bullet_cooldown = true
		$AudioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
		$AudioStreamPlayer.play()
		$"bullet cooldown".start()
		
		
		if remining_rasgullas > 0:
			var new_rasgulla: Area2D = RASGULLA.instantiate()
			new_rasgulla.global_position = marker_2d.global_position
			new_rasgulla.global_rotation_degrees = marker_2d.global_rotation_degrees + -90
			
			get_tree().current_scene.add_child(new_rasgulla)
	#------------------------------------------------------
	
	$"health bar".value = float(health)
	print(health)
	move_and_slide()


func _on_bullet_cooldown_timeout() -> void:
	next_bullet_cooldown = false

func take_damage() -> void:
	if !is_invincible:
		health -= 1
		modulate = Color.CRIMSON
		await get_tree().create_timer(0.2).timeout
		modulate = Color.WHITE
		
		if health <= 0:
			
			modulate = Color.CRIMSON
			get_tree().change_scene_to_file("res://scenes/final scene.tscn")
