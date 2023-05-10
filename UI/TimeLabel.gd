extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.time_left_changed.connect(_on_time_left_changed)
	
func _on_time_left_changed(time):
	var o_time = str_to_var(text)
	if GAME.is_our_turn() and (o_time >= 11 and time <= 11 or time <= 6 and o_time >= 6 or time <= 3 and o_time >= 3 or time <= 2 and o_time >= 2):
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.5,1.5), 0.3).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.3).set_trans(Tween.TRANS_EXPO)
		var tween2 = create_tween()
		tween2.tween_callback(set_modulate.bind(Color(1,0,0))).set_delay(0.05)
		tween2.tween_callback(set_modulate.bind(Color(1,1,1))).set_delay(0.05)
		tween2.set_loops(3)

	text = str("%10.0f" % time)
