extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func appear():
	visible = true
	emitting = true
	await get_tree().create_timer(10.0).timeout
	queue_free()
