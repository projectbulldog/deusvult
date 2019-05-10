extends Area2D

export var zoomMultiplication = 0.9

func _ready():
	self.connect("body_entered", self, "on_body_entered")
	self.connect("body_exited", self, "on_body_exit")
	
func on_body_entered(body):
	if(body.is_in_group("Player")):
		body.CueSignal(self, Vector2(zoomMultiplication, zoomMultiplication))

func on_body_exit(body):
	if(body.is_in_group("Player")):
		body.CueSignal(null, null)