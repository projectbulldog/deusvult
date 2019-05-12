extends AnimationTree

var playback

func _ready():
	playback = $".".get("parameters/playback")
	self.active = true
	playback.start('Idle')