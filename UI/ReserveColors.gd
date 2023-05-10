extends VBoxContainer

@export var capacity = 1
signal color_removed(color_but)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	GAME.color_reserve = self
#	GAME.turn_changed.connect(_on_turn_changed)
#	_on_turn_changed(1)
	
#func _on_turn_changed(_turn):
		
func add_color(color, button = null):
	if get_children().size() >= capacity:
		var but = get_child(capacity - 1)
		if button != but:
			color_removed.emit(but)
	var color_inst : ColorButton = GAME.get_color_but(color)
	color_inst.only_on_our_turn = true
	color_inst.second_action.connect(_on_second_action.bind(color_inst))
	add_child(color_inst)
	move_child(color_inst, 0)

func _on_second_action(color_but):
	if GAME.is_our_turn():
		color_removed.emit(color_but)
