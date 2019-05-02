extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 800

var motion = Vector2()

func _process(delta):
	# GRAVITY
	motion.y += delta * GRAVITY
	motion = move_and_slide(motion, Vector2(0, -1))
	
func takeDamage():
	self.modulate = ColorN("red")
	$Timer.start()

func _on_Timer_timeout():
	self.modulate = ColorN("white")
