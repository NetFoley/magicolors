extends Control

var current_combinaison = ""

func _ready():
	for child in $VBoxContainer/HBoxContainer.get_children():
		var __ = child.connect("button_down",Callable(self,"_on_input_pressed").bind(child.text))
	var __ = $VBoxContainer/reset.connect("pressed",Callable(self,"reset"))
#	for i in range(1000):
#		get_random_spell()
	
func get_random_spell():
	var comb = ""
	for _i in range(3):
		var rand = randi()%4
		if rand == 0:
			comb += "R"
		elif rand == 1:
			comb += "G"
		elif rand == 2:
			comb += "B"
		elif rand == 3:
			comb += "W"
	var __ = GAME.get_spell(comb)

func _on_input_pressed(value):
	set_combinaison(current_combinaison+value)

func reset():
	set_combinaison("")

func set_combinaison(value):
	current_combinaison = value
	$VBoxContainer/HBoxContainer2/Label2.text = current_combinaison
	$VBoxContainer/HBoxContainer3/spell_output.text = GAME.get_spell_id(value)
