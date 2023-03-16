extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.casted.connect(_on_casted)
	text = ""
	
func _on_casted(spell_name, sender):
	text = (sender + " a lancé " + spell_name + " !")
