extends Node

var color_to_spawn

# Called when the node enters the scene tree for the first time.
func appear(sp):
	color_to_spawn = sp
	GAME.turn_changed.connect(_on_turn_changed)
	
func _on_turn_changed(_turn):
	for _i in range(3):
		GAME.add_color(color_to_spawn)
	queue_free()
