extends KinematicBody2D

const GRAVITY = 981
const WALK_SPEED = 300

var velocity = Vector2()

func _physics_process(delta):
	if(is_on_floor()):
		velocity.y = 0;
	else:
		velocity.y += delta * GRAVITY
		
	move_and_slide(velocity, Vector2(0, -1))