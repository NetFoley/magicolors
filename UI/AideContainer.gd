extends VBoxContainer

var res = preload("res://UI/spell_cont.tscn")
var res_crea = preload("res://UI/creature_cont.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.toggled.connect(_on_toggled)
	load_all_spells()
	load_all_creatures()
	GAME.turn_changed.connect(_on_turn_changed)
	$Button.set_pressed(false)
	_on_toggled(false)
	
func _on_turn_changed(_turn):
	if _turn > 2:
		return
	var tween = create_tween()
	tween.tween_property($Button, "modulate", Color(4.0,4.0,4.0), 0.1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Button, "modulate", Color(1.0,1.0,1.0), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.set_loops(4)
	
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

func _unhandled_input(event):
	if event is InputEventMouseButton:
		$Button.set_pressed(false)
