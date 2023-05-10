extends Creature

var has_attacked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	attacked.connect(_on_attacked)
#	GAME.turn_changed.connect(_on_green_turn_changed)
	super._ready()

func _on_attacked(_value, _target):
	regen_move = false
	can_move = false
	_target.regen_move = false
	_target.can_move = false
#
#func _on_turn_changed(_turn):
#	super._on_turn_changed(_turn)
