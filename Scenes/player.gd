@tool
extends Node2D
class_name Player

@onready var anim_spr : AnimatedSprite2D = get_node("AnimNode/AnimatedSprite2D2")
@onready var staff_spr : Node2D = get_node("AnimNode/Node2D")
@export var flipped = false:
	set(value):
		flipped = value
		if anim_spr and staff_spr:
			anim_spr.flip_h = value
			anim_spr.material.set_shader_parameter("redded", value)
			if value:
				staff_spr.position = Vector2(-10, -18)
				staff_spr.scale = Vector2(1, 1)
			else:
				staff_spr.position = Vector2(10,-18)
				staff_spr.scale = Vector2(-1, 1)

var creatures = []

func _ready():
	$AnimNode/AnimatedSprite2D2/AnimationPlayer.play("Idle")
	flipped = flipped
	if Engine.is_editor_hint():
		return
	if flipped:
		GAME.player2 = self
	else:
		GAME.player1 = self

@rpc("reliable", "any_peer", "call_local")
func cast(spell_id, target):
	var spell = GAME.get_spell(spell_id)
	print(name + " casted " + spell.name + " !")
	$AnimNode/Node2D/Sprite2D/AnimationPlayer.play("Cast")
	spell.launch(target, name)
