extends Spell


# Called when the node enters the scene tree for the first time.

func launch(target, sender):
#	var _crea = GAME.spawn_creature(0, target["position"], GAME.local_player)
	var _crea = GAME.spawn_creature(0, target["position"], sender)

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE})
