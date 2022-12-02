extends Node2D

# Onready
@onready var shot_speed_timer = get_node("ShotSpeedTimer")
@onready var muzzle = get_node("Muzzle")
@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
@onready var world_node = get_node("/root/World")

# Public
var shot_ready = true

func _ready():
	shot_speed_timer.timeout.connect(_on_shot_speed_timer_timeout)

func _physics_process(delta):
	
	# TODO: Handle parmeter switching if the player got a powerup
	# TODO: Handle sprite switching if the player got a powerup
	
	# Handle firing the weapon
	if Input.is_action_pressed("FirePrimary") and shot_ready:
		
		# Instance the bullet and provide it the player direction
		var bullet = bullet_scene.instantiate()
		bullet.set_normal(get_parent().aim_vector)
		bullet.global_position = muzzle.global_position
		world_node.add_child(bullet)
		
		
		# Prevent us from shooting and restart the shot speed timer
		shot_ready = false
		shot_speed_timer.start()
	
func _on_shot_speed_timer_timeout():
	shot_ready = true
