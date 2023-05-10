extends Container

var current_but = null
var current_spell = null

signal old_spell

# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.cancel_selection.connect(_on_cancel_selection)
	__ = GAME.turn_changed.connect(_on_turn_changed)
	GAME.spell_cont = self
	GAME.rdy_last_spell.connect(rdy_last_spell)

func _on_turn_changed(_value):
	if !GAME.is_our_turn():
		return
		
	var _cap = GAME.get_mental_capacity(GAME.get_player_object(GAME.get_player())) 
	for child in $VBoxContainer/UnreadySpells.get_children():
		ready_spell(child)
		
func ready_spell(spell):
	if spell and spell.disabled:
		spell.reparent($VBoxContainer2/ReadySpells)
		spell.disabled = false
		
func rdy_last_spell():
	ready_spell($VBoxContainer/UnreadySpells.get_child($VBoxContainer/UnreadySpells.get_child_count() - 1))
	
func get_spell_nb():
	return $VBoxContainer2/ReadySpells.get_child_count() + $VBoxContainer/UnreadySpells.get_child_count()
	
func _on_cancel_selection():
	current_but = null
	current_spell = null

func _on_new_spell(spell: Spell):
	var spell_but = Button.new()
#	spell_but.icon = spell.get_icon() TODO
	spell_but.text = spell.spell_name
	spell_but.tooltip_text = spell.spell_desc
	spell_but.pressed.connect(_on_but_pressed.bind(spell_but, spell))
	spell_but.custom_minimum_size = Vector2(64,64)
	spell_but.disabled = true
	spell_but.gui_input.connect(_on_but_gui_input.bind(spell_but))
	$VBoxContainer/UnreadySpells.add_child(spell_but)
	
func _on_but_pressed(but, spell: Spell):
	if GAME.is_our_turn() and spell.can_be_casted(): #CHECK WHICH PLAYER
		current_spell = spell
		current_but = but
		spell.get_target()
		GAME.emetter = self

func target_selected(target):
	if !current_spell:
		return
	var player_obj = GAME.get_player_object(GAME.get_player())
	player_obj.rpc("cast", current_spell.spell_id, target)
#	current_but.queue_free()
	current_but = null
	current_spell = null
	get_parent().update_label()
	
func remove_spell(n):
	for child in $VBoxContainer2/ReadySpells.get_children():
		if child.text == n:
			child.queue_free()
			break
	for child in $VBoxContainer/UnreadySpells.get_children():
		if child.text == n:
			child.queue_free()
			break

func _on_but_gui_input(event, but : Button):
	if event is InputEventMouseButton and but.disabled:
		GAME.error_popup.emit("unrdyspell")
