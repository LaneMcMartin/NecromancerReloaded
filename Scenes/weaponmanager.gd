extends Node2D

# Onready
@onready var shot_speed_timer = get_node("ShotSpeedTimer")
@onready var muzzle = get_node("Muzzle")
@onready var shot_sound = get_node("ShotSound")
@onready var world_node = get_node("/root/World")
@onready var gun = get_node("Gun")

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")

# Public
var shot_ready = true

func _ready():
	shot_speed_timer.timeout.connect(_on_shot_speed_timer_timeout)

func _physics_process(delta):
	
	# TODO: Handle parmeter switching if the player got a powerup
	# TODO: Handle sprite switching if the player got a powerup
	
	# Handle mouselook
	look_at(get_parent().mouse_position)
	if get_parent().aim_vector.x < 0:
		gun.flip_v = 1
		gun.position.y = -20 # TODO: Spagehtti fix - make sure I make the sprite muzzle centered on vertical. 
	else:
		gun.flip_v = 0
		gun.position.y = 20 # TODO: Spagehtti fix - make sure I make the sprite muzzle centered on vertical. 
	
	# Handle firing the weapon
	if Input.is_action_pressed("FirePrimary") and shot_ready:
		
		# Instance the bullet and provide it the player direction
		var bullet = bullet_scene.instantiate()
		bullet.set_normal(get_parent().aim_vector)
		bullet.global_position = muzzle.global_position
		world_node.add_child(bullet)
		shot_sound.play()
		
		# Prevent us from shooting and restart the shot speed timer
		shot_ready = false
		shot_speed_timer.start()
	
func _on_shot_speed_timer_timeout():
	shot_ready = true
