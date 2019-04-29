extends Camera2D

func _on_Camera2D_draw():
	$UI.rect_size = self.get_viewport_rect().size
