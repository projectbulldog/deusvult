extends Area2D

var direction = Vector2(0, 0)

var target = Vector2(0, 0)

func _ready():
	defineTarget()
	
func _physics_process(delta):
	if (target-self.position).length() < 1:
		defineTarget()
	
	if target != null:
		var motion = Vector2(round(target.x - self.position.x), round(target.y - self.position.y))
		motion = motion.normalized()
		translate(motion)
		
func defineTarget():
	target = Vector2(self.position.x + random(), self.position.y + random())

func random():
    randomize()
    return randf()*601 - 300.0

func takeDamage():
	self.remove_and_skip()