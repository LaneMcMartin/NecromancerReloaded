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
var health = 3

# Raising
var is_raising = false

func _ready():
	# Connect signals
	$DashCooldownTimer.timeout.connect(_on_dash_cooldown_timer_timeout)
	$DashActiveTimer.timeout.connect(_on_dash_active_timer_timeout)
	$InvincibleTimer.timeout.connect(_on_invincible_timer_timeout)
	$"Bubble/AnimatedSprite2D".animation_finished.connect(_on_finished_raising)

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
	
	# Handle raising
	if Input.is_action_just_pressed("FireSecondary"):
		raise_start()
	if not Input.is_action_pressed("FireSecondary"):
		raise_end()
	
	# Process movement
	if dash_active:
		velocity *= dash_multiplier
	if not is_raising:
		move_and_slide()
		
	# Animate Sprite
	animate_player(velocity)

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
	
func raise_start():
	$Bubble.show()
	$"Bubble/AnimatedSprite2D".play("bubble")
	is_raising = true
	
func raise_end():
	$Bubble.hide()
	$"Bubble/AnimatedSprite2D".stop()
	$"Bubble/AnimatedSprite2D".set_frame(0)
	is_raising = false
	
func animate_player(input_velocity):
	# Toggle movement if moving or not
	if velocity != Vector2.ZERO:
		$PlayerSprite.playing = true
	else:
		$PlayerSprite.playing = false
	
	# Flip sprite based off direction
	if velocity.x <= -0.5:
		$PlayerSprite.flip_h = true
	if velocity.x >= 0.5:
		$PlayerSprite.flip_h = false
	
	
func _on_dash_cooldown_timer_timeout():
	dash_available = true
	
func _on_dash_active_timer_timeout():
	dash_active = false
	
func _on_invincible_timer_timeout():
	is_invincible = false
	$AnimationPlayer.play("NoFlash")

func _on_finished_raising():
	$Bubble.scan_raise()
	raise_end()
