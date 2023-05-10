extends Node2D

@export var dmg = 7
@export var duration = 4
var turn_left = 10
var damaged_crea : Dictionary = {}
	
func attach():
	GAME.turn_changed.connect(_on_turn_changed)
	visible = true
	if is_multiplayer_authority():
		await get_tree().process_frame
		$Area2D.area_entered.connect(_on_area_entered)
		
func _on_turn_changed(_value):
	damaged_crea.clear()
	var crea : Creature = GAME.tile_map.get_creature_at_pos(GAME.tile_map.local_to_map(position))
	if crea and crea.can_be_targeted:
		crea.damage(dmg, self)
	turn_left -= 1
	if turn_left <= 0:
		queue_free()

func _on_area_entered(area):
	if !area.owner is Creature:
		return
	rpc("damage_crea", area.owner.get_path())

@rpc("authority", "call_local", "reliable")
func damage_crea(crea_path):
	if damaged_crea.has(crea_path):
		return
	damaged_crea[crea_path] = true
	var crea = get_node_or_null(crea_path)
	if is_instance_valid(crea) and crea is Creature and crea.can_be_targeted:
		crea.damage(dmg*0.5, self)
