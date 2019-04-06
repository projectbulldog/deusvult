extends CanvasLayer

func _on_StateManager_on_health_changed(health):
	$ProgressBar.value = health
