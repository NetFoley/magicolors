extends Spell

func launch(_target, _sender):
	var target = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(_target["position"]))
	if target:
		var shield = get_node("magic_shield").duplicate()
		target.add_effect(shield)
		shield.attach(target)
			
		
func get_target():
	GAME.get_targets([{"type": GAME.tile_map.select_type.CREATURE}])
