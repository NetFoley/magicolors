extends Spell

func launch(_target, _sender):
	var target_pos = GAME.tile_map.local_to_map(_target["position"])
	if target_pos:
		for i in range(-1, 2):
			for j in range(-1, 2):
				var t_size : Vector2i = GAME.tile_map.tile_set.tile_size
				var pos = Vector2(target_pos*t_size) + Vector2(float(i*t_size.x), float(j*t_size.y)) + Vector2(t_size/2)
				if GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(pos)) != null:
					continue
				var fire = get_node("Wall").duplicate()
				GAME.add_creature_to_tilemap(fire, pos, "neutral")
		
func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.ANY})
