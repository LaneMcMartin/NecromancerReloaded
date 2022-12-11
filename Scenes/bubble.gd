extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func scan_raise():
	var areas = get_overlapping_areas()
	for area in areas:
		# If the bubble captured something, run the raised method (if the node has one)
		if area.has_method("raised"):
			area.raised()
