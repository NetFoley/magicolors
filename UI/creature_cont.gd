extends PanelContainer

var crea : Creature
@onready var namel = $VBoxContainer/HBoxContainer/Name
@onready var viel = $VBoxContainer/HBoxContainer2/LValue
@onready var dmgl = $VBoxContainer/HBoxContainer3/LValue
@onready var porl = $VBoxContainer/HBoxContainer4/LValue
@onready var depl = $VBoxContainer/HBoxContainer5/LValue
@onready var capl = $VBoxContainer/HBoxContainer6/LValue
@onready var partl = $VBoxContainer/HBoxContainer7/LValue
@onready var icon = $VBoxContainer/HBoxContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	if crea:
		get_info()
		
func get_info():
	if !crea:
		return
	namel.text = str(crea.name)
	viel.text = str(crea.max_life)
	dmgl.text = str(crea.dmg)
	porl.text = str(crea.c_range)
	depl.text = str(crea.movement)
	capl.text = str(crea.mental_cap_cost)
	partl.text =str(crea.particularity_desc)
	icon.texture = crea.get_texture()
