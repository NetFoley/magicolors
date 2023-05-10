extends Creature
class_name Crystal

@export var start_player : String
@export var end_turn_life = 5
@export var heal_range = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	player = start_player
	visible = true
	life = max_life
	max_life = max_life

func _on_turn_changed(_turn):
	if GAME.get_player_turn() == player:
		var pos = GAME.tile_map.local_to_map(position)
		var creatures = GAME.tile_map.get_creatures_around(pos, heal_range)
		for creature in creatures:
			if creature != self and creature.player == player:
				creature.life += end_turn_life

func die():
	GAME.end_game(self)
	super.die()
