extends CheckButton


# Called when the node enters the scene tree for the first time.
func _toggled(button_pressed):
	if button_pressed:
		GAME.local_player = GAME.player2
	else:
		GAME.local_player = GAME.player1
		
