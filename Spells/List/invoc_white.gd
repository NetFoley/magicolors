extends Spell



func launch(_target, _sender : String):
	var _crea = GAME.spawn_creature(3, _target["position"], _sender)


func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE})
