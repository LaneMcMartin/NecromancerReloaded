extends Area2D

# Onready
@onready var death_timer = get_node("DeathTimer")

# Export
@export var speed = 2000

# Public
var bullet_normal = Vector2()

func _ready():
	death_timer.timeout.connect(_on_death_timer_timeout)
	print("bullet made!")

func _physics_process(delta):
	position += bullet_normal * speed * delta

func _on_death_timer_timeout():
	queue_free()
	print("bullet die!")
	
func set_normal(input_normal):
	bullet_normal = input_normal
	rotation = bullet_normal.angle()
