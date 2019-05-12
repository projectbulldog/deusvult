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

var noiseX
var noiseY

var trauma = 0
var trauma_depletion = 0.9
var max_camera_offset = 100

# normal time is too slow?
var offset_time_factor = 2

var fallingCorrectionY = 500

var lerpCorrectionY = 1
var correctionY = 0

var cameraMode = Enums.CAMERAMODE.DEFAULT

var cameraModeRailXHeight = 0
var cameraModeRailYWidth = 0

func _ready():
	randomize()
	lerpOffset = self.offset
	originalZoom = self.zoom
	lerpZoom = self.zoom
	set_camera_limits()
	player = get_parent().find_node("Player")
	noiseX = OpenSimplexNoise.new()
	noiseY = OpenSimplexNoise.new()
	
	noiseX.seed = randi()
	noiseY.seed = randi()

func SetCameraModeDefault(cameraModeFrom):
	if(cameraModeFrom == cameraMode):
		self.cameraMode = Enums.CAMERAMODE.DEFAULT
		currentLerp = 0.02

func SetCameraModeOnRailX(height = null):
	self.cameraMode = Enums.CAMERAMODE.ONRAILX
	cameraModeRailXHeight = height
	currentLerp = 0
	
func SetCameraModeOnRailY(width = null):
	self.cameraMode = Enums.CAMERAMODE.ONRAILY
	cameraModeRailYWidth = width
	currentLerp = 0

func set_camera_limits():
#	Kamera darf maximal bis zu den Ecken der Blackbox gehen (topleft, topright, bottomleft, bottom right)
#	var blackBoxTileMap = get_tree().get_root().get_node("World").find_node("BlackBox")
#	print(blackBoxTileMap)
#	var map_limits = blackBoxTileMap.get_used_rect()
#	var map_cellsize = blackBoxTileMap.cell_size
#	self.limit_left = map_limits.position.x * map_cellsize.x
#	self.limit_right = map_limits.end.x * map_cellsize.x
#	self.limit_top = map_limits.position.y * map_cellsize.y
#	self.limit_bottom = map_limits.end.y * map_cellsize.y
	pass

func _physics_process(delta):
	if(cameraMode == Enums.CAMERAMODE.DEFAULT):
		mode_Default(delta)
	if(cameraMode == Enums.CAMERAMODE.ONRAILX):
		mode_RailX(delta)
	if(cameraMode == Enums.CAMERAMODE.ONRAILY):
		mode_RailY(delta)

	self.offset = lerp(self.offset, lerpOffset, 0.02)
	if(objectToFollow != null):
#		Nicht ruckartig schneller werden, sondern langsam über Zeit
		currentLerp =  lerp(currentLerp, lerpObject, 1)
#		Falls nicht Spieler angezeigt werden soll: Vector zwischen Spieler und Objekt / 3
#		Somit wird nicht voll auf das Objekt gezoomt, sonder nur in die Richtung
		var vectorTo = player.global_position - objectToFollow.global_position
		self.global_position = lerp(self.global_position, player.global_position - vectorTo / 3, currentLerp)
		self.zoom = lerp(self.zoom, lerpZoom, 0.02)

	if lookDown:
		self.offset.y = lerp(self.offset.y, lerpOffset.y + 500, 0.1)

func mode_RailY(delta):
		var lerpMotion = Vector2(0,0)
		currentLerp =  lerp(currentLerp, lerpPlayer * 2, 0.02)
		lerpMotion.x = lerp(self.global_position.x, cameraModeRailYWidth, 0.02)
		lerpMotion.y = lerp(self.global_position.y, player.global_position.y, currentLerp)
		self.global_position = lerpMotion
		self.zoom = lerp(self.zoom, lerpZoom, 0.02)

func mode_RailX(delta):
		var lerpMotion = Vector2(0,0)
		currentLerp = lerp(currentLerp, lerpPlayer, 0.01)
		lerpMotion.x = lerp(self.global_position.x, player.global_position.x, currentLerp)
		lerpMotion.y = lerp(self.global_position.y, cameraModeRailXHeight, 0.01)
		self.global_position = lerpMotion
		self.zoom = lerp(self.zoom, lerpZoom, 0.02)

func mode_Default(delta):
#	Nicht ruckartig schneller werden, sondern langsam über Zeit
	currentLerp =  lerp(currentLerp, lerpPlayer, 0.002)

#	Kamera soll nach oben langsamer gehen. Nach unten soll sie schneller sein damit man was sieht
	if (player.motion.y > 0):
		lerpCorrectionY = lerp(lerpCorrectionY, 3, 0.03)
		if(player.motion.y > 2000):
			correctionY = lerp(correctionY, 600, 0.01)
	else:
		lerpCorrectionY = lerp(lerpCorrectionY, 0.6, 0.2)
		correctionY = lerp(correctionY, 0, 0.1)

#	Berechnung der Bewegung
	var lerpMotion = Vector2(0,0)

#	Kamera soll beim hinunterspringen weiter nach unten schau
#	ToDo noch keine schöne lösung
	lerpMotion.x = lerp(self.global_position.x, player.global_position.x, currentLerp)
	lerpMotion.y = lerp(self.global_position.y, player.global_position.y + correctionY, currentLerp * lerpCorrectionY)
	self.global_position = lerpMotion
	self.zoom = lerp(self.zoom, lerpZoom, 0.02)


func setObjectToFollow(object, zoomMultiplication):
	self.objectToFollow = object
	if(zoomMultiplication != null):
		lerpZoom *= zoomMultiplication
	else:
		lerpZoom = originalZoom

func _process(delta):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	if isShake:
		shake(delta)
		
	if Input.is_action_pressed("lookDown"):
		lookDown = true
	if lookDown && !Input.is_action_pressed("lookDown"):
		lookDown = false

func add_trauma(traumaAdd):
	isShake = true
	trauma += traumaAdd
	trauma = min(trauma, 1)
#	self.rotating = true

func changeDirection():
	lerpOffset.x *= -1

func shake(delta):
#	Je nach Trauma level (0 - 1) wird ein camera shake ausgelöst.
#	Je höher Traume, desto stärker der Effekt
	if trauma > 0:
		# translation
		var offset = Vector2()
		offset.x = noiseX.get_noise_2d(delta * offset_time_factor, randf() -0.5)
		offset.y = noiseY.get_noise_2d(randf() - 0.5, delta * offset_time_factor) * 2
		offset *= max_camera_offset * shake_power * pow(trauma, 2) # squared or cubed
		# not global position, this is relative to parent
		# (normally camera position is 0,0)
		self.global_position += offset
		
		# trauma decreases linearly over time
		var new_trauma = trauma - (trauma_depletion * delta)
		trauma = clamp(new_trauma, 0, 1)
	else: isShake = false