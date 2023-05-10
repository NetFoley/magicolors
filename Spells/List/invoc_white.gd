extends Spell

func launch(_target, _sender):
	if !is_multiplayer_authority():
		return
	var player_to_give = "Player1"
#	var player_to_take = "Player2"
	if _sender == "Player2":
		player_to_give = "Player2"
#		player_to_take = "Player1"
	
	var spells = GAME.get_spells()
	var rdi = randi()%spells.size()
	GAME.new_spell.emit(spells[rdi].spell_id, player_to_give)
#	await get_tree().physics_frame
	GAME.rdy_last_spell.emit()
	GAME.new_spell.emit(spells[rdi].spell_id, player_to_give)
	await get_tree().physics_frame
	GAME.rdy_last_spell.emit()
	

func get_target():
	GAME.validation_popup.emit(spell_name)
