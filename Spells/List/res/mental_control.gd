extends Node

var parent_crea : Creature
var old_id

func attach(crea, sdr):
	old_id = sdr
	parent_crea = crea
	GAME.turn_changed.connect(_on_turn_changed)

func _on_turn_changed(_turn):
	if parent_crea:
		if parent_crea.player == "Player1":
			parent_crea.player = "Player2"
		elif parent_crea.player == "Player2":
			parent_crea.player = "Player1"
	
	parent_crea.set_multiplayer_authority(old_id)
	queue_free()
