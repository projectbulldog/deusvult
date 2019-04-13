extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 550
const JUMP_SPEED = -5000
const MAXJUMP_SPEED = -90000
const MINJUMP_SPEED = -500

var motion = Vector2()

enum DIRECTION { RIGHT = 1, LEFT = -1}
var direction = DIRECTION.RIGHT

var jumpTime = 0
var canJump = true

var canDash = true
var dashCooldown = 3.0
var dashCooldownTimer

var dashParticleSpeed = -500

func _ready():
	dashCooldownTimer = Timer.new()
	dashCooldownTimer.one_shot = true
	dashCooldownTimer.wait_time = dashCooldown
	self.add_child(dashCooldownTimer)
	dashCooldownTimer.connect("timeout", self, "on_dashCooldownTimer_timeout")

func on_dashCooldownTimer_timeout():
	canDash = true

func _process(delta):
	# GRAVITY
	var lastMotionY = motion.y
	motion.y += delta * GRAVITY
	
	# LEFT / RIGHT MOVEMENT
	if Input.is_action_pressed("ui_right"):
		if direction == DIRECTION.LEFT:
			self.scale.x *= -1
			direction = DIRECTION.RIGHT

		motion.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		if direction == DIRECTION.RIGHT:
			self.scale.x *= -1
			direction = DIRECTION.LEFT

		motion.x = -SPEED
	else:
		motion.x = 0
	
	# DASH
	if Input.is_action_pressed("dash") && canDash:
		canDash = false
		dashCooldownTimer.start()
		$Particles2D.set_as_toplevel(true)
		$Particles2D.position = self.position
		var material : ParticlesMaterial = $Particles2D.process_material
		material.initial_velocity = dashParticleSpeed * direction
		$Particles2D.emitting = true
		self.position.x += direction * 400
		self.position.y -= delta * GRAVITY

	# JUMPING
	if Input.is_action_pressed("jump") && jumpTime < 0.3 && canJump && !is_on_ceiling():
		motion.y = min(0, motion.y)
		motion.y = max(motion.y + (JUMP_SPEED * delta), MAXJUMP_SPEED)
		motion.y = min(motion.y, MINJUMP_SPEED)
		jumpTime += delta
	elif !Input.is_action_pressed("jump") && jumpTime > 0:
		canJump = false
	if !is_on_floor() && jumpTime == 0:
		canJump = false
	
	if is_on_floor():
		jumpTime = 0
		canJump = true
	if is_on_ceiling():
		canJump = false
		motion.y = delta * GRAVITY
	
	motion = move_and_slide(motion, Vector2(0, -1))
	$Camera2D.align()
	
	if(lastMotionY - motion.y) > 2500:
		$Camera2D.start_shake()

func attack():
	# todo
	pass
	
func takeDamage(damage):
	$StateManager.take_Damage(damage)
	
