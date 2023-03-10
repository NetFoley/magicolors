extends Node
class_name Spell

@export var spell_id = ""
@export var spell_name = ""
@export var spell_desc = ""
@export var icon : Sprite2D

func launch(_target, _sender : String):
	print("default Launch spell " + spell_id)

func get_target():
	GAME.selecting.emit(true)
	print("default get targets " + spell_id)

func get_icon():
	return icon.texture
