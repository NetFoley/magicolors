extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.pressed.connect(_on_pressed.bind(child.text))

func _on_pressed(text):
	if text == "R":
		GAME.add_color(GAME.colorType.RED)
	if text == "G":
		GAME.add_color(GAME.colorType.GREEN)
	if text == "B":
		GAME.add_color(GAME.colorType.BLUE)
	if text == "W":
		GAME.add_color(GAME.colorType.WHITE)
		
