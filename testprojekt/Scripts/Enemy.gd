extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 500
var direction = 1;

var motion = Vector2()

enum MODE { IDLE, AGGRO }
var mode = MODE.IDLE

var health = 4
var max_health = 4

var impulse = Vector2(0, 0)
var impulseDamp = 0.8

func _physics_process(delta):
	if (GameState.stopMovingEnemies):
		motion = Vector2(0, 0)
		return
	
	# GRAVITY
	motion.y += delta * GRAVITY
	
	if(mode == MODE.IDLE):
		if(is_on_floor()):
			$RayCastGround.enabled = true
			$RayCastWall.enabled = true
		if(!$RayCastGround.is_colliding() || $RayCastWall.is_colliding()) && is_on_floor():
			direction *= -1
			self.scale.x *= -1
		motion.x = SPEED * direction

	if impulse != Vector2(0, 0):
		motion += impulse
		impulse *= impulseDamp
	motion = move_and_slide(motion, Vector2(0, -1))
	

func takeDamage(damageFrom = Vector2(0, 0)):
	var direction = self.global_position - damageFrom
	print(damageFrom.angle_to_point(self.global_position))
	direction = direction.normalized()
	self.modulate = ColorN("red")
	$Timer.start()
	health -= 1
	if(health <= 0):
		self.queue_free()
	impulse = -motion + Vector2(direction.x * 2000, -200)

func _on_Timer_timeout():
	self.modulate = ColorN("white")


func _on_DamageArea_body_entered(body):
	if body.is_in_group("Player"):
		body.takeDamage(1)
