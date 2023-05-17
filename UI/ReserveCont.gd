extends VBoxContainer

@export var can_eat = true
const START_COST = 2
var eaten_colors = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.turn_changed.connect(_on_new_turn)
	if can_eat:
		GAME.creature_color_cont = self
	else:
		GAME.reserve_cont = $Reserve/ReserveColors
		
	
func _on_new_turn(_turn):
	if !GAME.is_our_turn():
		return
	if $Reserve/ReserveColors.get_child_count() <= 0:
		update_label()
		return
	eat_color()
	
func get_color_qty() -> int:
	return $Reserve/ReserveColors.get_child_count()
	
func eat_color():
	if !can_eat:
		return
	var color_but : ColorButton = $Reserve/ReserveColors.get_child($Reserve/ReserveColors.get_child_count() -1)
	eaten_colors.append(color_but.color)
	var sacr_left = get_sacr_left()
	color_but.disappear()
	if sacr_left <= 0:
		var crystal_pos = GAME.tile_map.local_to_map(GAME.get_crystal(GAME.get_player()).position)
		var closest_tile = GAME.tile_map.get_closest_free_tile(crystal_pos)
		spawn_creature.rpc(eaten_colors[randi()%eaten_colors.size()], GAME.get_player(), closest_tile)
		eaten_colors.clear()
	update_label()
	
@rpc("any_peer", "call_local", "reliable")
func spawn_creature(color, player, tile):
	GAME.spawn_creature(color, GAME.tile_map.map_to_local(tile), player)

func update_label():
	if !can_eat:
		return
	$Label2.text = "Créature dans " + str(get_sacr_left())
	
func get_sacr_left():
	return START_COST + GAME.get_current_mental_cost(GAME.get_player_object(GAME.get_player())) - eaten_colors.size()
	
