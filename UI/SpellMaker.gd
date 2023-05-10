extends Control

@export var nb_label : Label
@onready var colors_container = get_node("MarginContainer/VBoxContainer/DropColor")
@onready var spell_label = get_node("MarginContainer/VBoxContainer/SpellName")
@onready var spell_desc = get_node("MarginContainer/VBoxContainer/HBoxContainer2/desc")
@onready var spell_but : Button = get_node("MarginContainer/VBoxContainer/HBoxContainer3/Create")
@onready var close_but : Button = get_node("Close")
@export var capacity = 3
var current_spell = null
var start_pos

var bwr_start_time = 29.8

var nb_of_color = 0:
	set(value):
		nb_of_color = value
		if nb_label:
			nb_label.text = "Lachez votre couleur ici " + var_to_str(nb_of_color) + "/3"

func _ready():
	var __ = GAME.connect("color_drag",Callable(self,"_on_color_drag"))
	nb_of_color = 0
	visible = false
	spell_but.pressed.connect(_on_create_spell)
	close_but.pressed.connect(_close_pressed)
	GAME.turn_changed.connect(_on_turn_changed)
	start_pos = position

func _on_turn_changed(_value):
	if !GAME.is_our_turn():
		clear_colors()
	
func clear_colors():
	for child in colors_container.get_children():
		remove_color(child)

func _close_pressed():
	visible = false
	for child in colors_container.get_children():
		drop_color(child)

func _on_create_spell():
	if !GAME.is_our_turn():
		GAME.error_popup.emit("not_your_turn")
		return
	clear_colors()
	GAME.new_spell.emit(current_spell.spell_id, GAME.get_player())
	visible = false
	$createSpell.play(0.5)

func _on_color_drag():
	update_current_spell()
	if visible == true:
		return
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "position", start_pos, 0.3).from(start_pos + Vector2(0, 500)).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	

# Called when the node enters the scene tree for the first time.
func _on_color_input(event:InputEvent, child):
	if event.is_action_pressed("remove"):
		drop_color(child)
		
func _on_color_second_action(color):
	drop_color(color)
		
func drop_color(child):
	GAME.add_color(child.color)
	remove_color(child)
	
func remove_color(child):
	child.disappear()
	
func _can_drop_data(_position, data):
	var can_drop = data.has("color") and colors_container.get_children().size() < capacity
	if can_drop:
		modulate = Color(1.2, 1.2, 1.2, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	return can_drop
	
func _input(_event):
	modulate = Color(1.0, 1.0, 1.0, 1.0)


#func _drop_data(_position, data):
#	var i = 0
#	for child in colors_container.get_children():
#		if !child.is_visible:
#			set_color(i, data.color)
#			data.button.queue_free()
#			break
#		i +=1
#
#func _drop_data(_position, data):
#	data.button.queue_free()
#	add_child(GAME.get_color_but(data.color))
	
func _drop_data(_position, data):
	if colors_container.get_children().size() >= capacity:
		return
	data.button.disappear()
	var but_inst = GAME.get_color_but(data.color)
	but_inst.connect("second_action", _on_color_second_action.bind(but_inst))
	add_color(but_inst)
	

func add_color(child):
	colors_container.add_child(child)
	child.tree_exited.connect(update_current_spell)
	update_current_spell()

#func set_color(idx, color):
#	if idx >= colors_container.get_children().size():
#		return
#	if color != null:
#		var child : ColorText = colors_container.get_child(idx)
#		child.color = color
#		if child.is_visible == false:
#			child.is_visible = true
#			nb_of_color += 1
#	else:
#		if colors_container.get_child(idx).is_visible:
#			nb_of_color -= 1
#			colors_container.get_child(idx).is_visible = false
	

func get_current_colors() -> String:
	var comb = ""
	for child in colors_container.get_children():
		match(child.color):
			GAME.colorType.BLUE:
				comb += "B"
			GAME.colorType.RED:
				comb += "R"
			GAME.colorType.WHITE:
				comb += "W"
			GAME.colorType.GREEN:
				comb += "G"
	if nb_of_color == 3 and colors_container.get_child(0).color == GAME.colorType.BLUE and colors_container.get_child(1).color == GAME.colorType.WHITE and colors_container.get_child(2).color == GAME.colorType.RED:
		get_node("bluewhitered").play(bwr_start_time)
	else:
		if get_node("bluewhitered").playing:
			bwr_start_time = get_node("bluewhitered").get_playback_position()
			get_node("bluewhitered").stop()
	return comb

func update_current_spell():
	nb_of_color = colors_container.get_children().size()
	var comb = get_current_colors()
	var spell : Spell = GAME.get_spell(GAME.get_spell_id(comb))
	if !can_create_spell(spell):
		spell_label.text = "Pas de sort pour cette combinaison !"
		spell_desc.text = ""
		spell_but.disabled = true
		current_spell = null
		return
	if GAME.spell_cont.get_spell_nb() >= 10:
		spell_label.text = "Impossible de rajouter un sort sans dépasser votre limite de sorts"
		spell_desc.text = "Vous ne pouvez pas stoquer plus de 10 sorts"
		spell_but.disabled = true
		current_spell = null
		return 
	current_spell = spell
	spell_label.text = spell.spell_name
	spell_desc.text = spell.spell_desc
	spell_but.disabled = false

func can_create_spell(spell):
	if !spell:
		return false
		
	return true
