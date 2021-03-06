extends KinematicBody2D

const GRAVITY = 3000
const SPEED = 800
const JUMP_SPEED = -900

const cameraShakeMotionThreshold = 3000

var friction = false

var motion = Vector2()

var DIRECTION = Enums.DIRECTION
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
var attackCooldown = 0.4
var attackCooldownTimer = 0.0

var isOnFloorWithCoyote = false
var coyoteTime = 0.0
var maxCoyoteTime = 0.1

var justWallJumped = false
var justWallJumpedTime = 0.0
var justWallJumpedMaxTime = 0.2

var canDoubleJump = true
var justDoubleJumped = false

var camera

var tookDamage = false
var invincible = false

var onWall = false

var stopMoving = false

var hasDashAbility = false
var hasDoubleJumpAbility = false
var hasWallSlideAbility = false

func _ready():
	dashCooldownTimer = Timer.new()
	dashCooldownTimer.one_shot = true
	dashCooldownTimer.wait_time = dashCooldown
	self.add_child(dashCooldownTimer)
	dashCooldownTimer.connect("timeout", self, "on_dashCooldownTimer_timeout")
	camera = get_parent().find_node("Camera2D")
	
func on_dashCooldownTimer_timeout():
	canDash = true

func changeDirection():
	$Sprite.scale.x *= -1
	direction *= -1
	camera.changeDirection()

func _physics_process(delta):
	if tookDamage:
		return

	var lastMotionY = motion.y
	# GRAVITY
	if(!tookDamage):
		motion.y += delta * GRAVITY
	
#	Test CameraShake
	if Input.is_key_pressed(KEY_Q):
		camera.add_trauma(0.3)

	# LEFT / RIGHT MOVEMENT
	if Input.is_action_pressed("ui_right") && (!isAttacking || direction == DIRECTION.RIGHT) && !justWallJumped && !isDashing && !stopMoving:
		if direction == DIRECTION.LEFT:
			self.changeDirection()
			$Sprite/AnimationTree.playback.start("Turn")
		motion.x = SPEED * clamp(Input.get_action_strength("ui_right"), 0.5, 1.0)
		friction = false
	elif Input.is_action_pressed("ui_left") && (!isAttacking || direction == DIRECTION.LEFT) && !justWallJumped && !isDashing && !stopMoving:
		if direction == DIRECTION.RIGHT:
			self.changeDirection()
			$Sprite/AnimationTree.playback.start("Turn")
		motion.x = -SPEED * clamp(Input.get_action_strength("ui_left"), 0.5, 1.0)
		friction = false
	else:
		friction = true
		if is_on_floor():
			motion.x = 0
		
	# DASH
	if(hasDashAbility):
		if Input.is_action_just_pressed("dash") && canDash:
			canDash = false
			if is_on_wall():
				self.changeDirection()
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
			motion.x = 0
	
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
	if !isOnFloorWithCoyote && !canJump && canDoubleJump && Input.is_action_just_pressed("jump") && hasDoubleJumpAbility:
		canDoubleJump = false
		justDoubleJumped = true
		motion.y = JUMP_SPEED * 1.5
	
	if Input.is_action_pressed("jump") && jumpTime <= 0 && canJump && !is_on_ceiling():
		motion.y = JUMP_SPEED
		jumpTime = 0.01
		if(!$Sprite/Jump.playing):
			$Sprite/Jump.volume_db = -20
			$Sprite/Jump.play()
#		WallJump
		if(is_on_wall() && !isOnFloorWithCoyote):
			motion.x = -direction * SPEED;
			justWallJumped = true
			stopMoving = true
			self.changeDirection()
			$StateManager/WallJumpMotionTimer.start()
	elif Input.is_action_pressed("jump") && jumpTime < 0.3 && canJump && !is_on_ceiling():
		motion.y += motion.y * delta * 3.3
		jumpTime += delta
	elif !Input.is_action_pressed("jump") && jumpTime > 0:
		canJump = false
	if !isOnFloorWithCoyote && jumpTime == 0:
		canJump = false
	
	if is_on_floor():
		jumpTime = 0
		canJump = true
		canDoubleJump = true
	if is_on_ceiling():
		canJump = false
		motion.y = delta * GRAVITY
	
#	wenn ich in der Luft bin und kein Links/Rechts input habe -> Verlangsamen in Horizontaler richtung
	if !isOnFloorWithCoyote:
		if friction:
			motion.x = lerp(motion.x, 0, 0.02)
	
#	Wall Jump
	onWall = false
	if is_on_wall() && !is_on_floor() && !Input.is_action_pressed("jump") && hasWallSlideAbility:
		motion.y = 300
		motion.x = 500 * direction
		onWall = true
		canJump = true
		jumpTime = 0
		canDoubleJump = true
	
#	Wenn gerade Walljump durchgeführt wurde -> für kurze zeit kein links/rechts laufen
	if justWallJumped && justWallJumpedTime <= justWallJumpedMaxTime:
		justWallJumpedTime += delta
	elif justWallJumped:
		justWallJumped = false
		justWallJumpedTime = 0.0
	
#	Wenn Angriff, dann Movement verlangsamen (Nur am Boden)
	if isOnFloorWithCoyote && isAttacking:
		motion.x *= 0.6
	
#	Hauptbewegung
	motion = move_and_slide(motion, Vector2(0, -1))
	
##	Camera Shake, wenn gewisse höhe erreicht wird
	if(lastMotionY - motion.y) > cameraShakeMotionThreshold && !justDoubleJumped:
		camera.add_trauma(0.8)
	
	justDoubleJumped = false
	
#	Attack Cooldown
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
	if tookDamage:
		travelTo("TakeDamage")
		return
	if isAttacking && !("Attack" in $Sprite/AnimationTree.playback.get_current_node()):
		if Input.is_action_pressed("ui_up") && Input.get_action_strength("ui_up") > 0.8:
			travelTo("Attack_Up")
		else:
			travelTo("Attack")
	elif( !("Attack" in $Sprite/AnimationTree.playback.get_current_node())) || !isAttacking:
		if(!is_on_floor()):
			if(onWall):
				travelTo("WallCling")
			elif(motion.y > 0):
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
	var bodies = $Sprite/Slash/SlashArea.get_overlapping_bodies()
	var anyOneHit = false
	for body in bodies:
		if(body.is_in_group("Damageable")):
			anyOneHit = true
			body.takeDamage(self.global_position - Vector2(0, 100))
			camera.add_trauma(0.5)
	if anyOneHit:
		$Sprite/SwordSlash.play()
		$Sprite/SwordSlashHit.play()
	else:
		$Sprite/SwordSlash.play()
	var areas = $Sprite/Slash/SlashArea.get_overlapping_areas()
	for area in areas:
		if(area.is_in_group("Damageable")):
			area.takeDamage()
#	$Sprite/Slash/SlashArea.connect("body_entered", self, "on_body_entered_attack")
#	$Sprite/Slash/SlashArea.connect("area_entered", self, "on_body_entered_attack")

#func on_body_entered_attack(body):
##	Animation geht ein paar milisekunden -> In dieser Zeit neue Bodies auch Schaden zufügen
#	if(body.is_in_group("Damageable")):
#		body.takeDamage(self.global_position)
#		if(!$Sprite/SwordSlashHit.playing):
#			$Sprite/SwordSlashHit.play()

func takeDamage(damage):
	if(!invincible):
		$StateManager.take_Damage(damage)
		tookDamage = true
		invincible = true
		GameState.stopMovingEnemies = true
		$StateManager/DamageStopMovingTimer.start()
		$StateManager/InvincibilityTimer.start()
		motion = Vector2(0.0, 0.0)
	
func travelTo(animation):
	$Sprite/AnimationTree.playback.travel(animation)

func attackFinished():
#	Nach Animation soll nicht mehr jeder Neue Body Schaden bekommen
	isAttacking = false
#	if $Sprite/Slash/SlashArea.is_connected("body_entered", self, "on_body_entered_attack"):
#		$Sprite/Slash/SlashArea.disconnect("body_entered", self, "on_body_entered_attack")
#	if $Sprite/Slash/SlashArea.is_connected("area_entered", self, "on_body_entered_attack"):
#		$Sprite/Slash/SlashArea.disconnect("area_entered", self, "on_body_entered_attack")

func _on_DamageStopMovingTimer_timeout():
	tookDamage = false
	GameState.stopMovingEnemies = false

func CueSignal(object, zoom):
	camera.setObjectToFollow(object, zoom)

func _on_InvincibilityTimer_timeout():
	invincible = false

func _on_WallJumpMotionTimer_timeout():
	stopMoving = false


# DEBUG STUFF
func _on_CheckBox_toggled(button_pressed):
	self.hasDashAbility = button_pressed


func _on_CheckBox2_toggled(button_pressed):
	self.hasDoubleJumpAbility = button_pressed


func _on_CheckBox3_toggled(button_pressed):
	self.hasWallSlideAbility = button_pressed
