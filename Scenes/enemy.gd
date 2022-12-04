extends CharacterBody2D

# Export
@export var health = 3

# Onready
@onready var enemy_sound = get_node("EnemySound")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(damage):
	health -= damage
	if health <= 0:
		enemy_sound.play()
		await enemy_sound.finished
		queue_free()
