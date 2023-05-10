extends Node

var music_played = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(4.0).timeout
	for child in get_children():
		var audiop : AudioStreamPlayer = child
		audiop.finished.connect(_on_music_finished)
	_on_music_finished()
		
func _on_music_finished():
	if music_played > 2 + randi() % (music_played + 10):
		await get_tree().create_timer(randf()*10.0)
	get_child(randi()%get_child_count()).play()
	music_played += 1
