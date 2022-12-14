extends Area2D

#TODO
#Powerup type is randomly selected when spawning
#Powerup types have varied rarity
#Sprite is selected from an array

var powerup_types = {
	# Rapid Fire
	"rapid_fire": {
		"rarity": 0.5,
		"sprite": "res://Assets/bullet_placeholder.png",
	},
	# Speed Boost
	"speed_boost": {
		"rarity": 0.5,
		"sprite": "res://Assets/bullet_placeholder.png",
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO: Some way to select a powerup based on weighted proabability
	$Sprite.texture = load(powerup_types["rapid_fire"]["sprite"])
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	# If the pickup hit a player, activate the corresponding function on the player - then delete
	if body.is_in_group("player"):
		body.rapid_fire()
	queue_free()
