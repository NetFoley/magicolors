extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if get_parent().selecting:
		var cells = get_parent().get_used_cells(0)
		for cell in cells:
			var c_size = get_parent().cell_quadrant_size*0.1
			if get_parent().is_tile_valid(cell):
				draw_circle(Vector2(get_parent().map_to_local(cell)-Vector2(c_size,c_size)*0.5), c_size, Color(0.85,0.9,1.0, 0.5))
