extends Node
class_name Spell

@export var spell_id = ""
@export var spell_name = ""
@export var spell_desc = ""
@export var icon : Sprite2D

func launch():
	print("default Launch spell " + spell_id)

func get_targets():
	print("default get targets " + spell_id)

func get_icon():
	return icon.texture
