extends Node2D

@export var dmg = 7
@export var duration = 4
var turn_left = 10

func attach():
	GAME.turn_changed.connect(_on_turn_changed)
	visible = true
		
func _on_turn_changed(_value):
	var crea : Creature = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(position))
	if crea and crea.can_be_targeted:
		crea.damage(dmg, self)
	turn_left -= 1
	if turn_left <= 0:
		queue_free()
