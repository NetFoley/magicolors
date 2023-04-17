extends CanvasLayer

const ADDRESS = "127.0.0.1"

var local_player_character

# Emitted when UPnP port mapping setup is completed (regardless of success or failure).
signal upnp_completed(error)

# Replace this with your own server port number between 1024 and 65535.
var thread = null

func _ready():
	$VBoxContainer/HostBut.pressed.connect(_on_host_pressed)
	$VBoxContainer/JoinBut.pressed.connect(_on_join_pressed)
	thread = Thread.new()
	thread.start(_upnp_setup.bind(NETWORK.SERVER_PORT))
	upnp_completed.connect(_on_upnp_completed)

func _on_upnp_completed(error):
	print(error)

func _on_host_pressed():
	NETWORK.side = "Server"
	NETWORK.peer.create_server(NETWORK.SERVER_PORT)
	multiplayer.multiplayer_peer = NETWORK.peer
	NETWORK.id = multiplayer.get_unique_id()
	multiplayer.peer_connected.connect(func(_id):$Label.set_text("CONNECTED"); start_level())
	$VBoxContainer.visible = false
	$Label.visible = true

func _on_join_pressed():
	NETWORK.side = "Client"
	if NETWORK.peer.create_client($VBoxContainer/TextEdit.text, NETWORK.SERVER_PORT) == 0:
		multiplayer.multiplayer_peer = NETWORK.peer
		NETWORK.id = multiplayer.get_unique_id()
		multiplayer.peer_connected.connect(func(_id):$Label.text = "CONNECTED"; start_level())
		$VBoxContainer.visible = false
		$Label.visible = true

func start_level():
	get_tree().change_scene_to_file("res://Scenes/Battleground.tscn")

func _upnp_setup(_server_port):
	# UPNP queries take some time
	var upnp = UPNP.new()
	var _err = upnp.discover()
	upnp.add_port_mapping(NETWORK.SERVER_PORT, NETWORK.SERVER_PORT, ProjectSettings.get_setting("application/config/name"), "UDP")
	upnp.add_port_mapping(NETWORK.SERVER_PORT, NETWORK.SERVER_PORT, ProjectSettings.get_setting("application/config/name"), "TCP")
	
	print("lost")


func _exit_tree():
	# Wait for thread finish here to handle game exit while the thread is running.
	thread.wait_to_finish()

