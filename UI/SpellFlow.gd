extends HFlowContainer

var current_but = null
var current_spell = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.cancel_selection.connect(_on_cancel_selection)
	__ = GAME.turn_changed.connect(_on_turn_changed)
	GAME.spell_cont = self

func _on_turn_changed(_value):
	if !GAME.is_our_turn():
		return
		
	var cap = GAME.get_mental_capacity(GAME.player1) # - NB OF CREATURE (TODO)
	var readied = 0
	var i = 0
	while(readied < cap and i < get_child_count()):
		var child = get_child(i)
		if child and child.disabled:
			child.disabled = false
			readied += 1
		i += 1
	
		
func _on_cancel_selection():
	current_but = null
	current_spell = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_new_spell(spell: Spell):
	var spell_but = Button.new()
#	spell_but.icon = spell.get_icon() TODO
	spell_but.text = spell.spell_name
	spell_but.tooltip_text = spell.spell_desc
	spell_but.pressed.connect(_on_but_pressed.bind(spell_but, spell))
	spell_but.custom_minimum_size = Vector2(64,64)
	spell_but.disabled = true
	add_child(spell_but)
	
func _on_but_pressed(but, spell: Spell):
	if GAME.is_our_turn(): #CHECK WHICH PLAYER
		current_spell = spell
		current_but = but
		spell.get_target()
		GAME.emetter = self

func target_selected(target):
	if !current_spell:
		return
	var player_obj = GAME.get_player_object(GAME.get_player())
	player_obj.rpc("cast", current_spell.spell_id, target)
	current_but.queue_free()
	remove_child(current_but)
	current_but = null
	current_spell = null
	get_parent().update_label()
	
