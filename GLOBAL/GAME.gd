extends Node

# Table de correspondance sort-éléments
var sort_elements = {
	"RRR": "fire_ball",
	"GGG": "invoc_reserve",
	"BBB": "heal_cryst",
	"WWW": "make_reserve",
	"RRB": "fire_shield",
	"RBR": "fire_shield",
	"BRR": "fire_shield",
	"RRW": "fire_ground",
	"RWR": "fire_ground",
	"WRR": "fire_ground",
	"RRG": "fire_damage",
	"RGR": "fire_damage",
	"GRR": "fire_damage",
	"BBR": "move_crea",
	"BRB": "move_crea",
	"RBB": "move_crea",
	"BBG": "heal_crea",
	"BGB": "heal_crea",
	"GBB": "heal_crea",
	"BBW": "make_wall",
	"BWB": "make_wall",
	"WBB": "make_wall",
	"GGB": "invoc_blue",
	"GBG": "invoc_blue",
	"BGG": "invoc_blue",
	"GGW": "invoc_white",
	"GWG": "invoc_white",
	"WGG": "invoc_white",
	"GGR": "invoc_red",
	"GRG": "invoc_red",
	"RGG": "invoc_red",
	"WWB": "draw_reserve",
	"WBW": "draw_reserve",
	"BWW": "draw_reserve",
	"WWG": "take_crea",
	"WGW": "take_crea",
	"GWW": "take_crea",
	"WWR": "take_spell",
	"WRW": "take_spell",
	"RWW": "take_spell",
	"RGB": "link_crea",
	"RBG": "link_crea",
	"BRG": "link_crea",
	"GRB": "link_crea",
	"GBR": "link_crea",
	"BGR": "link_crea",
	"WGR": "buff_crea",
	"RGW": "buff_crea",
	"GWR": "buff_crea",
	"GRW": "buff_crea",
	"RWG": "buff_crea",
	"WRG": "buff_crea",
	"GBW": "attack_crea",
	"GWB": "attack_crea",
	"WGB": "attack_crea",
	"BGW": "attack_crea",
	"BWG": "attack_crea",
	"WBG": "attack_crea",
	"RBW": "reset_crea",
	"RWB": "reset_crea",
	"WRB": "reset_crea",
	"BRW": "reset_crea",
	"BWR": "reset_crea",
	"WBR": "reset_crea",	
}

var spells = []

enum colorType{
	RED,
	GREEN,
	BLUE,
	WHITE,
	BLACK
}

var nb_of_colors = {}
var color_spawned = {}
var spell_cont = null
var COLOR_SIZE = 64
var turn = 0 :
	set(value):
		turn = value
		turn_changed.emit(value)
		
signal time_left_changed(time)
signal casted(spell_name, player_name)
signal error_popup(text)
signal turn_changed(value)
signal color_drag()
signal new_spell(spell : String, player)
signal old_spell(spell : String, player)
signal target_selected(target)
signal selecting(value)
signal cancel_selection()
signal new_creature(creature, player)

var player_turn_time = 60.0
var dir_creature_path = "res://Scenes/Creatures/List/"
var creature_list = [Creature]
var dir_spell_path = "res://Spells/List/"
var spell_list = [Spell]
var end_label

var color_container = null
var color_reserve = null

var player1 : Node2D
var player2 : Node2D
var local_player

var tile_map = null

@export_file("*.tscn") var color_but_res

@onready var spells_node = get_node("Spells")
@onready var creatures_node = get_node("Creatures")

var emetter

func _ready():
#	load_spells()
#	load_creatures()
	setup_crea_colors()
	target_selected.connect(_on_target_selected)
	var __ = connect("turn_changed", _on_new_turn)
	cancel_selection.connect(_on_cancel_selection)
	$Timer.timeout.connect(_on_timer_timeout)
	
func setup_crea_colors():
	var creatures = get_creatures()
	for crea in creatures:
		if nb_of_colors.has(crea.color):
			nb_of_colors[crea.color] += 1
		else:
			nb_of_colors[crea.color] = 1
		
	
func get_color_type(color : String):
	match(color):
		"R":
			return colorType.RED
		"G":
			return colorType.GREEN
		"B":
			return colorType.BLUE
		"W":
			return colorType.WHITE
		"B":
			return colorType.BLACK
	
func _physics_process(_delta):
	if $Timer.is_stopped():
		return
		
	time_left_changed.emit($Timer.time_left)
	
@rpc("reliable", "call_local", "any_peer")
func go_next_turn():
	GAME.turn += 1
	
func _on_timer_timeout():
	if !is_our_turn():
		return
	rpc("go_next_turn")
	
func get_combi_of_spell_id(id) -> String :
	var keys = sort_elements.keys()
	for key in keys:
		var value = sort_elements[key]
		if value == id:
			return key
	return ""
	
func get_spells():
	return $Spells.get_children()
	
func get_creatures():
	return $Creatures.get_children()
	
func get_reserve_color():
	if color_reserve and color_reserve.get_child_count() > 0:
		return color_reserve.get_child(0).color
	return null
	
func get_player() -> String:
	if NETWORK.side == "Server":
		return "Player1"
	else:
		return "Player2"
#	return "Player1"
	
func get_player_object(player : String) -> Node:
	if player == "Player1":
		return player1
	if player == "Player2":
		return player2
	return null
	
func get_mental_capacity(player : Node) -> float:
	var cap = 5.0
	if is_instance_valid(player):
		for crea in player.creatures:
			cap -= crea.mental_cap_cost
	return cap 
	
func get_crystals():
	var crystals = []
	for crea in tile_map.get_creatures():
		if crea is Crystal:
			crystals.append(crea)
	return crystals
	
func get_crystal(player):
	var crystals = get_crystals()
	for crystal in crystals:
		if crystal.player == player:
			return crystal
	return null
	
func is_our_turn():
	var mod = (turn % 2)
	if get_player() == "Player1":
		return mod == 1
	else:
		return mod == 0
#	return false
func get_player_turn():
	var mod = (turn % 2)
	if mod == 1:
		return "Player1"
	else:
		return "Player2"
	
func get_random_color():
	var color = colorType.RED
	var rd = randi_range(0, 2)
	match(rd):
		0:
			color = colorType.RED
		1:
			color = colorType.BLUE
		2:
			color = colorType.WHITE
	return color
	
func spawn_creature(color, pos, player):
	var color_found = 0
	var crea_nb = 1
	if nb_of_colors.has(color) and color_spawned.has(color):
		crea_nb = color_spawned[color] % nb_of_colors[color] + 1
	for child in creatures_node.get_children():
		if child.color == color:
			color_found += 1
			if color_found == crea_nb:
				var crea = child.duplicate()
				add_creature_to_tilemap(crea, pos, player)
				if color_spawned.has(color):
					color_spawned[color] += 1
				else:
					color_spawned[color] = 1
				return crea
	return null
	
func add_creature_to_tilemap(crea, pos, player):
	crea.visible = true
	crea.player = player
	tile_map.add_creature(crea)
	var player_obj = get_player_object(player)
	if player_obj:
		player_obj.creatures.append(crea)
	crea.set_multiplayer_authority(multiplayer.get_remote_sender_id())
	crea.name = player
	crea.appear()
	crea.global_position = Vector2(pos)
	new_creature.emit(crea, player)
	
func add_color(color):
	if !color_container or color_but_res == "":
		return
	var color_inst = get_color_but(color)
	color_container.add_child(color_inst)
	
func _on_new_turn(_value):
	$Timer.start(player_turn_time)
	if turn < 3:
		$Timer.start(player_turn_time*1.5)
	if !color_container:
		return
	
	
func get_color_but(color):
	if color_but_res == "" :
		return null
	var color_scene = load(color_but_res)
	var color_inst = color_scene.instantiate()
	color_inst.color = color
	return color_inst
	
	
func load_creatures():
	var dir = DirAccess.open(dir_creature_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
#				print("Found file: " + file_name)
				if file_name.ends_with(".tscn"):
#					print("Found tscn: " + file_name)
					var file_path = dir_creature_path + file_name
					var scene = load(file_path)
					var inst = scene.instantiate()
					creatures_node.add_child(inst)
#					print(inst.name)
			file_name = dir.get_next()
	
	
func load_spells():
	var dir = DirAccess.open(dir_spell_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.ends_with(".tscn"):
#					print("Found tscn: " + file_name)
					var file_path = dir_spell_path + file_name
					var scene = load(file_path)
					var inst = scene.instantiate()
					spells_node.add_child(inst)
#					print(inst.name)
			file_name = dir.get_next()


# Vérifier si le joueur a sélectionné la bonne combinaison d'éléments
func get_spell_id(elements) -> String:
	var combinaison = ""
	if elements is Array:
		if elements.size() == 3 and "element1" in elements and "element2" in elements and "element3" in elements:
			combinaison = elements[0] + elements[1] + elements[2]
		else:
			print("Vous devez sélectionner les éléments 1, 2 et 3 pour lancer un sort.")
			return ""
	else:
		combinaison = elements
	if combinaison in sort_elements:
		var sort_a_lancer = sort_elements[combinaison]
		return sort_a_lancer
	else:
		return ""

func get_spell(id):
	for spell in spells_node.get_children():
		if spell.spell_id == id:
			return spell

func get_targets(infos):
	if !tile_map:
		return
	GAME.selecting.emit(true)
	tile_map.get_tiles(infos)
	
func end_game(crystal):
	if crystal.player == get_player():
		end_label.text = "DEFAITE"
	else:
		end_label.text = "VICTOIRE"
	end_label.visible = true

func _on_target_selected(target):
	selecting.emit(false)
	emetter.target_selected(target)

func _on_cancel_selection():
	selecting.emit(false)
