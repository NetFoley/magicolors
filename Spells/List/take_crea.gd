extends Spell


func launch(_target, _sender):
	var target = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(_target["position"]))
	if target:
		if target.player == "Player1" or target.player == "Player2":
			var shield = get_node("mental_control").duplicate()
			target.add_child(shield)
			target.player = _sender
			var old_id = target.get_multiplayer_authority()
			shield.attach(target, old_id)
			target.can_move = true
			target.can_attack = true
			print(GAME.get_player_object(_sender).get_multiplayer_authority())
			target.set_multiplayer_authority(multiplayer.get_remote_sender_id())
			
func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.ENEMY_CREATURE})
