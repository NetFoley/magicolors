extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = GAME.new_spell.connect(_on_new_spell)
	__ = GAME.target_selected.connect(_on_target_selected)
	
func _on_new_spell(_spell):
	get_node("SpellFlow")._on_new_spell(_spell)
	update_label()

func _on_target_selected(target):
	get_node("SpellFlow")._on_target_selected(target)
	update_label()
	
func update_label():
	$SpellCount.text = var_to_str(get_node("SpellFlow").get_child_count()) + "/" + var_to_str(GAME.get_mental_capacity())
	
