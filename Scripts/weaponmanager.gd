extends Node2D

# Onready
@onready var world_node = get_node("/root/World")
@onready var camera = get_parent().get_node("Camera2D")
@onready var bullet_scene = preload("res://Scenes/bullet.tscn")

# Public
var shot_ready = true

func _ready():
	$ShotSpeedTimer.timeout.connect(_on_shot_speed_timer_timeout)
	

func _physics_process(delta):
	
	# TODO: Handle parmeter switching if the player got a powerup
	# TODO: Handle sprite switching if the player got a powerup
	
	# Handle mouselook
	look_at(get_parent().mouse_position)
	if get_parent().aim_vector.x < 0:
		$Gun.flip_v = 1
		$Gun.position.y = -20 # TODO: Spagehtti fix - make sure I make the sprite muzzle centered on vertical. 
	else:
		$Gun.flip_v = 0
		$Gun.position.y = 20 # TODO: Spagehtti fix - make sure I make the sprite muzzle centered on vertical. 
	
	# Handle firing the primary weapon
	if Input.is_action_pressed("FirePrimary") and shot_ready:
		# Instance the bullet and provide it the player direction
		var bullet = bullet_scene.instantiate()
		bullet.set_normal(get_parent().aim_vector)
		bullet.global_position = $Muzzle.global_position
		world_node.add_child(bullet)
		$ShotSound.play()
		$MuzzleFlash.set_emitting(true)
		camera.apply_shake(10.0)
		
		# Prevent us from shooting and restart the shot speed timer
		shot_ready = false
		$ShotSpeedTimer.start()
	
func _on_shot_speed_timer_timeout():
	shot_ready = true
