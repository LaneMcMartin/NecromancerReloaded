extends Node2D

var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the default modulation to transparent (alpha zero) and set text to display damage
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Label.text = "-" + str(damage)
	# Create a tweener that will show the text (0.5) and raise it up (1s) before fading it (1s).
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
	tween.tween_property(self, "position", Vector2(position.x + randi_range(-30,30), position.y + -120), 0.5)
	tween.chain().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	tween.chain().chain().tween_callback(self.queue_free)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
