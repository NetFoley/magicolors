extends Spell

func launch(_target, _sender):
	if _sender == GAME.get_player():
		var res_col = GAME.get_reserve_color()
		var res_node = $draw_res.duplicate()
		res_node.appear(res_col)
		GAME.get_player_object(_sender).add_child(res_node)
	
	
func can_be_casted():
	return GAME.color_reserve and GAME.color_reserve.get_child_count() > 0

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE})
