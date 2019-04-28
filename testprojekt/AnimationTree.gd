extends AnimationTree

var playback

func _ready():
	playback = $".".get("parameters/playback")
	playback.start('Idle')