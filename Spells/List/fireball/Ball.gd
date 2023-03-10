extends Node2D

var goal_pos = Vector2(280,130)
var preping = true
	
func _ready():
	$SpellSprite.appear_finished.connect(_spell_tween_finished)
	
func appear():
	visible = true
	$SpellSprite.appear()
	rotate(global_position.direction_to(goal_pos).angle())
	

func _spell_tween_finished():
	var tween = create_tween()
	tween.finished.connect(_tween_finished)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", goal_pos, 0.5)
	$SpellSprite.play("default")

func _tween_finished():
	$SpellSprite.visible = false
	$Explosion.play("default")
	$Explosion.animation_finished.connect(_anim_finished)

func _anim_finished():
	queue_free()
