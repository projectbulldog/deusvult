extends KinematicBody2D

const GRAVITY = 981
const WALK_SPEED = 200

var velocity = Vector2()
var target : KinematicBody2D

func _process(delta):
	applyGravity(delta)
	pursueTarget(delta)

func applyGravity(delta):
	if(is_on_floor()):
		velocity.y = 0;
	else:
		velocity.y += delta * GRAVITY
		
	move_and_slide(velocity, Vector2(0, -1))
	
func pursueTarget(delta):
	if(target != null):
		var movement = Vector2(target.position.x - self.position.x, target.position.y - self.position.y)
		var unit_vector = sqrt(pow(movement.x, 2) + pow(movement.y, 2))
		translate(movement / unit_vector  * delta * WALK_SPEED)

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		self.modulate = Color(0.5, 0, 0)
		target = body


func _on_Area2D_body_exited(body):
	if(body.get_name() == "Player"):
		self.modulate = Color(1, 1, 1)
		target = null
