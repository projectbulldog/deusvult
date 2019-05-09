extends Camera2D

export var shake_power = 10
export var shake_time = 0.3
var isShake = false
var curPos
var elapsedtime = 0

var lookDown = false

var player
var objectToFollow

var lerpPlayer = 0.1
var lerpObject = 0.05
var currentLerp = lerpPlayer

var lerpOffset

var lerpZoom
var originalZoom

func _ready():
	randomize()
	lerpOffset = self.offset
	originalZoom = self.zoom
	lerpZoom = self.zoom
	set_camera_limits()
	player = get_parent().find_node("Player")

func set_camera_limits():
#	Camera darf maximal bis zu den Ecken der Blackbox gehen (topleft, topright, bottomleft, bottom right)
	var blackBoxTileMap = get_parent().find_node("BlackBox")
	var map_limits = blackBoxTileMap.get_used_rect()
	var map_cellsize = blackBoxTileMap.cell_size
	self.limit_left = map_limits.position.x * map_cellsize.x
	self.limit_right = map_limits.end.x * map_cellsize.x
	self.limit_top = map_limits.position.y * map_cellsize.y
	self.limit_bottom = map_limits.end.y * map_cellsize.y

func _physics_process(delta):
	self.offset = lerp(self.offset, lerpOffset, 0.02)
	if(objectToFollow != null):
		currentLerp =  lerp(currentLerp, lerpObject, 1)
#		Falls nicht Spieler angezeigt werden soll: Vector zwischen Spieler und Objekt / 3
		var vectorTo = player.global_position - objectToFollow.global_position
		self.position = lerp(self.global_position, player.global_position - vectorTo / 3, currentLerp)
		print(self.zoom)
		print(lerpZoom)
		self.zoom = lerp(self.zoom, lerpZoom, 0.02)
	else:
		currentLerp =  lerp(currentLerp, lerpPlayer, 0.001)
		self.position = lerp(self.global_position, player.global_position, currentLerp)
		self.zoom = lerp(self.zoom, lerpZoom, 0.02)

func setObjectToFollow(object, newZoom):
	self.objectToFollow = object
	if(newZoom != null):
		lerpZoom = newZoom
	else:
		lerpZoom = originalZoom

func _process(delta):
	if isShake:
		shake(delta)
		
	if Input.is_action_pressed("lookDown"):
		lookDown = true
	if lookDown && !Input.is_action_pressed("lookDown"):
		lookDown = false
	
	if lookDown:
		self.offset.y += lerp(self.offset.y, lerpOffset.y + 500, 10) * delta

func start_shake():
	isShake = true
#	self.rotating = true

func changeDirection():
	lerpOffset.x *= -1

func shake(delta):
	if elapsedtime<shake_time:
		offset += Vector2(randf() -0.5, randf() - 0.5) * shake_power
#		self.rotation_degrees += (randf()-0.5)
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		self.rotation = 0
#		self.rotating = false