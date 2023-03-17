extends VBoxContainer

var res = preload("res://UI/spell_cont.tscn")
var res_crea = preload("res://UI/creature_cont.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.toggled.connect(_on_toggled)
	_on_toggled(false)
	load_all_spells()
	load_all_creatures()
	
func _on_toggled(value):
	$TabContainer.visible = value

func load_all_spells():
	var spells = GAME.get_spells()
	for spell in spells:
		var sc = res.instantiate()
		sc.spell_id = spell.spell_id
		$TabContainer/Sorts/ScrollContainer/VBoxContainer.add_child(sc)

func load_all_creatures():
	var spells = GAME.get_creatures()
	for spell in spells:
		var sc = res_crea.instantiate()
		sc.crea = spell
		$TabContainer/Creatures/ScrollContainer/VBoxContainer.add_child(sc)
