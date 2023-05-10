extends CanvasLayer

const ADDRESS = "127.0.0.1"

var local_player_character

# Emitted when UPnP port mapping setup is completed (regardless of success or failure).
signal upnp_completed(error)

# Replace this with your own server port number between 1024 and 65535.
var save

func _ready():
	$VBoxContainer/HostBut.pressed.connect(_on_host_pressed)
	$VBoxContainer/JoinBut.pressed.connect(_on_join_pressed)
	save = GAME.save_res.load_savegame()
#	await get_tree().create_timer(1.0)
	var but = CheckButton.new()
	but.text = str(save.save_name)
	but.button_group = $VBoxContainer/HostBut/ScrollContainer/VBoxContainer/CheckButton.button_group
	$VBoxContainer/HostBut/ScrollContainer/VBoxContainer.add_child(but)
	
func _on_host_pressed():
	$Button.play()
	NETWORK.side = "Server"
	NETWORK.peer.create_server(NETWORK.SERVER_PORT)
	multiplayer.multiplayer_peer = NETWORK.peer
	NETWORK.id = multiplayer.get_unique_id()
	multiplayer.peer_connected.connect(func(_id):$Label.set_text("CONNECTED"); start_level())
	$VBoxContainer.visible = false
	$Label.visible = true

func _on_join_pressed():
	$Button.play()
	NETWORK.side = "Client"
	if NETWORK.peer.create_client($VBoxContainer/TextEdit.text, NETWORK.SERVER_PORT) == 0:
		multiplayer.multiplayer_peer = NETWORK.peer
		NETWORK.id = multiplayer.get_unique_id()
		multiplayer.peer_connected.connect(func(_id):$Label.text = "CONNECTED"; start_level())
		$VBoxContainer.visible = false
		$Label.visible = true

func start_level():
	get_tree().change_scene_to_file("res://Scenes/Battleground.tscn")




