extends Area2D

# Export
@export var health = 3
@export var damage = 1
@export var speed = 200
@export_enum("Attract", "Distanced", "Erratic") var movement_type

# Onready
@onready var enemy_sound = get_node("EnemySound")
@onready var player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match movement_type:
		0: # Attract
			var velocity = global_position.direction_to(player.global_position)
			position += (velocity * speed * delta)
		1: # Distanced
			pass
		2: # Erratic
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
