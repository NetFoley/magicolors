@tool
extends TextureRect
class_name ColorText

@export var COLORSIZE = 64
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
				$Label.text = "R"
			GAME.colorType.GREEN:
				modulate = Color(0.4, 1, 0.4)
				$Label.text = "G"
			GAME.colorType.BLUE:
				modulate = Color(0.4, 0.4, 1)
				$Label.text = "B"
			GAME.colorType.WHITE:
				modulate = Color(1.0, 1, 1)
				$Label.text = "W"

func appear():
	var end_val = Vector2(COLORSIZE, COLORSIZE)
	$GPUParticles2D.position = Vector2(COLORSIZE/2.0, COLORSIZE/2.0)
	$GPUParticles2D.scale = Vector2(COLORSIZE/64.0, COLORSIZE/64.0)
	$GPUParticles2D2.scale = Vector2(COLORSIZE/64.0, COLORSIZE/64.0)
	$GPUParticles2D2.position = Vector2(COLORSIZE/2.0, COLORSIZE/2.0)
	$Label.scale = Vector2(COLORSIZE/64.0, COLORSIZE/64.0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "custom_minimum_size", end_val, 0.3).from(Vector2(0,0))
	$GPUParticles2D.emitting = true

func disappear():
	var end_val = Vector2(0,0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "custom_minimum_size", end_val, 0.05)
	
func _enter_tree():
	if is_visible:
		appear()
