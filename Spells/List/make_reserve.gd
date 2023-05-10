extends Spell


func launch(_target, _sender):
	if _sender != GAME.get_player():
		return
	for child in GAME.color_container.get_children():
		if GAME.get_reserve_color() != null:
			child.color = GAME.get_reserve_color()

func can_be_casted():
	var value = GAME.color_reserve and GAME.color_reserve.get_child_count() > 0
	if !value:
		GAME.error_popup.emit("need_reserve")
	return value

func get_target():
	GAME.validation_popup.emit(spell_name)
