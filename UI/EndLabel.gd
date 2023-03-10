extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.end_label = self
	var tween = create_tween()
	tween.tween_property(self, "rotation", 0.2, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_property(self, "rotation", -0.2, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
