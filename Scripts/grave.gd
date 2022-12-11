extends Area2D

# Onready
@onready var zombie = preload("res://Scenes/zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func raised():
	var new_zombie = zombie.instantiate()
	new_zombie.global_position = self.global_position
	get_node("/root/World").add_child(new_zombie)
	queue_free()
