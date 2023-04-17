extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.casted.connect(_on_casted)
	text = ""
	
func _on_casted(spell_name, sender):
	text += "\n" + "[Tour " + str(GAME.turn) + "] " +sender + " a lancé " + spell_name + " !"
	await get_tree().process_frame
	get_parent().scroll_vertical += 150
