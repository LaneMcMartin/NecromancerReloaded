extends Area2D

# Export
@export var health = 3
@export var damage = 1

# Onready
@onready var enemy_sound = get_node("EnemySound")

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(damage_taken):
	health -= damage_taken
	if health <= 0:
		enemy_sound.play()
		await enemy_sound.finished
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("damage"):
		body.damage(damage)
