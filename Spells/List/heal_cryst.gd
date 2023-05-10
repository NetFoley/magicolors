extends Spell

# Called when the node enters the scene tree for the first time.
func launch(_target, sender):
	var creatures = GAME.tile_map.get_creatures()
	for crea in creatures:
		if crea is Crystal and crea.player == sender:
			crea.life += 15
	

func get_target():
	GAME.validation_popup.emit(spell_name)
