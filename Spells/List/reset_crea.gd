extends Spell


func launch(_target, _sender):
	var target = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(_target["position"]))
	if target:
		target.can_move = true
		target.can_attack = true
			
		
func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.CREATURE})
