@tool
extends TextureRect
class_name ColorText

const COLORSIZE = 64
var tween = null

@export var is_visible = true:
	set(value):
		if is_visible != value:
			is_visible = value
			if !is_inside_tree():
				return
			if value:
				appear()
			else:
				disappear()

@export var color = GAME.colorType.RED :
	set(value): # (GAME.colorType)
		color = value
		match(value):
			GAME.colorType.RED:
				modulate = Color(1.0, 0.4, 0.4)
			GAME.colorType.GREEN:
				modulate = Color(0.4, 1, 0.4)
			GAME.colorType.BLUE:
				modulate = Color(0.4, 0.4, 1)
			GAME.colorType.WHITE:
				modulate = Color(1.0, 1, 1)

func appear():
	var end_val = Vector2(COLORSIZE, COLORSIZE)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "custom_minimum_size", end_val, 0.3).from(Vector2(0,0))

func disappear():
	var end_val = Vector2(0,0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "custom_minimum_size", end_val, 0.05)
	
func _enter_tree():
	if is_visible:
		appear()
