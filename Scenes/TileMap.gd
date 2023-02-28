extends TileMap

var valid_mouse_pos = false
var cursor_pos = Vector2i(0,0)
var selecting = false:
	set(value):
		selecting = value
		$SelectCursor.visible = value
		GAME.selecting.emit(value)

func _physics_process(_delta):
	var local_pos = local_to_map(get_local_mouse_position())
	var i = get_cell_source_id(0, local_pos)
	valid_mouse_pos = i != -1
	if valid_mouse_pos:
		cursor_pos = local_pos * tile_set.tile_size + tile_set.tile_size/2
		$SelectCursor.global_position = cursor_pos
	
	$SelectCursor.visible = valid_mouse_pos and selecting

func _ready():
	GAME.tile_map = self
	selecting = false
	GAME.cancel_selection.connect(_on_cancel_selection)

func _input(event):
	if !selecting or !valid_mouse_pos:
		return
	if event.is_action_pressed("select"):
		selecting = false
		GAME.target_selected.emit(cursor_pos)

func _on_cancel_selection():
	selecting = false
