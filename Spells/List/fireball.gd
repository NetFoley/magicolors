extends Spell


# Called when the node enters the scene tree for the first time.
func launch(target, sender):
	print("fireball launch")
	var ball = get_node("Ball").duplicate()
	GAME.get_player_object(sender).add_child(ball)
	ball.visible = true
	ball.goal_pos = Vector2(target["position"])
	ball.position = Vector2(0, -50)
	ball.appear()

func get_target():
	GAME.get_targets({"type": GAME.tile_map.select_type.ANY})
