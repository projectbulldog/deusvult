extends KinematicBody2D

const GRAVITY = 981
const WALK_SPEED = 400
const JUMP_SPEED = -500

var velocity = Vector2()
enum DIRECTION { RIGHT, LEFT}
var direction = DIRECTION.RIGHT

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
	if (Input.is_key_pressed(KEY_SPACE) && is_on_floor()):
		velocity.y = JUMP_SPEED
	if (is_on_ceiling()):
		velocity.y = delta * GRAVITY

	if(is_on_wall()):
		velocity.y = 0;
		if(Input.is_key_pressed(KEY_SPACE)):
			velocity.y = JUMP_SPEED
		
	move_and_slide(velocity, Vector2(0, -1))
	velocity.x = 0
	
func attack():
	# todo
	pass
	
func takeDamage(damage):
	$StateManager.take_Damage(damage)
	pass
	

# das wär en prototyp , für en dash
#var dash_timer
#var can_dash = true
#
#func _ready():
#	dash_timer = Timer.new()
#	dash_timer.wait_time = 5.0
#	dash_timer.one_shot = true
#	self.add_child(dash_timer)
#	dash_timer.connect("timeout", self, "cooldown_reset")

#func cooldown_reset():
#	can_dash = true


#if can_dash && Input.is_key_pressed(KEY_E):
#		self.translate(Vector2(550, 0))
#		can_dash = false
#		dash_timer.start()
#	if can_dash && Input.is_key_pressed(KEY_Q):
#		self.translate(Vector2(-550, 0))
#		can_dash = false
#		dash_timer.start()