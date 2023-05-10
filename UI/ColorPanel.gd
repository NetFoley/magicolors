extends PanelContainer



func _can_drop_data(_position, data):
	return data.has("color")

func _drop_data(_position, data):
	if is_instance_valid(data.button):
		data.button.disappear()
	get_child(0).add_color(data.color)
