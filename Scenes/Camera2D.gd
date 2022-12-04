extends Camera2D

# Export
@export var max_shake_strength = 10
@export var shake_decay = 5

# Onready
@onready var rand = RandomNumberGenerator.new()

# Public 
var shake_strength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	offset = get_random_offset()

func apply_shake(applied_strength):
	shake_strength = applied_strength
	
func get_random_offset():
	return Vector2(rand.randf_range(-shake_strength, shake_strength), rand.randf_range(-shake_strength, shake_strength))
