extends Spell


func launch(_target, _sender):
	var target = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(_target["position"]))
	if target:
		target.max_life += 10
		target.life += 10
		var particles = $GPUParticles2D.duplicate()
		target.add_child(particles)
		particles.emitting = true
		particles.visible = true
		await get_tree().create_timer(3.0).timeout
		particles.queue_free()
		
func get_target():
	GAME.get_targets([{"type": GAME.tile_map.select_type.ALLY_CREATURE}])
