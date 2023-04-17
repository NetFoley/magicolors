extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.turn_changed.connect(_on_turn_changed)

func _on_turn_changed(_turn):
	if GAME.is_our_turn():
		appear()

func appear():
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "anchor_top", 0.5, 1.0).from(-0.2).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "anchor_top", 1.0, 2.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	var tween2 = create_tween()
	tween2.tween_property(self, "anchor_bottom", 0.5, 1.0).from(-0.2).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "anchor_bottom", 1.0, 2.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	var tween3 = create_tween()
	tween3.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.35).from(Color(1.0,1.0,1.0,-0.3))
	tween3.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0)
	tween3.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, -1.0), 1.0)
