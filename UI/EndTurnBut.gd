extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = connect("pressed", _on_pressed)
	
func _on_pressed():
	if GAME.is_our_turn():
		GAME.turn = GAME.turn + 1
