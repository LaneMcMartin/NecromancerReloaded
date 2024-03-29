extends Area2D

# Export
@export var health = 3
@export var damage = 1
@export var speed = 200
@export_enum("Attract", "Distanced", "Erratic") var movement_type

# Onready
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var grave = preload("res://Scenes/grave.tscn")
@onready var damage_counter = preload("res://Scenes/damage_counter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	movement_type = 0 # TODO: Fix after debugging

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Check if the game state is running
	if Gamemanager.game_running:
		match movement_type:
			0: # Attract - Move toward player
				var velocity = global_position.direction_to(player.global_position)
				animate_enemy(velocity)
				position += (velocity * speed * delta)
			1: # Distanced - Move toward player but maintain a distance and shoot
				var velocity = global_position.direction_to(player.global_position)
				animate_enemy(velocity)
				if global_position.distance_to(player.global_position) <= 500:
					position += (velocity.orthogonal() * speed * delta)
				else:
					position += (velocity * speed * delta)
			2: # Erratic
				pass
		
		

# Bullet hit method
func hit(damage_taken):
	health -= damage_taken
	$EnemySound.play()
	var new_damage_counter = damage_counter.instantiate()
	new_damage_counter.damage = damage_taken
	new_damage_counter.global_position = self.global_position
	get_node("/root/World").add_child(new_damage_counter)
	if health <= 0:
		death()

func _on_body_entered(body):
	# If the enemy hit something, deal damage if it has a hit method - then delete
	if body.has_method("damage"):
		body.damage(damage)
	queue_free()
		
func death():
	#$EnemySound.play()
	#await EnemySound.finished
	Gamemanager.current_score += 1
	var new_grave = grave.instantiate()
	new_grave.global_position = self.global_position
	get_node("/root/World").add_child(new_grave)
	queue_free()

func animate_enemy(input_velocity):
	# Toggle movement if moving or not
	if input_velocity != Vector2.ZERO:
		$EnemySprite.playing = true
	else:
		$EnemySprite.playing = false
	
	# Flip sprite based off direction
	if input_velocity.x <= -0.5:
		$EnemySprite.flip_h = true
	if input_velocity.x >= 0.5:
		$EnemySprite.flip_h = false
