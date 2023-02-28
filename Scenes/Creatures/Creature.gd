extends Node2D
class_name Creature

@export_enum("RED", "GREEN", "BLUE", "WHITE", "BLACK") var color = 0
@export var life = 3
@export var movement = 3
@export var dmg = 1
@export var c_range = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.appear_finished.connect(_spell_tween_finished)

func appear():
	visible = true
	$Sprite.appear()

func _spell_tween_finished():
	$Sprite.play("default")
