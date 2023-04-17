extends PopupPanel

var dic = {
	"not_your_turn": "Ce n'est pas votre tour ! \nVous pouvez voir le temps restant en bas à droite et l'aide de jeu en haut à droite.",
	"need_reserve": "Ce sort a besoin d'une couleur dans votre réserve en bas à gauche !",
	"crea_cant_move": "Cette créature est fatigué est n'est pas capable d'actions ce tour !"
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.error_popup.connect(_on_error_popup)
	
func _on_error_popup(t):
	if dic.has(t):
		$Label.text = dic[t]
	else:
		$Label.text = t + " unassigned"
	visible = true
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0.6, 0.1, 0.1, 1.0), 0.2).from(Color(1.0,0.3,0.3,0.9)).set_trans(Tween.TRANS_ELASTIC)
