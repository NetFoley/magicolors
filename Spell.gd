extends Spell



func launch(_target, _sender : String):
	if !is_multiplayer_authority():
		return
	var tiles = GAME.tile_map.get_used_cells(0)
	for i in range(10):
		var tile = GAME.tile_map.map_to_local(tiles[randi()%tiles.size()-1])
		spawn_fireball.rpc(_sender, tile)
		await get_tree().create_timer(0.1).timeout
	
@rpc("any_peer", "call_local", "reliable")
func spawn_fireball(_sender, tile):
	var ball = get_node("Ball").duplicate()
	GAME.get_player_object(_sender).add_child(ball)
	ball.visible = true
	ball.goal_pos = tile
	ball.position = Vector2(0, -50)
	ball.appear()
	

func get_target():
	GAME.validation_popup.emit(spell_name)
