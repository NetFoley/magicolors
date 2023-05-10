extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScrollContainer/PanelContainer/Colors.color_removed.connect(_on_colors_color_removed)
	$ReserveCont/Reserve/ReserveColors.color_removed.connect(_on_reserve_color_removed)
	$ReserveCont2/Reserve/ReserveColors.color_removed.connect(_on_reserve_color_removed)
	GAME.turn_changed.connect(_on_turn_changed)
	
func _on_colors_color_removed(but):
	var data = {button = but, color = but.color}
	$SpellMaker._drop_data(Vector2(0,0), data)
	$SpellMaker._on_color_drag()

func _on_reserve_color_removed(but):
	var data = {button = but, color = but.color}
	$ScrollContainer/PanelContainer._drop_data(Vector2(0,0),data)

func _on_turn_changed(_turn):
	if GAME.is_our_turn() and _turn > 1:
		$NewTurn.play()
