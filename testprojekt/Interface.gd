extends CanvasLayer

func _on_StateManager_on_health_changed(health):
	$Tween.interpolate_property($ProgressBar, "value", $ProgressBar.value, health, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
