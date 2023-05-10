extends Spell


func launch(_target, _sender):
	var target = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(_target["position"]))
	if target:
		if target.player == "Player1" or target.player == "Player2":
			var shield = get_node("SelfDelete").duplicate()
			var new_creature = target.duplicate()
			new_creature.add_effect(shield)
			shield.attach(new_creature)
#			if new_creature.get_parent():
#				new_creature.get_parent().remove_child(new_creature)
				
			GAME.add_creature_to_tilemap(new_creature, GAME.tile_map.map_to_local(GAME.tile_map.get_closest_free_tile(GAME.tile_map.local_to_map(target.position))), _sender)
			
func get_target():
	GAME.get_targets([{"type": GAME.tile_map.select_type.CREATURE}])
