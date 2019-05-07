extends KinematicBody2D

const GRAVITY = 3500
const SPEED = 850
const JUMP_SPEED = -1000
const MAXJUMP_SPEED = -10000
const MAXJUMPMOTION = -1100

var motion = Vector2()

enum DIRECTION { RIGHT = 1, LEFT = -1}
var direction = DIRECTION.RIGHT

var jumpTime = 0
var canJump = true

var canDash = true
var isDashing = false
var dashTimeLength = 0
var maxDashTime = 0.15

var dashCooldown = 2.0
var dashCooldownTimer

var isAttacking = false
var isAttackCooldown = false
var attackCooldown = 0.3
var attackCooldownTimer = 0.0

var isOnFloorWithCoyote = false
var coyoteTime = 0.0
var maxCoyoteTime = 0.1

func _ready():
	dashCooldownTimer = Timer.new()
	dashCooldownTimer.one_shot = true
	dashCooldownTimer.wait_time = dashCooldown
	self.add_child(dashCooldownTimer)
	dashCooldownTimer.connect("timeout", self, "on_dashCooldownTimer_timeout")
	set_camera_limits()
	
func on_dashCooldownTimer_timeout():
	canDash = true
	
func set_camera_limits():
#	Camera darf maximal bis zu den Ecken der Blackbox gehen (topleft, topright, bottomleft, bottom right)
	var blackBoxTileMap = get_parent().find_node("BlackBox")
	var map_limits = blackBoxTileMap.get_used_rect()
	var map_cellsize = blackBoxTileMap.cell_size
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _physics_process(delta):
	# GRAVITY
	var lastMotionY = motion.y
	motion.y += delta * GRAVITY
	
#	Test CameraShake
	if Input.is_key_pressed(KEY_Q):
		$Camera2D.start_shake()

	# LEFT / RIGHT MOVEMENT
	if Input.is_action_pressed("ui_right") && (!isAttacking || direction == DIRECTION.RIGHT):
		if direction == DIRECTION.LEFT:
			$Sprite.scale.x *= -1
			direction = DIRECTION.RIGHT
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left") && (!isAttacking || direction == DIRECTION.LEFT):
		if direction == DIRECTION.RIGHT:
			$Sprite.scale.x *= -1
			direction = DIRECTION.LEFT
		motion.x = -SPEED
	else:
		motion.x = 0
		
	# DASH
	if Input.is_action_just_pressed("dash") && canDash:
		canDash = false
		isDashing = true
		dashCooldownTimer.start()
		$Sprite/DashParticles.emitting = true
	
	if isDashing && dashTimeLength <= maxDashTime:
		motion.y = 0
		motion.x = direction * SPEED * 5.0
		dashTimeLength += delta
	if isDashing && dashTimeLength > maxDashTime:
		isDashing = false
		dashTimeLength = 0
	
	# Coyote Time
	if !is_on_floor() && coyoteTime <= maxCoyoteTime:
		coyoteTime += delta
		isOnFloorWithCoyote = true
	elif !is_on_floor():
		isOnFloorWithCoyote = false
	else:
		coyoteTime = 0
		isOnFloorWithCoyote = true
	
	# JUMPING
	if Input.is_action_pressed("jump") && jumpTime <= 0 && canJump && !is_on_ceiling():
		motion.y = JUMP_SPEED
		jumpTime = 0.01
		if(is_on_wall()):
			motion.x = -direction * 2000;
	elif Input.is_action_pressed("jump") && jumpTime < 0.3 && canJump && !is_on_ceiling():
#		motion.y = max(motion.y + (JUMP_SPEED * delta * 2), MAXJUMP_SPEED)
#		motion.y = min(motion.y, 0)
#		motion.y = max(motion.y, MAXJUMPMOTION)
		motion.y += motion.y * delta * 3.3
		jumpTime += delta
	elif !Input.is_action_pressed("jump") && jumpTime > 0:
		canJump = false
	if !isOnFloorWithCoyote && jumpTime == 0:
		canJump = false
	
	if is_on_floor():
		jumpTime = 0
		canJump = true
	if is_on_ceiling():
		canJump = false
		motion.y = delta * GRAVITY
	
#	Wall Jump
	if is_on_wall() && !Input.is_action_pressed("jump"):
		motion.y = 0
		canJump = true
		jumpTime = 0
	
#	Wenn Angriff, dann Movement verlangsamen (Nur am Boden)
	if isOnFloorWithCoyote && isAttacking:
		motion.x *= 0.6
	
#	Das benötigt es, sonst ist die Kamera hackelig, da sie nicht gleichzeitig geupdated wird.
	$Camera2D.align()
	
#	Hauptbewegung
	motion = move_and_slide(motion, Vector2(0, -1))
	
#	Camera Shake, wenn gewisse höhe erreicht wird
	if(lastMotionY - motion.y) > 2500:
		$Camera2D.start_shake()
	
	if(isAttackCooldown):
		attackCooldownTimer += delta
	
	if isAttackCooldown && attackCooldownTimer >= attackCooldown:
		attackCooldownTimer = 0
		isAttackCooldown = false
	
#	Attack
	if Input.is_action_just_pressed("attack") && !isAttacking && !isAttackCooldown:
		isAttacking = true
		isAttackCooldown = true

func _process(delta):
#	Entscheidung, welche Animation gespielt werden soll.
	if isAttacking && !("Attack" in $Sprite/AnimationTree.playback.get_current_node()):
		if Input.is_action_pressed("ui_up") && Input.get_action_strength("ui_up") > 0.8:
			travelTo("Attack_Up")
		else:
			travelTo("Attack")
	elif( !("Attack" in $Sprite/AnimationTree.playback.get_current_node())) || !isAttacking:
		if(!is_on_floor()):
			if(motion.y > 0):
				travelTo("JumpDown")
			elif(motion.y < 0):
				travelTo("Jump")
		else:
			if(motion.x != 0):
				travelTo("Walk")
			else:
				travelTo("Idle")

func attack():
#	Alle überlappenden Elemente durchgehen und wenn sie Damageable sind, ihnen Schaden zufügen
	var bodies = $Sprite/Slash/Area2D.get_overlapping_bodies()
	for body in bodies:
		if(body.is_in_group("Damageable")):
			body.takeDamage()
	var areas = $Sprite/Slash/Area2D.get_overlapping_areas()
	for area in areas:
		if(area.is_in_group("Damageable")):
			area.takeDamage()
	$Sprite/Slash/Area2D.connect("body_entered", self, "on_body_entered_attack")
	$Sprite/Slash/Area2D.connect("area_entered", self, "on_body_entered_attack")

func on_body_entered_attack(body):
#	Animation geht ein paar milisekunden -> In dieser Zeit neue Bodies auch Schaden zufügen
	if(body.is_in_group("Damageable")):
		body.takeDamage()
	
func takeDamage(damage):
	$StateManager.take_Damage(damage)
	
func travelTo(animation):
	$Sprite/AnimationTree.playback.travel(animation)

func attackFinished():
#	Nach Animation soll nicht mehr jeder Neue Body Schaden bekommen
	isAttacking = false
	if $Sprite/Slash/Area2D.is_connected("body_entered", self, "on_body_entered_attack"):
		$Sprite/Slash/Area2D.disconnect("body_entered", self, "on_body_entered_attack")
	if $Sprite/Slash/Area2D.is_connected("area_entered", self, "on_body_entered_attack"):
		$Sprite/Slash/Area2D.disconnect("area_entered", self, "on_body_entered_attack")

