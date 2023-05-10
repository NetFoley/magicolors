extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if GAME.get_player() == "Player2":
		position = Vector2(380, 20)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 0.5).from(Vector2(0,0)).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2(1,1), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2(3,3), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2(55,55), 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
#	tween.set_loops()
