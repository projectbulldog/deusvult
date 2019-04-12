extends Area2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("Damageable"):
		body.takeDamage(1000)
