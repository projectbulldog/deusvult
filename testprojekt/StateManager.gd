extends Node

var health : float = 100
var max_health = 100

signal on_health_changed(health)

func _ready():
	health_changed(100)

func health_changed(health):
	emit_signal("on_health_changed", health)
	
func take_Damage(damage):
	health -= damage
	health_changed(health)