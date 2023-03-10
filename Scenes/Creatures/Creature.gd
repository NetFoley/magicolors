extends Node2D
class_name Creature

@export_enum("RED", "GREEN", "BLUE", "WHITE", "BLACK") var color = 0
@export var max_life = 3:
	set(value):
		max_life = value
		if get_node_or_null("LifeBar"):
			$LifeBar.max_value = value
		
var life = 3:
	set(value):
		life = value
		if life <= 0:
			die()
		elif(life > max_life):
			life = max_life
		$LifeBar.value = life
		
@export var movement = 3
@export var dmg = 1
@export var c_range = 1
@export var can_be_targeted = true
@onready var but = $SelectButton

var can_attack = true:
	set(value):
		can_attack = value

var can_move = true:
	set(value):
		can_move = value
		enable_but(value)
var player:
	set(value):
		player = value
		$Sprite.flip_h = value == "Player2"
			

# Called when the node enters the scene tree for the first time.
func _ready():
	can_move = false
	can_attack = false
	$Sprite.appear_finished.connect(_spell_tween_finished)
	visible = false
	but.gui_input.connect(_on_gui_input)
	GAME.turn_changed.connect(func(__): can_move = true; can_attack = true)
	max_life = max_life
	life = max_life

func _on_gui_input(event):
	if !is_multiplayer_authority() or !GAME.is_our_turn():
		return
	if event.is_action_pressed("select") and can_move:
		GAME.emetter = self
		GAME.get_targets({"type": GAME.tile_map.select_type.FREE_TILE, "range": movement, "from_pos": GAME.tile_map.local_to_map(position)})
	elif(event.is_action_pressed("remove")) and can_attack:
		GAME.emetter = self
		GAME.get_targets({"type": GAME.tile_map.select_type.ENEMY_CREATURE, "range": c_range, "from_pos": GAME.tile_map.local_to_map(position)})

func appear():
	visible = true
	$Sprite.appear()

func _spell_tween_finished():
	$Sprite.play("default")

func target_selected(target):
	if target["creature"]:
		rpc("attack", (target["creature"]))
	else:
		rpc("move", (target["position"]))

@rpc("authority", "call_local", "reliable")
func move(pos):
	create_tween().tween_property(self, "position", Vector2(pos), 0.6).set_trans(Tween.TRANS_BACK)
	but.release_focus()
	can_move = false

@rpc("authority", "reliable", "call_local")
func attack(target):
	if target.player == player:
		return
	target.life -= dmg
	can_attack = false
	
func enable_but(value):
	if value:
		but.focus_mode = Control.FOCUS_CLICK
	else:
		but.focus_mode = Control.FOCUS_NONE
	but.disabled = !value

func die():
	player.creatures.erase(self)
	queue_free()
