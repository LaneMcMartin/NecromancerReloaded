extends CharacterBody2D

# Editor
@export var move_speed = 400
@export var dash_multiplier = 3

# OnReady
@onready var bubble = preload("res://Scenes/bubble.tscn")

# Movement
var dash_available = true
var dash_active = false
var aim_vector
var mouse_position

# Stats
var is_invincible = false
var is_dead = false
var is_raising = false
var health = 3

func _ready():
	# Connect timers
	$DashCooldownTimer.timeout.connect(_on_dash_cooldown_timer_timeout)
	$DashActiveTimer.timeout.connect(_on_dash_active_timer_timeout)
	$InvincibleTimer.timeout.connect(_on_invincible_timer_timeout)

func _physics_process(delta):
	# Check aliveness
	if is_dead:
		return
	
	# Handle mouselook and aim vector
	mouse_position = get_global_mouse_position()
	aim_vector = (mouse_position - position).normalized()
	
	# Handle movement
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		velocity.y -= move_speed
	if Input.is_action_pressed("Down"):
		velocity.y += move_speed
	if Input.is_action_pressed("Left"):
		velocity.x -= move_speed
	if Input.is_action_pressed("Right"):
		velocity.x += move_speed
	
	# Handle dash
	if Input.is_action_just_pressed("Space") and dash_available:
		dash()
	
	# Process movement
	if dash_active:
		velocity *= dash_multiplier
	move_and_slide()

func damage(damage_taken):
	# Check invincibility
	if not is_invincible:
		# Deduct HP and/or cause death
		health -= damage_taken
		if health <= 0:
			death()
		# Trigger invincibility and blinking
		$InvincibleTimer.start()
		$AnimationPlayer.play("Flash")
	
func death():
	Gamemanager.game_over()
	is_dead = true
	
func dash():
	dash_available = false
	dash_active = true
	$DashCooldownTimer.start()
	$DashActiveTimer.start()
	$DashSound.play()
	
func _on_dash_cooldown_timer_timeout():
	dash_available = true
	
func _on_dash_active_timer_timeout():
	dash_active = false
	
func _on_invincible_timer_timeout():
	is_invincible = false
	$AnimationPlayer.play("NoFlash")
