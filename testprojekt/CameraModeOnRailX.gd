extends Area2D

export (bool) var useCollisionShapeHeight = true
export (float) var height

var camera

func _ready():
	camera = get_tree().get_root().get_node("World").find_node("Camera2D")

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player")):
#		ToDo: Höhe per parameter setzen können
		var position = height
		if useCollisionShapeHeight: position = $CollisionShape2D.global_position.y
		camera.SetCameraModeOnRailX(position)

func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		camera.SetCameraModeDefault()
