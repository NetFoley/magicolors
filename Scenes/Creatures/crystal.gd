extends Creature
class_name Crystal

@export var start_player : String
@export var end_turn_life = 3
@export var heal_range = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	player = start_player
	visible = true
	can_move = false
	life = max_life
	max_life = max_life
	GAME.turn_changed.connect(_on_turn_changed)

func _on_turn_changed(turn):
	if GAME.is_our_turn():
		var creatures = GAME.tile_map.get_creatures()
		for creature in creatures:
			var pos = GAME.tile_map.local_to_map(position)
			var crea_pos = GAME.tile_map.local_to_map(creature.position)
			if creature != self and creature.player == player and GAME.tile_map.get_dist_between(pos, crea_pos) < heal_range:
				creature.life += end_turn_life

func die():
	GAME.end_game(self)
	super.die()
