extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.time_left_changed.connect(_on_time_left_changed)
	
func _on_time_left_changed(time):
	if str_to_var(text) >= 10.0 and time <= 10.0:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.4,1.4), 0.3).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.3).set_trans(Tween.TRANS_EXPO)
	text = str("%10.1f" % time)
