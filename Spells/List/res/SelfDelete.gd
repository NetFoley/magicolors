extends Node2D


@export var duration = 1
var turn_left = 1
var crea_tar : Creature = null

func attach(crea : Creature):
	if crea and crea is Creature:
		crea_tar = crea
		GAME.turn_changed.connect(_on_turn_changed)
		turn_left = duration
		visible = true

func _on_turn_changed(_value):
	turn_left -= 1
	if turn_left <= 0:
		crea_tar.queue_free()
		queue_free()
