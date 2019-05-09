extends Area2D

export var zoom = 1.8

func _ready():
	self.connect("body_entered", self, "on_body_entered")
	self.connect("body_exited", self, "on_body_exit")
	
func on_body_entered(body):
	if(body.is_in_group("Player")):
		body.CueSignal(self, Vector2(zoom, zoom))

func on_body_exit(body):
	if(body.is_in_group("Player")):
		body.CueSignal(null, null)