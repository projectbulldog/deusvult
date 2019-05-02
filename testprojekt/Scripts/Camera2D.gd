extends Camera2D

export var shake_power = 10
export var shake_time = 0.2
var isShake = false
var curPos
var elapsedtime = 0

var lookDown = false

func _ready():
    randomize()
    curPos = offset

func _process(delta):
	if isShake:
		shake(delta)
		
	if Input.is_action_pressed("lookDown"):
		lookDown = true
	if lookDown && !Input.is_action_pressed("lookDown"):
		lookDown = false
	
	if lookDown:
		self.offset.y += lerp(self.offset.y, curPos.y + 500, 10) * delta
	elif self.offset.y != curPos.y:
		self.offset.y += lerp(self.offset.y, curPos.y, 10) * delta

func start_shake():
	isShake = true
	self.rotating = true

func shake(delta):
	if elapsedtime<shake_time:
		offset += Vector2(randf() -0.5, randf() - 0.5) * shake_power
		self.rotation_degrees += (randf()-0.5)
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		offset = curPos
		self.rotating = false