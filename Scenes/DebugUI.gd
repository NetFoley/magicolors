extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	if !OS.is_debug_build():
		visible = false
	$Label.text = NETWORK.side
	$Label2.text = str(NETWORK.id)
