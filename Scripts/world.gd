extends Node2D

@onready var enemy = preload("res://Scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MobSpawner.timeout.connect(_on_mobspawner_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_mobspawner_timeout():
	if Gamemanager.game_running:
		var spawnpoint = Vector2(randi_range(-2000,2000), randi_range(-1250,1250))
		var new_enemy = enemy.instantiate()
		new_enemy.position = spawnpoint
		add_child(new_enemy)
