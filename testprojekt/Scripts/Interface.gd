extends CanvasLayer

export var shader : ShaderMaterial;

var showDamage = false
var damageTime = 0.0
var maxDamageTime = 1.0

func _on_StateManager_on_health_changed(health, isDamage):
	$Tween.interpolate_property($ProgressBar, "value", $ProgressBar.value, health, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
	$TextureProgress.value = health
	if(isDamage):
		$ColorRect.material = shader
		$ColorRect.visible = true
		get_parent().start_shake()
		showDamage = true
		
func _process(delta):
	if(showDamage && damageTime <= maxDamageTime):
		damageTime += delta
	elif(damageTime >= maxDamageTime):
		showDamage = false
		damageTime = 0.0
		$ColorRect.material = null
		$ColorRect.visible = false