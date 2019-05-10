extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 150
var direction = 1;

var motion = Vector2()

enum MODE { IDLE, AGGRO }
var mode = MODE.IDLE

var health = 4
var max_health = 4

var impulse = Vector2(0, 0)
var impulseDamp = 0.8

func _physics_process(delta):
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

	if impulse != Vector2(0, 0):
		motion += impulse
		impulse *= impulseDamp
	motion = move_and_slide(motion, Vector2(0, -1))
	

func takeDamage(forceFrom = Vector2(0, 0)):
	self.modulate = ColorN("red")
	$Timer.start()
	health -= 1
	if(health <= 0):
		self.queue_free()
	impulse = forceFrom

func _on_Timer_timeout():
	self.modulate = ColorN("white")


func _on_DamageArea_body_entered(body):
	if body.is_in_group("Player"):
		body.takeDamage(1)
