extends Spell

@export var heal_value = 10

# Called when the node enters the scene tree for the first time.
func launch(target, sender):
	var heal = get_node("HealEffect").duplicate()
	get_tree().root.add_child(heal)
	heal.position = target["position"]
	heal.appear()
	var tiles = GAME.tile_map.get_tiles_around(GAME.tile_map.local_to_map(target["position"]), 3)
	for tile in tiles:
		var crea = GAME.tile_map.get_creature_at_pos(tile)
		if crea and crea.can_be_targeted and crea.player == sender:
			crea.life += heal_value

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.ANY})
