extends Area2D

export (bool) var useCollisionShapeHeight = true
export (float) var width

var camera

func _ready():
	camera = get_tree().get_root().get_node("World").find_node("Camera2D")

func _on_Area2D2_body_entered(body):
	if(body.is_in_group("Player")):
#		ToDo: Höhe per parameter setzen können
		var position = width
		if useCollisionShapeHeight: position = $CollisionShape2D.global_position.x
		camera.SetCameraModeOnRailY(position)


func _on_Area2D2_body_exited(body):
	if(body.is_in_group("Player")):
		camera.SetCameraModeDefault(Enums.CAMERAMODE.ONRAILY)
