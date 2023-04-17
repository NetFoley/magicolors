extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0.5, 0.4, 0.7, 0.6), 0.3).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_trans(Tween.TRANS_CIRC)
	tween.set_loops()

func _draw():
	if get_parent().selecting:
		var cells = get_parent().get_used_cells(0)
		for cell in cells:
			var c_size = get_parent().cell_quadrant_size*0.1
			if get_parent().is_tile_valid(cell):
				draw_circle(Vector2(get_parent().map_to_local(cell)-Vector2(0.0,1.0)*1.0), c_size, Color(0.85,0.9,1.0, 1.0))
