extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(_on_connected)

func _on_connected(peer):
	text = ("Connected to " + var_to_str(peer))
	await get_tree().create_timer(4.0).timeout
	visible = false
