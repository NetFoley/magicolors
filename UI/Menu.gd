extends Control

const PORT = 9999
const ADDRESS = "127.0.0.1"

var local_player_character

func _ready():
	$VBoxContainer/HostBut.pressed.connect(_on_host_pressed)
	$VBoxContainer/JoinBut.pressed.connect(_on_join_pressed)

func _on_host_pressed():
	NETWORK.side = "Server"
	visible = false
	NETWORK.peer.create_server(PORT)
	multiplayer.multiplayer_peer = NETWORK.peer
	NETWORK.id = multiplayer.get_unique_id()
	start_level()

func _on_join_pressed():
	NETWORK.side = "Client"
	if NETWORK.peer.create_client($VBoxContainer/TextEdit.text, PORT) == 0:
		multiplayer.multiplayer_peer = NETWORK.peer
		NETWORK.id = multiplayer.get_unique_id()
		visible = false
		start_level()

func start_level():
	get_tree().change_scene_to_file("res://Scenes/Battleground.tscn")


