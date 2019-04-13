extends Camera2D

export var shake_power = 4
export var shake_time = 0.2
var isShake = false
var curPos
var elapsedtime = 0

func _ready():
    randomize()
    curPos = offset

func _process(delta):
    if isShake:
        shake(delta)
		
func start_shake():
	isShake = true

func shake(delta):
	if elapsedtime<shake_time:
		offset += Vector2(randf() -0.5, randf() - 0.5) * shake_power
		self.rotate(0.2)
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		offset = curPos 