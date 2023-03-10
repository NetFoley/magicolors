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
	"WWR": "inst_spell",
	"WRW": "inst_spell",
	"RWW": "inst_spell",
	"RGB": "link_crea",
	"RBG": "link_crea",
	"BRG": "link_crea",
	"GRB": "link_crea",
	"GBR": "link_crea",
	"BGR": "link_crea",
	"WGR": "reset_crea",
	"RGW": "reset_crea",
	"GWR": "reset_crea",
	"GRW": "reset_crea",
	"RWG": "reset_crea",
	"WRG": "reset_crea",
	"GBW": "attack_crea",
	"GWB": "attack_crea",
	"WGB": "attack_crea",
	"BGW": "attack_crea",
	"BWG": "attack_crea",
	"WBG": "attack_crea",
	"RBW": "add_reserve",
	"RWB": "add_reserve",
	"WRB": "add_reserve",
	"BRW": "add_reserve",
	"BWR": "add_reserve",
	"WBR": "add_reserve",
}

var spells = [Area2D]

enum colorType{
	RED,
	BLUE,
	GREEN,
	WHITE
}

var spell_cont = null
var COLOR_SIZE = 64
var turn = 0 :
	set(value):
		turn = value
		turn_changed.emit(value)
		
signal turn_changed(value)
signal color_drag()
signal new_spell(spell_id)
signal target_selected(target)
signal selecting(value)
signal cancel_selection()
signal new_creature(creature, player)

var dir_creature_path = "res://Scenes/Creatures/List/"
var creature_list = [Creature]
var dir_spell_path = "res://Spells/List/"
var spell_list = [Spell]
var end_label

var color_container = null

var player1 : Node2D
var player2 : Node2D
var local_player

var tile_map = null

@export_file("*.tscn") var color_but_res

@onready var spells_node = get_node("Spells")
@onready var creatures_node = get_node("Creatures")

var emetter

func _ready():
	load_spells()
	load_creatures()
	target_selected.connect(_on_target_selected)
	var __ = connect("turn_changed", _on_new_turn)
	cancel_selection.connect(_on_cancel_selection)
	
	
func get_player() -> String:
	if NETWORK.side == "Server":
		return "Player1"
	else:
		return "Player2"
	if local_player:
		return local_player
	return "Player1"
	
func get_player_object(player : String) -> Node:
	if player == "Player1":
		return player1
	if player == "Player2":
		return player2
	push_error("Invalid player string")
	return player1
	
func get_mental_capacity(player : Node) -> int:
	var cap = 5
	if is_instance_valid(player):
		cap -= player.creatures.size()
	return cap 
	
func is_our_turn():
	var mod = (turn % 2)
	if get_player() == "Player1":
		return mod == 1
	else:
		return mod == 0
	return false
	
func spawn_creature(color, pos, player):
	for child in creatures_node.get_children():
		if child.color == color:
			var crea = child.duplicate()
			crea.visible = true
			crea.player = player
			tile_map.add_creature(crea)
			var player_obj = get_player_object(player)
			player_obj.creatures.append(crea)
			crea.set_multiplayer_authority(multiplayer.get_remote_sender_id())
			crea.appear()
			crea.global_position = Vector2(pos)
			new_creature.emit(crea, player)
			return crea
	return null
	
func add_color(color):
	if !color_container or color_but_res == "":
		return
	var color_inst = get_color_but(color)
	color_container.add_child(color_inst)
	
func _on_new_turn(_value):
	if !color_container:
		return
	
	for child in color_container.get_children():
		child.disappear()
	for i in range(10):
		add_color(randi()%4)
	
func get_color_but(color):
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
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".tscn"):
					print("Found tscn: " + file_name)
					var file_path = dir_creature_path + file_name
					var scene = load(file_path)
					var inst = scene.instantiate()
					creatures_node.add_child(inst)
					print(inst.name)
			file_name = dir.get_next()
	
	
func load_spells():
	var dir = DirAccess.open(dir_spell_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".tscn"):
					print("Found tscn: " + file_name)
					var file_path = dir_spell_path + file_name
					var scene = load(file_path)
					var inst = scene.instantiate()
					spells_node.add_child(inst)
					print(inst.name)
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
		print(combinaison + " ne correspond à aucun sort.")
		return ""

func get_spell(id):
	for spell in spells_node.get_children():
		if spell.spell_id == id:
			print("Found ! " + spell.name)
			return spell

func get_targets(info : Dictionary):
	if !tile_map:
		return
	GAME.selecting.emit(true)
	tile_map.get_tiles(info)
	
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
