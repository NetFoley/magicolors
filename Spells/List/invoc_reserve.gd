extends Spell

func launch(target, sender):
#	var _crea = GAME.spawn_creature(0, target["position"], GAME.local_player)
	if GAME.get_player() == sender:
		if GAME.get_reserve_color() == GAME.colorType.GREEN:
			launch_my_color.rpc(GAME.get_random_color(), target, sender)
		else:
			launch_my_color.rpc(GAME.get_reserve_color(), target, sender)
	
@rpc("any_peer", "call_local", "reliable")
func launch_my_color(color, target, sender):
	var _crea = GAME.spawn_creature(color, target["position"], sender)
		
func get_target():
	GAME.get_targets([{"type": GAME.tile_map.select_type.FREE_TILE, "range": 4, "from_pos": GAME.tile_map.local_to_map(GAME.get_crystal(GAME.get_player()).position), "hop_hover": true}])
	

func can_be_casted():
	var value = GAME.color_reserve and GAME.color_reserve.get_child_count() > 0
	if !value:
		GAME.error_popup.emit("need_reserve")
	return value
