extends Area2D

# Export
@export var speed = 2000
@export var damage = 1
@export var spread = 0.1

# Public
var bullet_normal = Vector2()

func _ready():
	$DeathTimer.timeout.connect(_on_death_timer_timeout)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	# Move the bullet formward along the normal
	position += bullet_normal * speed * delta

func _on_death_timer_timeout():
	# Remove the bullet after the timer is elapsed
	queue_free()
	
func set_normal(input_normal):
	# Set the normal of the bullet, add spread, and then rotate accordingly
	bullet_normal = input_normal
	bullet_normal.y += randf_range(-spread, spread)
	rotation = bullet_normal.angle()

func _on_area_entered(body):
	# If the bullet hit something, deal damage if it has a hit method - then delete
	if body.has_method("hit"):
		body.hit(damage)
	queue_free()
