extends Spell


func launch(_target, _sender):
	for child in GAME.color_container.get_children():
		if GAME.get_reserve_color():
			child.color = GAME.get_reserve_color()

func can_be_casted():
	return GAME.color_reserve and GAME.color_reserve.get_child_count() > 0

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE})
