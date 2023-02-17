extends AnimatedSprite2D

signal appear_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func appear():
	var tween = create_tween()
	tween.tween_method(set_gen_value, 0.6, 0.75, 2.0).set_ease(Tween.EASE_OUT)
	tween.finished.connect(emit_signal.bind("appear_finished"))

func set_gen_value(value):
	material.set_shader_parameter("gen", value)
