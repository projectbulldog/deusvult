extends Sprite

func _ready():
	self.visible = true

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player")):
		self.visible = false
		$AudioStreamPlayer.play()

func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		self.visible = true