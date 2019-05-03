extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 300
var direction = 1;

var motion = Vector2()

enum MODE { IDLE, AGGRO }
var mode = MODE.IDLE

func _process(delta):
	# GRAVITY
	motion.y += delta * GRAVITY
	
	if(mode == MODE.IDLE):
		if(is_on_floor()):
			$RayCastGround.enabled = true
			$RayCastWall.enabled = true
		if(!$RayCastGround.is_colliding() || $RayCastWall.is_colliding()):
			direction *= -1
			self.scale.x *= -1
		motion.x = SPEED * direction

	motion = move_and_slide(motion, Vector2(0, -1))
func takeDamage():
	self.modulate = ColorN("red")
	$Timer.start()

func _on_Timer_timeout():
	self.modulate = ColorN("white")
