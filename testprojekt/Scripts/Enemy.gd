extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 400
var DIRECTION = Enums.DIRECTION
var direction = DIRECTION.RIGHT;

var motion = Vector2()

enum MODE { IDLE, AGGRO }
var mode = MODE.IDLE

var health = 4
var max_health = 4

var impulse = Vector2(0, 0)
var impulseDamp = 0.8

var invincible = false

var player

var isPlayerInDamageArea
var timeUntilDamage = 1.0
var timeInArea = 0.0

func _physics_process(delta):
	if (GameState.stopMovingEnemies):
		motion = Vector2(0, 0)
		return
	
	if isPlayerInDamageArea && timeInArea < timeUntilDamage:
		timeInArea += delta
	elif isPlayerInDamageArea:
		player.takeDamage(1)
		timeInArea = 0

	# GRAVITY
	motion.y += delta * GRAVITY
	if(mode == MODE.AGGRO):
		var posXDiff = player.global_position.x - self.global_position.x
		if(posXDiff <= -30 && self.direction != DIRECTION.LEFT):
			self.changeDirection()
		elif posXDiff > 30 && direction != DIRECTION.RIGHT:
			self.changeDirection()
		motion.x = lerp(motion.x, SPEED * direction, 0.1)
	elif(mode == MODE.IDLE):
		motion.x = 0
#
	if impulse != Vector2(0, 0):
		motion += impulse
		impulse *= impulseDamp
	motion = move_and_slide(motion, Vector2(0, -1))
	pass

func _process(delta):
	if(mode == MODE.IDLE):
		travelTo("Idle")
	elif mode == MODE.AGGRO:
		travelTo("Jump")

func changeDirection():
	self.direction *= -1
	$Sprite.scale.x *= -1

func takeDamage(damageFrom = Vector2(0, 0)):
	if !invincible:
		self.invincible = true
		var dir = self.global_position - damageFrom
		dir = dir.normalized()
		self.modulate = ColorN("red")
		$Timer.start()
		health -= 1
		if(health <= 0):
			$Sprite/AnimationTree.playback.stop()
			self.queue_free()
		impulse = Vector2(dir.x * 1000, -200)

func _on_Timer_timeout():
	self.modulate = ColorN("white")
	invincible = false

func travelTo(animation):
	$Sprite/AnimationTree.playback.travel(animation)

func _on_DamageArea_body_entered(body):
	if body.is_in_group("Player"):
		isPlayerInDamageArea = true
		body.takeDamage(1)

func _on_DamageArea_body_exited(body):
	if body.is_in_group("Player"):
		isPlayerInDamageArea = false

func _on_SeePlayer_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		mode = MODE.AGGRO

func _on_SeePlayer_body_exited(body):
	if body.is_in_group("Player"):
		player = body
		mode = MODE.IDLE
