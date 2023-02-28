extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = pressed.connect(_on_pressed)
	__ = GAME.selecting.connect(_on_selecting)

func _on_selecting(value):
	visible = value
	
func _on_pressed():
	GAME.cancel_selection.emit()
