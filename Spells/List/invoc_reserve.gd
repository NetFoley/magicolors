extends Spell


# Called when the node enters the scene tree for the first time.


func launch(target):
	var crea = GAME.spawn_creature(0)
	GAME.get_player().add_child(crea)
	crea.appear()
	crea.global_position = Vector2(target)

func get_target():
	GAME.get_tile()
