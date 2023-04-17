extends Node
class_name Spell

@export var spell_id = ""
@export var spell_name = ""
@export var spell_desc = ""
@export var icon : Sprite2D

func launch(_target, _sender : String):
	print("default Launch spell " + spell_id)

func get_target():
	GAME.get_targets([{"type": GAME.tile_map.select_type.ANY}])

func get_icon():
	return icon.texture

func can_be_casted() -> bool:
	return true
