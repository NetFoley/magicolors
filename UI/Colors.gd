extends HBoxContainer

signal color_removed(color_but)

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.color_container = self
	GAME.turn_changed.connect(_on_turn_changed)
	_on_turn_changed(1)
	GAME.new_colors.connect(_on_new_colors)
	
func _on_turn_changed(_turn):
	if GAME.is_our_turn() and _turn!= 1:
		return
	var new_colors = []
	for i in range(10):
		var color = randi()%4
		new_colors.append(color)
#		add_color(color)
	GAME.new_colors.emit(new_colors, GAME.get_player())

func _on_new_colors(colors, player):
	if player != GAME.get_player():
		return
	for child in get_children():
		child.disappear()
	print(str(colors) + " for " + str(player))
	for color in colors:
		add_color(color)

func add_color(color):
	var color_inst = GAME.get_color_but(color)
	color_inst.second_action.connect(_on_second_action.bind(color_inst))
	add_child(color_inst)

func _on_second_action(color_but):
	color_removed.emit(color_but)
	
