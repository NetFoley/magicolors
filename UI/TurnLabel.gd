extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.turn_changed.connect(_on_turn_change)
	
func _on_turn_change(value):
	text = "Tour " + var_to_str(value)
