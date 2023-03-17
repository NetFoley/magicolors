extends Spell


func launch(_target, _sender : String):
	var _crea = GAME.spawn_creature(2, _target["position"], _sender)

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE, "range": 4, "from_pos": GAME.tile_map.local_to_map(GAME.get_crystal(GAME.get_player()).position)})
	
