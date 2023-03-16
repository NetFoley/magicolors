extends Control

@export var capacity = 1

func _ready():
	GAME.color_reserve = self

func _can_drop_data(_position, data):
	return data.has("color")
	
func _drop_data(_position, data):
	if get_children().size() >= capacity:
		var but = get_child(0)
		if but != data.button:
			GAME.add_color(but.color)
		but.queue_free()
	data.button.queue_free()
	add_child(GAME.get_color_but(data.color))

