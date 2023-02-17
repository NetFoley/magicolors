extends HFlowContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.new_spell.connect(_on_new_spell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_new_spell(spell: Spell):
	var spell_but = Button.new()
#	spell_but.icon = spell.get_icon() TODO
	spell_but.text = spell.spell_name
	spell_but.pressed.connect(_on_but_pressed.bind(spell_but, spell))
	spell_but.custom_minimum_size = Vector2(64,64)
	add_child(spell_but)
	
func _on_but_pressed(but, spell: Spell):
	if false: #CHECK CAN LAUNCH
		return
	if GAME.is_our_turn(): #CHECK WHICH PLAYER
		GAME.player1.cast(spell)
		but.queue_free()
