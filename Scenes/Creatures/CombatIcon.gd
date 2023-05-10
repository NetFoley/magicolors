extends Sprite2D

var start_scale_value = 0.0

## Called when the node enters the scene tree for the first time.
func _ready():
	start_scale_value = scale.y

func appear(value):
	var tween = create_tween()
	if value:
		tween.tween_property(self, "scale:y", start_scale_value, 1.5).from(0.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "scale:y", 0.0, 1.5).from(start_scale_value).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
#		
