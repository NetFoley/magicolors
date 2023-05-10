extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _gui_input(event):
	if event.is_action_pressed("select"):
		if custom_minimum_size.y == 100.0:
			custom_minimum_size.y = 350.0
		else:
			custom_minimum_size.y = 100.0
			
