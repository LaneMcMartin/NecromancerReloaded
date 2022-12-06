extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/StartButton").button_down.connect(_on_start_button_down)
	get_node("VBoxContainer/QuitButton").button_down.connect(_on_quit_button_down)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_down():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_quit_button_down():
	pass
