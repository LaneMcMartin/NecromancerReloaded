extends Area2D

# Export
@export var health = 1
@export var damage = 1
@export var speed = 200
@export_enum("Attract", "Distanced", "Erratic") var movement_type

# Public
var target_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	target_enemy = find_closest_enemy()
	movement_type = 0 # TODO: Fix after debugging

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Check if the game state is running
	if Gamemanager.game_running:
		# If we haven't found an enemy yet, try to find one
		if target_enemy == null:
			target_enemy = find_closest_enemy()
		
		match movement_type:
			0: # Attract - Move toward enemy
				var velocity = global_position.direction_to(target_enemy.global_position)
				animate_zombie(velocity)
				position += (velocity * speed * delta)
			1: # Distanced - Move toward enemy but maintain a distance and shoot
				var velocity = global_position.direction_to(target_enemy.global_position)
				animate_zombie(velocity)
				if global_position.distance_to(target_enemy.global_position) <= 500:
					position += (velocity.orthogonal() * speed * delta)
				else:
					position += (velocity * speed * delta)
			2: # Erratic
				pass

func _on_area_entered(area):
	# If the enemy hit something, deal damage if it has a hit method - then delete
	print(area)
	if area.has_method("hit"):
		area.hit(damage)
		queue_free()
	
func find_closest_enemy():
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var closest_enemy = null
	var closest_enemy_distance = 0.0
	for current_enemy in all_enemies:
		var current_enemy_distance = global_position.distance_squared_to(current_enemy.global_position)
		if (closest_enemy == null) or (current_enemy_distance < closest_enemy_distance):
			closest_enemy = current_enemy
			closest_enemy_distance = current_enemy_distance
	return closest_enemy

func animate_zombie(input_velocity):
	# Toggle movement if moving or not
	if input_velocity != Vector2.ZERO:
		$ZombieSprite.playing = true
	else:
		$ZombieSprite.playing = false
	
	# Flip sprite based off direction
	if input_velocity.x <= -0.5:
		$ZombieSprite.flip_h = false
	if input_velocity.x >= 0.5:
		$ZombieSprite.flip_h = true
