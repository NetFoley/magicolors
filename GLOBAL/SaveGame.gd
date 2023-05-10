extends Resource
class_name SaveGame

const SAVE_GAME_BASE_PATH = "user://savegame"
var turn = 0
@export var save_name = ""
@export var creatures = []
@export var spells1 = []
@export var spells2 = []

func update_res():
	turn = GAME.turn
	creatures = GAME.tile_map.get_creatures()
	spells1 = GAME.get_player_object("Player1").spells
	spells2 = GAME.get_player_object("Player2").spells
	
func save_game():
	update_res()
	save_name = "Tour " + str(turn) + " - " + Time.get_datetime_string_from_system()
	ResourceSaver.save(self, get_save_path())

static func load_savegame() -> Resource:
	var save_path := get_save_path()
	if ResourceLoader.has_cached(save_path):
		# Once the resource caching bug is fixed, you will only need this line of code to load the save game.
		return ResourceLoader.load(save_path, "")

	# /!\ Workaround for bug https://github.com/godotengine/godot/issues/59686
	# Without that, sub-resources will not reload from the saved data.
	# We copy the SaveGame resource's data to a temporary file, load that file
	# as a resource, and make it take over the save game.

	# We first load the save game resource's content as a byte array and store it.
	var file = FileAccess.open(get_save_path(), FileAccess.READ)
	
	if !file:
		printerr("Couldn't read file " + save_path)
		return null

	var data := file.get_buffer(file.get_length())
	file.close()

	# Then, we generate a random file path that's not in Godot's cache.
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	# We write a copy of the save game to that temporary file path.
	file = FileAccess.open(tmp_file_path, FileAccess.WRITE)
	if !file:
		printerr("Couldn't write file " + tmp_file_path)
		return null

	file.store_buffer(data)
	file.close()

	# We load the temporary file as a resource.
	var save = ResourceLoader.load(tmp_file_path, "")
	# And make it take over the save path for the next time the player
	# saves.
	save.take_over_path(save_path)

	# We delete the temporary file.
	var directory := DirAccess.open("user://")
	directory.remove(tmp_file_path)
	return save
	
static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + extension
	
	
static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"