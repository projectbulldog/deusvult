extends Container

export (int) var health = 5
# warning-ignore:unused_class_variable
export (int) var max_health = 5
export (Texture) var health_texture
# warning-ignore:unused_class_variable
export (Texture) var healthLoss_texture

func _ready():
	drawHealth()

func drawHealth():
	for i in health:
		var sprite = Sprite.new()
		sprite.name = String(i)
		sprite.texture = health_texture
		sprite.scale *= 0.7
		sprite.position.x += i * 30
		self.add_child(sprite)
	
	self.get_rect().size.x = 1000
	print(self.anchor_left)

func changeHealth(newHealth):
	health = newHealth
	for child in self.get_children():
		if(int(child.name) >= health):
			child.texture = healthLoss_texture