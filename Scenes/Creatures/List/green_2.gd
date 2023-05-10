extends Creature

# Called when the node enters the scene tree for the first time.
func _ready():
	attacked.connect(_on_attacked)
	super._ready()

func _on_attacked(_value, _target):
	GAME.add_color(_target.color)
