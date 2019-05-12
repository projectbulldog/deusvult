extends Area2D

func takeDamage(damageFrom = Vector2(0, 0)):
	get_parent().remove_child(self)