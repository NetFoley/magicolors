extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(_on_connected)
	multiplayer.peer_disconnected.connect(_on_disconnected)

func _on_connected(peer):
	visible = true
	text = ("Connected to " + var_to_str(peer))
	await get_tree().create_timer(4.0).timeout
	visible = false

func _on_disconnected(peer):
	visible = true
	text = ("Disconnected from " + var_to_str(peer))
	await get_tree().create_timer(4.0).timeout
	visible = false
	
