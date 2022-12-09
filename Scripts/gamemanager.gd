extends Node

var current_score = 0
var game_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func game_over():
	game_running = false
	var game_over_overlay = preload("res://Scenes/game_over.tscn")
	var new_game_over_overlay = game_over_overlay.instantiate()
	get_tree().get_root().get_node("World/UILayer").add_child(new_game_over_overlay)
