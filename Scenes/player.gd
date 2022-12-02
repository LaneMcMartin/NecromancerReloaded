extends CharacterBody2D

# Editor
@export var move_speed = 400
@export var dash_multiplier = 3

# OnReady
@onready var dash_cooldown_timer = get_node("DashCooldownTimer")
@onready var dash_active_timer = get_node("DashActiveTimer")

# Public
var dash_available = true
var dash_active = false
var aim_vector

func _ready():
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	dash_active_timer.timeout.connect(_on_dash_active_timer_timeout)

func _process(delta):
	pass

func _physics_process(delta):
	
	# Handle mouselook and aim vector
	var mouse_position = get_viewport().get_mouse_position()
	aim_vector = (mouse_position - position).normalized()
	look_at(mouse_position)
	
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
		dash_available = false
		dash_active = true
		dash_cooldown_timer.start()
		dash_active_timer.start()
		print("Dash timer started!")
	if dash_active:
		velocity *= dash_multiplier
	
	move_and_slide()

func _on_dash_cooldown_timer_timeout():
	dash_available = true
	print("Dash cooldown reset!")
	
func _on_dash_active_timer_timeout():
	dash_active = false
	print("Dash active reset!")
