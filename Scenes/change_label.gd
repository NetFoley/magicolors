extends Node2D
var value = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_timeout)
	
func appear():
	$Timer.start()
	if !is_inside_tree():
		return
	visible = true
	if value > 0:
		$changeLabel.text = "+"+str(value)
		modulate = Color(0.4,0.4,1)
	else:
		$changeLabel.text = str(value)
		modulate = Color(1,0.4,0.4)
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 100), 2.0).set_ease(Tween.EASE_IN)
	tween2.tween_property($changeLabel, "modulate", Color(1,1,1, 0.0), 2.0).set_ease(Tween.EASE_IN)

func _on_timeout():
	queue_free()
