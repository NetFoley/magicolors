extends Spell


# Called when the node enters the scene tree for the first time.

func launch(target, sender):
#	var _crea = GAME.spawn_creature(0, target["position"], GAME.local_player)
	var _crea = GAME.spawn_creature(GAME.get_reserve_color(), target["position"], sender)

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE, "range": 4, "from_pos": GAME.tile_map.local_to_map(GAME.get_crystal(GAME.get_player()).position)})
	

func can_be_casted():
	return GAME.color_reserve and GAME.color_reserve.get_child_count() > 0
