extends PanelContainer



func _can_drop_data(_position, data):
	return data.has("color")

func _drop_data(_position, data):
	data.button.disappear()
	get_child(0).add_child(GAME.get_color_but(data.color))
