extends KinematicBody2D

const GRAVITY = 1500
const SPEED = 500
const JUMP_SPEED = -700

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

func _physics_process(delta):
	# GRAVITY
	motion.y += delta * GRAVITY
		
	# LEFT / RIGHT MOVEMENT
	if Input.is_key_pressed(KEY_D):
		if direction == DIRECTION.LEFT:
			self.scale.x *= -1
			direction = DIRECTION.RIGHT

		motion.x = SPEED
	elif Input.is_key_pressed(KEY_A):
		if direction == DIRECTION.RIGHT:
			self.scale.x *= -1
			direction = DIRECTION.LEFT

		motion.x = -SPEED
	else:
		motion.x = 0
	
	# DASH
	if Input.is_key_pressed(KEY_E) && canDash:
		canDash = false
		dashCooldownTimer.start()
		$Particles2D.set_as_toplevel(true)
		$Particles2D.position = self.position
		var material : ParticlesMaterial = $Particles2D.process_material
		material.initial_velocity = dashParticleSpeed * direction
		$Particles2D.emitting = true
		self.position.x += direction * 400

	# JUMPING
	if Input.is_key_pressed(KEY_SPACE) && jumpTime < 0.3 && canJump:
		motion.y = JUMP_SPEED
		jumpTime += delta
	elif !Input.is_key_pressed(KEY_SPACE) && jumpTime > 0:
		canJump = false
	
	if is_on_floor():
		jumpTime = 0
		canJump = true
	
	motion = move_and_slide(motion, Vector2(0, -1))

func attack():
	# todo
	pass
	
func takeDamage(damage):
	$StateManager.take_Damage(damage)
