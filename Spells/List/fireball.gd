extends Spell


# Called when the node enters the scene tree for the first time.
func launch(target):
	print("fireball launch")
	var ball = get_node("Ball").duplicate()
	GAME.get_player().add_child(ball)
	ball.appear()
	ball.goal_pos = Vector2(target)
	ball.position = Vector2(0, -50)

func get_target():
	GAME.get_tile()
