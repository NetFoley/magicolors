extends Node2D

@export var dmg = 10
@export var duration = 4
var turn_left = 10

func attach(crea : Creature):
	if crea and crea is Creature:
		crea.damaged.connect(_on_owner_damaged)
		GAME.turn_changed.connect(_on_turn_changed)
		turn_left = duration
		visible = true

func _on_owner_damaged(_value, damager):
	if damager is Creature:
		damager.damage(dmg, self)

func _on_turn_changed(_value):
	turn_left -= 1
	if turn_left <= 0:
		queue_free()
