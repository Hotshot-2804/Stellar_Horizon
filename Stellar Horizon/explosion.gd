extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Force the blast to fire instantly
	emitting = true

	# Wait for the particles to finish their lifetime and then delete the node
	await get_tree().create_timer(lifetime).timeout
	queue_free()

