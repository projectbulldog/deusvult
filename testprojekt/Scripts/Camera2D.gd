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

func set_camera_limits():
#	Kamera darf maximal bis zu den Ecken der Blackbox gehen (topleft, topright, bottomleft, bottom right)
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
#		Nicht ruckartig schneller werden, sondern langsam über Zeit
		currentLerp =  lerp(currentLerp, lerpObject, 1)
#		Falls nicht Spieler angezeigt werden soll: Vector zwischen Spieler und Objekt / 3
#		Somit wird nicht voll auf das Objekt gezoomt, sonder nur in die Richtung
		var vectorTo = player.global_position - objectToFollow.global_position
		self.position = lerp(self.global_position, player.global_position - vectorTo / 3, currentLerp)
		self.zoom = lerp(self.zoom, lerpZoom, 0.02)
	else:
#		Nicht ruckartig schneller werden, sondern langsam über Zeit
		currentLerp =  lerp(currentLerp, lerpPlayer, 0.001)
		
#		Kamera soll nach oben langsamer gehen. Nach unten soll sie schneller sein damit man was sieht
		var lerpCorrectionY = 0.8
		if (self.global_position.y - player.global_position.y) <= 0:
			lerpCorrectionY = 3
			 
#		Berechnung der Bewegung
		var lerpMotion = Vector2(0,0)
		
#		Kamera soll beim hinunterspringen weiter nach unten schau
#		ToDo noch keine schöne lösung
		var correctionY = 0
		if(player.motion.y > 2000):
			lerpCorrectionY =  1 + pow(lerp(currentLerp, 2 + (player.motion.y - 2000) * 0.004, 0.1), 2)
			correctionY = 500
			
		lerpMotion.x = lerp(self.global_position.x, player.global_position.x, currentLerp)
		lerpMotion.y = lerp(self.global_position.y, player.global_position.y + correctionY, currentLerp * lerpCorrectionY)
		
		self.position = lerpMotion
		self.zoom = lerp(self.zoom, lerpZoom, 0.01)

func setObjectToFollow(object, zoomMultiplication):
	self.objectToFollow = object
	if(zoomMultiplication != null):
		lerpZoom *= zoomMultiplication
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
		self.position += offset
		
		# trauma decreases linearly over time
		var new_trauma = trauma - (trauma_depletion * delta)
		trauma = clamp(new_trauma, 0, 1)
	else: isShake = false