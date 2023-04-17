extends Spell

func launch(_target, _sender):
	if _sender == GAME.get_player():
		var res_col = GAME.get_reserve_color()
#		var res_node = $draw_res.duplicate()
#		res_node.appear(res_col)
#		GAME.get_player_object(_sender).add_child(res_node)
		for _i in range(2):
			GAME.add_color(res_col)
	
	
func can_be_casted():
	var value = GAME.color_reserve and GAME.color_reserve.get_child_count() > 0
	if !value:
		GAME.error_popup.emit("need_reserve")
	return value

func get_target():
	GAME.get_targets([{"type": GAME.tile_map.select_type.FREE_TILE}])
