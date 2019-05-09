extends Area2D

func takeDamage():
	get_parent().remove_child(self)