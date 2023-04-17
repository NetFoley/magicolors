extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = connect("pressed", _on_pressed)
	GAME.turn_changed.connect(_on_turn_changed)
	
func _on_turn_changed(_value):
	disabled = !GAME.is_our_turn()
	
func _on_pressed():
	if GAME.is_our_turn():
		GAME.rpc("go_next_turn")
#
#@rpc("reliable", "call_local", "any_peer")
#func go_next_turn():
#	GAME.turn += 1
