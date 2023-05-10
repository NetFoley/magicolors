extends Control

func _can_drop_data(_position, data):
	return GAME.is_our_turn() and data.has("color")
	
func _drop_data(_position, data):
	if !GAME.is_our_turn():
		return
	if is_instance_valid(data.button):
		data.button.disappear()
	get_child(0).add_color(data.color, data.button)
