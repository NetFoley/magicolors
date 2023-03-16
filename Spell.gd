extends Spell



func launch(_target, _sender : String):
	var _crea = GAME.spawn_creature(0, _target["position"], _sender)
