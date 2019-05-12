extends Node

var stopMovingEnemies = false


func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().quit()