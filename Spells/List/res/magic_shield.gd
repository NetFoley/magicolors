extends Node2D

@export var bonus = 3
@export var duration = 6
var turn_left = 1
var crea_tar : Creature = null

func attach(crea : Creature):
	if crea and crea is Creature:
		crea_tar = crea
		crea_tar.can_be_targeted = false
		GAME.turn_changed.connect(_on_turn_changed)
		turn_left = duration
		visible = true

func _on_turn_changed(_value):
	turn_left -= 1
	if turn_left <= 0:
		crea_tar.can_be_targeted = true
		queue_free()
