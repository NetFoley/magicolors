extends Node2D

@export var duration = 2
var turn_left = 2
var crea_tar : Creature = null

func attach(crea : Creature):
	if crea and crea is Creature:
		crea_tar = crea
		crea.can_move_changed.connect(_move_changed)
		GAME.turn_changed.connect(_on_turn_changed)
		turn_left = duration
		visible = true

func _move_changed(value):
	if value and crea_tar:
		crea_tar.can_move = false

func _on_turn_changed(_value):
	turn_left -= 1
	if turn_left <= 0:
		queue_free()
