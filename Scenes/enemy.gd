extends Area2D

# Export
@export var health = 3
@export var damage = 1
@export var speed = 200
@export_enum("Attract", "Distanced", "Erratic") var movement_type

# Onready
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var grave = preload("res://Scenes/grave.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Gamemanager.game_running:
		match movement_type:
			0: # Attract - Move toward player
				var velocity = global_position.direction_to(player.global_position)
				position += (velocity * speed * delta)
			1: # Distanced - Move toward player but maintain a distance and shoot
				var velocity = global_position.direction_to(player.global_position)
				if global_position.distance_to(player.global_position) <= 500:
					position += (velocity.orthogonal() * speed * delta)
				else:
					position += (velocity * speed * delta)
			2: # Erratic
				pass

func hit(damage_taken):
	health -= damage_taken
	if health <= 0:
		#$EnemySound.play()
		#await EnemySound.finished
		Gamemanager.current_score += 1
		var new_grave = grave.instantiate()
		new_grave.global_position = self.global_position
		get_node("/root/World").add_child(new_grave)
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("damage"):
		body.damage(damage)
		
func death():
	pass
