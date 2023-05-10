extends ConfirmationDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.validation_popup.connect(_on_validation_pop)
	get_cancel_button().pressed.connect(_on_cancel)
	get_ok_button().pressed.connect(_on_ok)

func _on_ok():
	GAME.target_selected.emit({})

func _on_cancel():
	GAME.selecting.emit(false)

func _on_validation_pop(t):
	visible = true
	dialog_text = "Voulez-vous vraiment lancer " + t + " ?" 
