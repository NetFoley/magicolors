extends Container


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.new_spell.connect(_on_new_spell)
	GAME.old_spell.connect(_on_old_spell)
	GAME.new_creature.connect(update_label)
	
func _on_old_spell(spell_id, player):
	if !player == GAME.get_player():
		return
	var spell = GAME.get_spell(spell_id)
	get_node("SpellFlow").remove_spell(spell.spell_name)
	update_label()
	
func _on_new_spell(_spell, player):
	if !player == GAME.get_player():
		return
	var spell = GAME.get_spell(_spell)
	get_node("SpellFlow")._on_new_spell(spell)
	update_label()

func _on_target_selected(target):
	get_node("SpellFlow")._on_target_selected(target)
	update_label()
	
func update_label(_crea = null, _player = null):
	$VBoxContainer/SpellCount.text = var_to_str(get_node("SpellFlow").get_child_count()) + "/" + var_to_str(GAME.get_mental_capacity(GAME.get_player_object(GAME.get_player())))
	
