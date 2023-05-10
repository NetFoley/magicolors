extends Spell

func launch(_target, sender):
#	var _crea = GAME.spawn_creature(0, target["position"], GAME.local_player)
	if GAME.get_player() == sender:
		GAME.creature_color_cont.eat_color()
#		if GAME.get_reserve_color() == GAME.colorType.GREEN:
#			launch_my_color.rpc(GAME.get_random_color(), target, sender)
#		else:
#			launch_my_color.rpc(GAME.get_reserve_color(), target, sender)
	
@rpc("any_peer", "call_local", "reliable")
func launch_my_color(color, target, sender):
	var _crea = GAME.spawn_creature(color, target["position"], sender)
			
func get_target():
	GAME.validation_popup.emit(spell_name)
	
func can_be_casted():
	var value = GAME.creature_color_cont and GAME.creature_color_cont.get_color_qty() > 0
	if !value:
		GAME.error_popup.emit("need_crea_cont")
	return value
