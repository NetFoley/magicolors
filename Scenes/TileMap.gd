extends TileMap
class_name BoardTileMap


var astar = AStarGrid2D.new()
var valid_mouse_pos = false
var cursor_pos = Vector2i(0,0)

enum select_type{ANY, FREE_TILE, CREATURE, ALLY_CREATURE, ENEMY_CREATURE, ANY_CREATURE}

var tile_selectors : Array
var selecting = false:
	set(value):
		update_solid_points()
		selecting = value
		$SelectCursor.visible = value
		$ValidTargets.queue_redraw()
		for child in $Creatures.get_children():
			child.enable_but(!value and child.can_move)

func _process(_delta):
	var local_pos = local_to_map(get_local_mouse_position())
#			get_creatures()
	valid_mouse_pos = is_tile_valid(local_pos)
	if valid_mouse_pos:
		cursor_pos = map_to_local(local_pos)
#		cursor_pos = local_pos * tile_set.tile_size + tile_set.tile_size/2 
		$SelectCursor.global_position = cursor_pos
	
	$SelectCursor.visible = valid_mouse_pos and selecting 
		
func is_tile_valid(map_pos : Vector2i):
	var i = get_cell_source_id(0, map_pos)
	var is_in_map = i != -1 
	var good_type = false
	for selector in tile_selectors:
		var is_valid = is_in_map
		var tile_range = 100
		var hop_hover = false
		if selector.has("range"):
			tile_range = selector["range"]
		if selector.has("hop_hover"):
			hop_hover = selector["hop_hover"]
		var from_pos = Vector2i(0,0)
		if selector.has("from_pos"):
			from_pos = selector["from_pos"]
		var current_select_type = selector["type"]
		match(current_select_type):
			select_type.ANY:
				good_type = true
			select_type.FREE_TILE:
				good_type = !is_pos_occupied(map_pos)
			select_type.CREATURE:
				var _crea = get_creature_at_pos(map_pos)
				good_type = is_pos_occupied(map_pos) and _crea.can_be_targeted
			select_type.ENEMY_CREATURE:
				var crea = get_creature_at_pos(map_pos)
				good_type = is_instance_valid(crea) and crea.player != GAME.get_player() and crea.can_be_targeted
			select_type.ALLY_CREATURE:
				var crea = get_creature_at_pos(map_pos)
				good_type = is_instance_valid(crea) and crea.player == GAME.get_player() and crea.can_be_targeted
			select_type.ANY_CREATURE:
				var crea = get_creature_at_pos(map_pos)
				good_type = is_instance_valid(crea)
		is_valid = is_valid and good_type
		if tile_range >= 0:
			var dist = get_dist_between(map_pos, from_pos)
			if hop_hover:
				dist = get_pure_dist_between(map_pos, from_pos)
			is_valid = is_valid and dist <= tile_range
		if is_valid:
			return true
	return false

func get_dist_between(map_pos1, map_pos2):
	if !astar.is_in_boundsv(map_pos1) or !astar.is_in_boundsv(map_pos2):
		return 100000
	var solid1 = astar.is_point_solid(map_pos1)
	var solid2 = astar.is_point_solid(map_pos2)
	astar.set_point_solid(map_pos1, false)
	astar.set_point_solid(map_pos2, false)
	var path = astar.get_id_path(map_pos1, map_pos2)
	astar.set_point_solid(map_pos1, solid1)
	astar.set_point_solid(map_pos2, solid2)
	if path.size() <= 0:
		return 10000
	return path.size() - 1
	
func get_pure_dist_between(map_pos1 : Vector2i, map_pos2: Vector2i):
	return (map_pos1 - map_pos2).length()

func _ready():
	GAME.tile_map = self
	GAME.cancel_selection.connect(_on_cancel_selection)
	astar.size = Vector2i(18+3, 7+2) #MAKE IT DYNAMIC
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	selecting = false
	GAME.turn_changed.connect(_on_turn_changed)

func update_solid_points():
	for i in astar.size.x:
		for j in astar.size.y:
			astar.set_point_solid(Vector2i(i,j), false)
			
	var creatures = get_creatures()
	for crea in creatures:
		astar.set_point_solid(local_to_map(crea.position), true)
		
func _input(event):
	if !selecting or !valid_mouse_pos:
		return
	if event.is_action_pressed("select"):
		selecting = false
		var creature_at_pos = get_creature_at_pos(local_to_map(cursor_pos))
		if creature_at_pos:
			creature_at_pos = creature_at_pos.get_path()
		GAME.target_selected.emit({"position": cursor_pos, "creature": creature_at_pos})

func is_pos_occupied(map_pos : Vector2i) -> bool:
	if get_creature_at_pos(map_pos):
		return true
	return false

func get_creature_at_pos(map_pos) -> Creature:
	var creatures = $Creatures.get_children()
	for creature in creatures:
		if local_to_map(creature.position) == map_pos:
			return creature
	return null
	
func get_creatures():
	return $Creatures.get_children()
	
func get_creatures_around(map_pos, r) -> Array:
	var creatures = GAME.tile_map.get_creatures()
	var in_range_crea = []
	for creature in creatures:
		var crea_pos = GAME.tile_map.local_to_map(creature.position)
		if get_pure_dist_between(map_pos, crea_pos) <= r:
			in_range_crea.append(creature)
	return in_range_crea

	
func _on_cancel_selection():
	selecting = false

func get_tiles_around(pos, r) -> Array:
	var map_tiles = get_used_cells(0)
	var tiles = []
	for tile in map_tiles:
		if get_pure_dist_between(pos, tile) <= r:
			tiles.append(tile)
	return tiles

func get_tiles(info):
	tile_selectors = info
	selecting = true

func add_creature(creature):
	$Creatures.add_child(creature)
	
func _on_turn_changed(_t):
	selecting = false
