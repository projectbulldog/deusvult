extends Node

var healthPoints : float = 5
var max_healthPoints = 5

signal on_health_changed(health)

func _ready():
	health_changed(5)

func health_changed(health):
	emit_signal("on_health_changed", health)
	
func take_Damage(points):
	healthPoints -= points;
	health_changed(healthPoints);