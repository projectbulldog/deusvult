extends KinematicBody2D

const GRAVITY = 981
const WALK_SPEED = 400

var velocity = Vector2()

func _process(delta):
	if(is_on_floor()):
		velocity.y = 0;
	else:
		velocity.y += delta * GRAVITY
	
	if Input.is_key_pressed(KEY_A):
		velocity.x = -WALK_SPEED
	if Input.is_key_pressed(KEY_D):
		velocity.x = WALK_SPEED
	if (Input.is_key_pressed(KEY_SPACE) && is_on_floor()):
		velocity.y = -550
	if (is_on_ceiling()):
		velocity.y = delta * GRAVITY
		
	move_and_slide(velocity, Vector2(0, -1))
	velocity.x = 0
	
func attack():
	# todo
	pass
	
func takeDamage(damage):
	$StateManager.take_Damage(damage)
	pass