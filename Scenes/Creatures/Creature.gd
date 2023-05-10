extends Node2D
class_name Creature

@export_enum("RED", "GREEN", "BLUE", "WHITE", "BLACK") var color = 0
@export var max_life = 3:
	set(value):
		max_life = value
		if get_node_or_null("LifeBar"):
			$LifeBar.max_value = value
		update_tool_tip()
		
var life = 3:
	set(value):
		var start_life = life
		life = value
		if life <= 0:
			die()
		elif(life > max_life):
			life = max_life
		var life_change = life - start_life
		if initialized and life_change != 0:
			GAME.add_change_label(position, life_change)
		if !is_inside_tree():
			return
		if $LifeBar:
			$LifeBar.visible = life < max_life or always_show_life
			$LifeBar.value = life
		update_tool_tip()
		
var multiplicater = 1.0
		
@export var movement = 3:
	set(value):
		movement = value
		update_tool_tip()
@export var dmg = 1:
	set(value):
		dmg = value
		update_tool_tip()

@export var can_dmg_ally = false
@export var aoe_area = 0
@export var c_range = 1
@export var can_be_targeted = true
@onready var but = $SelectButton
@export var can_be_selected = true
@export var mental_cap_cost = 1.0
@export var particularity_desc = ""
@export var start_can_move = false
@export var start_can_attack = false
@export var always_show_life = false
var creature_id
var initialized = false

signal can_attack_changed(value)
signal can_move_changed(value)
signal damaged(value, damager)
signal attacked(value, target)

var regen_attack = true
var regen_move = true
var can_attack = true:
	set(value):
		if can_attack == value:
			return
		can_attack = value
		can_attack_changed.emit(value)

var can_move = true:
	set(value):
		if can_move == value:
			return
		can_move = value
		can_move_changed.emit(value)
#		enable_but(value)
var player:
	set(value):
		player = value
		if !is_inside_tree():
			return
		$Sprite.flip_h = value == "Player2"
		if player != GAME.get_player():
			$MoveIcon.modulate = Color(1.0, 1.0, 1.0, 0.3)
			$AttackIcon.modulate = Color(1.0, 1.0, 1.0, 0.3)
		if player == GAME.get_player():
			$LifeBar.modulate = Color(0.4, 1.0, 0.4, 1.0)
		else:
			$LifeBar.modulate = Color(1.0, 0.1, 0.1, 1.0)
		update_modulate_tween()
			
var modulateTween : Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	can_move_changed.connect(_on_can_moved_changed)
	can_attack_changed.connect(_on_can_attack_changed)
	can_move = start_can_move
	can_attack = start_can_attack
	if $Sprite:
		$Sprite.appear_finished.connect(_spell_tween_finished)
	visible = false
	if but:
		but.gui_input.connect(_on_gui_input)
	GAME.turn_changed.connect(_on_turn_changed)
	max_life = max_life
	life = max_life
	update_tool_tip()
	await get_tree().process_frame
	initialized = true
	update_modulate_tween()

	
#func _enter_tree():
	
func _on_turn_changed(_turn):
#	if GAME.get_player_turn() == player:
#		return
	if regen_attack:
		can_attack = true
	else:
		regen_attack = true
	if regen_move:
		can_move = true
	else:
		regen_move = true
	update_modulate_tween()
			
func update_modulate_tween():
	if !is_inside_tree():
		return
	if GAME.get_player_turn() == player:
		modulateTween = create_tween()
		modulateTween.tween_property($Sprite, "modulate", Color(3.0, 3.0, 3.0, 1.0), 0.7).set_trans(Tween.TRANS_QUAD)
		modulateTween.tween_property($Sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.7).set_trans(Tween.TRANS_QUAD)
		modulateTween.set_loops()
	else:
		if modulateTween:
			modulateTween.stop()
			$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	
func _on_can_moved_changed(value):
	var visible_value = value
	if movement <= 0:
		visible_value = false
	$MoveIcon.appear(visible_value)
	update_sprite()
	
func _on_can_attack_changed(value):
	var visible_value = value
	if dmg <= 0:
		visible_value = false
	$AttackIcon.appear(visible_value)
	update_sprite()
	
func update_sprite():
	if can_move or can_attack:
		$Sprite.play("default")
	else:
		$Sprite.stop()
	
func update_tool_tip():
	if !get_node_or_null("SelectButton"):
		return
	$SelectButton.tooltip_text = str(name) 
	$SelectButton.tooltip_text += "\n Vie: " + str(life) + "/" + str(max_life)
	$SelectButton.tooltip_text += "\n Dégâts : " + str(dmg)
	$SelectButton.tooltip_text += "\n Portée : " + str(c_range)
	if aoe_area > 0:
		$SelectButton.tooltip_text += "\n Zone dégâts : " + str(aoe_area) + " cases"
		
	$SelectButton.tooltip_text += "\n Déplacement : " + str(movement)
	$SelectButton.tooltip_text += "\n Coût en cap. mentale : " + str(mental_cap_cost)
	if particularity_desc != "":
		$SelectButton.tooltip_text += "\n Particularité : " + str(particularity_desc)
	var buffs = $Effets.get_children()
	if buffs.size() > 0:
		$SelectButton.tooltip_text += "\n Effets : "
		for child in buffs:
			$SelectButton.tooltip_text += "[color=lightblue]" + str(child.name) + "[/color] "
	
	
func add_effect(buff):
	$Effets.add_child(buff)
	
func _on_gui_input(event):
	if !is_multiplayer_authority() or !GAME.is_our_turn() or !can_be_selected or !initialized:
		return
	if event.is_action_pressed("select"):
		var targets = []
		if can_move:
			targets.append({"type": GAME.tile_map.select_type.FREE_TILE, "range": movement, "from_pos": GAME.tile_map.local_to_map(position)})
		if can_attack:
			targets.append({"type": GAME.tile_map.select_type.ANY_CREATURE, "range": c_range, "from_pos": GAME.tile_map.local_to_map(position)})
		if targets.is_empty():
			GAME.error_popup.emit("crea_cant_move")
			return
		GAME.emetter = self
		GAME.get_targets(targets)
#	elif(event.is_action_pressed("remove")) and can_attack:
#		GAME.emetter = self
#		GAME.get_targets({"type": GAME.tile_map.select_type.ANY_CREATURE, "range": c_range, "from_pos": GAME.tile_map.local_to_map(position)})

func appear():
	visible = true
	$Sprite.appear()

func get_texture():
	return $Sprite.sprite_frames.get_frame_texture("default", 0)

func _spell_tween_finished():
	$Sprite.play("default")

func target_selected(target):
	if target["creature"]:
		rpc("attack", (target["creature"]))
	else:
		rpc("move", (target["position"]))

@rpc("authority", "call_local", "reliable")
func move(pos):
	$Move.play()
	create_tween().tween_property(self, "position", Vector2(pos), 0.6).set_trans(Tween.TRANS_BACK)
	but.release_focus()
	can_move = false

@rpc("authority", "reliable", "call_local")
func attack(target_path):
	var target : Creature = get_node(target_path)
	var targets = []
	var creatures = []
	if aoe_area > 0:
		creatures = GAME.tile_map.get_creatures_around(GAME.tile_map.local_to_map(target.position), aoe_area)
	else:
		creatures = [target]
	for crea in creatures:
		if crea != self and (crea.player != player or can_dmg_ally):
			targets.append(crea)
	for crea in targets:
		var tween = create_tween()
		tween.tween_property(self, "position", position, 0.6).set_trans(Tween.TRANS_CIRC).from(crea.position)
		crea.damage(dmg, self)
		attacked.emit(dmg, crea)
		can_attack = false
		can_move = false
	
func damage(value, damager):
	life -= value
	$Blood.restart()
	if randi()%2 == 0:
		$Hit.play()
	else:
		$Hit2.play()
	$Sprite/AnimationPlayer.play("Hit")
	damaged.emit(value, damager)
	
func enable_but(value):
	if value:
		but.focus_mode = Control.FOCUS_CLICK
	else:
		but.focus_mode = Control.FOCUS_NONE
	but.disabled = !value

func die():
	var player_obj = GAME.get_player_object(player)
	if player_obj:
		player_obj.creatures.erase(self)
	queue_free()

func get_resources():
	var res : Resource
	
