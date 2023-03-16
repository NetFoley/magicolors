extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.color_container = self
	GAME.turn_changed.connect(_on_turn_changed)
	_on_turn_changed(1)
	
func _on_turn_changed(_turn):
	if GAME.is_our_turn():
		return
	for child in get_children():
		child.disappear()
	for i in range(10):
		add_color(randi()%4)

func add_color(color):
	var color_inst = GAME.get_color_but(color)
	add_child(color_inst)
