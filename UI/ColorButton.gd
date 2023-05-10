@tool
extends Container
class_name ColorButton

signal second_action()

var only_on_our_turn = false
@onready var color_text = get_node("Color")

@export var color = GAME.colorType.RED: 
	set(value): # (GAME.colorType)
		color = value
		if color_text:
			color_text.color = value
		
func _ready():
	if color_text:
		color_text.color = color

func _get_drag_data(_position):
	if only_on_our_turn and !GAME.is_our_turn():
		GAME.error_popup.emit("not_your_turn")
		return null
	var cpb = color_text.duplicate()
	cpb.modulate.a *= 0.5
	$Pick.play()

	GAME.emit_signal("color_drag")
	set_drag_preview(cpb)
	return {"color" : color, "button" : self}

func disappear():
	$Drop.play()
	color_text.disappear()
	color_text.tween.finished.connect(queue_free)

func _gui_input(event):
	if event.is_action_pressed("remove") or event is InputEventMouseButton and event.double_click:
		$Pick.play()
		second_action.emit()
		
