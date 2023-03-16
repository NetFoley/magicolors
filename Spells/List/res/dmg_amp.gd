extends Node2D

@export var dmg = 10
@export var duration = 20
var turn_left = 10
var own : Creature = null

func attach(crea : Creature):
	if crea and crea is Creature:
		own = crea
		crea.attacked.connect(_on_attacked)
		GAME.turn_changed.connect(_on_turn_changed)
		turn_left = duration
		visible = true

func _on_attacked(value, target):
	target.damage(value, own)
	queue_free()

func _on_turn_changed(_value):
	turn_left -= 1
	if turn_left <= 0:
		queue_free()
