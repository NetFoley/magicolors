extends Spell


# Called when the node enters the scene tree for the first time.
func launch():
	print("fireball launch")
	var ball = get_node("Ball").duplicate()
	GAME.player1.add_child(ball)
	ball.appear()
	ball.position = Vector2(0, -50)
