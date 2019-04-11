extends KinematicBody2D

const GRAVITY = 981
const WALK_SPEED = 400
const JUMP_SPEED = -500

var velocity = Vector2()
enum DIRECTION { RIGHT = 1, LEFT = -1}
var direction = DIRECTION.RIGHT

var jump = false
var jumpCancel = false

var timer
var canDash = true

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 3.0
	self.add_child(timer)
	timer.connect("timeout", self, "timer_onTimeout")
	
func timer_onTimeout():
	$AnimatedSprite.stop()
	canDash = true

func _process(delta):
	if(is_on_floor()):
		velocity.y = 0;
	else:
		velocity.y += delta * GRAVITY
	
	if Input.is_key_pressed(KEY_A):
		velocity.x = -WALK_SPEED
		if direction == DIRECTION.RIGHT:
			self.scale.x *= -1
			direction = DIRECTION.LEFT

	if Input.is_key_pressed(KEY_D):
		velocity.x = WALK_SPEED
		if direction == DIRECTION.LEFT:
			self.scale.x *= -1
			direction = DIRECTION.RIGHT
	if (Input.is_key_pressed(KEY_SPACE)):
		velocity.y = JUMP_SPEED
		jump = true
	if (is_on_ceiling()):
		velocity.y = delta * GRAVITY
	
	if Input.is_key_pressed(KEY_E) && canDash:
		canDash = false
		$AnimatedSprite.play("default")
		timer.start()
		self.translate(Vector2(500.0 * direction, 0.0))
		velocity.y = delta * GRAVITY
		
	move_and_slide(velocity, Vector2(0, -1))
	velocity.x = 0
	
func attack():
	# todo
	pass
	
func takeDamage(damage):
	$StateManager.take_Damage(damage)
	pass

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = 0
