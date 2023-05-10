extends Spell


func launch(_target, _sender):
	if !is_multiplayer_authority():
		return
	var player_to_give = "Player1"
	var player_to_take = "Player2"
	if _sender == "Player2":
		player_to_give = "Player2"
		player_to_take = "Player1"
	
	if GAME.get_player_object(player_to_take).spells.size() <= 0:
		return
	var rd_idx = randi_range(0, GAME.get_player_object(player_to_take).spells.size()-1)
	steal_spell.rpc(player_to_give, player_to_take, rd_idx)

@rpc("authority", "call_local", "reliable")
func steal_spell(player_to_give, player_to_take, spell_idx):
	var player = GAME.get_player_object(player_to_take)
	var spell = player.spells[spell_idx]
	GAME.old_spell.emit(spell, player_to_take)
	GAME.new_spell.emit(spell, player_to_give)

func get_target():
	GAME.validation_popup.emit(spell_name)
