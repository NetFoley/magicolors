extends Container
class_name SpellCont

@export var spell_id : String
@onready var label = $VBOX/HBoxContainer3/Label
@onready var label3 = $VBOX/Label3
@onready var but = $VBOX/HBoxContainer3/Button
@onready var color_text = $VBOX/HBoxContainer/ColorText
@onready var color_text2 = $VBOX/HBoxContainer/ColorText2
@onready var color_text3 = $VBOX/HBoxContainer/ColorText3
# Called when the node enters the scene tree for the first time.
func get_info():
	but.pressed.connect(func(): label3.visible = !label3.visible)
	var spell = GAME.get_spell(spell_id)
	var comb : String = GAME.get_combi_of_spell_id(spell_id)
	label.text = spell.spell_name
	label3.text = spell.spell_desc
	color_text.color = GAME.get_color_type(comb.substr(0, 1))
	color_text2.color = GAME.get_color_type(comb.substr(1, 1))
	color_text3.color = GAME.get_color_type(comb.substr(2, 1))
	

func _ready():
	if GAME.get_spell(spell_id):
		get_info()

