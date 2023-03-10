extends TileMap
class_name BoardTileMap

var valid_mouse_pos = false
var cursor_pos = Vector2i(0,0)

enum select_type{ANY, FREE_TILE, CREATURE, ALLY_CREATURE, ENEMY_CREATURE}

var tile_range = 0
var from_pos = Vector2i(0, 0)
var current_select_type = 0
var selecting = false:
	set(value):
		selecting = value
		$SelectCursor.visible = value
		$ValidTargets.queue_redraw()
		for child in $Creatures.get_children():
			child.enable_but(!value and child.can_move)

func _physics_process(_delta):
	var local_pos = local_to_map(get_local_mouse_position())
#			get_creatures()
	valid_mouse_pos = is_tile_valid(local_pos)
	if valid_mouse_pos:
		cursor_pos = local_pos * tile_set.tile_size + tile_set.tile_size/2
		$SelectCursor.global_position = cursor_pos
	
	$SelectCursor.visible = valid_mouse_pos and selecting 
		
func is_tile_valid(map_pos : Vector2i):
	var i = get_cell_source_id(0, map_pos)
	var is_in_map = i != -1 
	var is_valid = is_in_map
	var good_type = false
	match(current_select_type):
		select_type.ANY:
			good_type = true
		select_type.FREE_TILE:
			good_type = !is_pos_occupied(map_pos)
		select_type.CREATURE:
			good_type = is_pos_occupied(map_pos)
		select_type.ENEMY_CREATURE:
			good_type = is_pos_occupied(map_pos)
	is_valid = is_valid and good_type
	if tile_range > 0:
		var dist = get_dist_between(map_pos, from_pos)
		is_valid = is_valid and dist <= tile_range
	return is_valid

func get_dist_between(map_pos1, map_pos2):
	return (map_pos1 - map_pos2).length()

func _ready():
	GAME.tile_map = self
	selecting = false
	GAME.cancel_selection.connect(_on_cancel_selection)

func _input(event):
	if !selecting or !valid_mouse_pos:
		return
	if event.is_action_pressed("select"):
		selecting = false
		var creature_at_pos = get_creature_at_pos(local_to_map(cursor_pos))
		GAME.target_selected.emit({"position": cursor_pos, "creature": creature_at_pos})

func is_pos_occupied(map_pos : Vector2i) -> bool:
	if get_creature_at_pos(map_pos):
		return true
	return false

func get_creature_at_pos(map_pos):
	var creatures = $Creatures.get_children()
	for creature in creatures:
		if local_to_map(creature.position) == map_pos:
			return creature
	return null
	
func get_creatures():
	return $Creatures.get_children()
	
func _on_cancel_selection():
	selecting = false

func get_tiles(info):
	if info.has("range"):
		tile_range = info["range"]
	else:
		tile_range = 0
	if info.has("from_pos"):
		from_pos = info["from_pos"]
	current_select_type = info["type"]
	selecting = true

func add_creature(creature):
	$Creatures.add_child(creature)
