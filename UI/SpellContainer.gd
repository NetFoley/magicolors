extends Container


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.new_spell.connect(_on_new_spell)
	GAME.old_spell.connect(_on_old_spell)
	GAME.casted.connect(update_label)
	
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
	await get_tree().process_frame
	var nb_spells = 0
	nb_spells += $SpellFlow/VBoxContainer2/ReadySpells.get_child_count() + $SpellFlow/VBoxContainer/UnreadySpells.get_child_count()
	$VBoxContainer/SpellCount.text = "Capacité mentale : " + var_to_str(nb_spells) + "/" + "10"
	
