@tool
extends Node2D
class_name Player

@onready var anim_spr : AnimatedSprite2D = get_node("AnimNode/AnimatedSprite2D2")
@onready var staff_spr : Node2D = get_node("AnimNode/Node2D")
@export var flipped = false:
	set(value):
		flipped = value
		if anim_spr and staff_spr:
			anim_spr.flip_h = value
			anim_spr.material.set_shader_parameter("redded", value)
			if value:
				staff_spr.position = Vector2(-10, -18)
				staff_spr.scale = Vector2(1, 1)
			else:
				staff_spr.position = Vector2(10,-18)
				staff_spr.scale = Vector2(-1, 1)

var creatures = []
var spells = []

func _ready():
	$AnimNode/AnimatedSprite2D2/AnimationPlayer.play("Idle")
	flipped = flipped
	if Engine.is_editor_hint():
		return
	if flipped:
		GAME.player2 = self
		var peers = multiplayer.get_peers()
		for peer in peers:
			set_multiplayer_authority(peer)
		multiplayer.peer_connected.connect(_on_peer_connected)
	else:
		GAME.player1 = self
	GAME.new_spell.connect(_on_new_spell)
	GAME.old_spell.connect(_on_old_spell)
	$Timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	if GAME.get_player_turn() == name:
		$GPUParticles2D.emitting = true
	else:
		$GPUParticles2D.emitting = false
	$Timer.start(10.0*randf())

func _on_new_spell(spell_id, _player):
	if _player != name:
		return
	add_spell.rpc(spell_id)
	
@rpc("any_peer", "call_local", "reliable")
func add_spell(spell_id):
	spells.append(spell_id)
	
func _on_old_spell(spell_id, _player):
	if _player != name:
		return
	remove_spell.rpc(spell_id)

@rpc("any_peer", "call_local", "reliable")
func remove_spell(spell_id):
	spells.erase(spell_id)
	
func _on_peer_connected(peer_id):
	set_multiplayer_authority(peer_id)

@rpc("reliable", "authority", "call_local")
func cast(spell_id, target):
	$CastSound.play()
	var spell = GAME.get_spell(spell_id)
	print("["+str(NETWORK.id)+"]"+name + " casted " + spell.spell_name + " !")
	$AnimNode/Node2D/Sprite2D/AnimationPlayer.play("Cast")
	spell.launch(target, name)
	GAME.casted.emit(spell.spell_name, name)
	GAME.old_spell.emit(spell.spell_id, name)
