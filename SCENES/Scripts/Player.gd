extends KinematicBody2D

signal health_changed
signal directionChanged
export var battery = 100
export var health = 100
export var speed = 400
var flashlight_enabled = true
var interaction_target = null

var hasBrassKey = false

var screen_size
var playerDirection = 0
var prevPlayerDir = 0
var prevAnimation = "walk_right"
var lightOn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$InteractPrompt.visible = false
	#Set starting conditions
	


func _physics_process(_delta):
	var velocity = Vector2()
	#Change player movement direction based on w,a,s,d, keys
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	move_and_slide(velocity)

	if velocity.x >0:
		if lightOn:
			$AnimatedSprite.animation = "light_right"
		else:
			$AnimatedSprite.animation = "walk_right"
			prevAnimation = "walk_right"
		playerDirection = 0
		$InteractionArea/CollisionShape2D.position = Vector2 (100,0)
		if prevPlayerDir != 0:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
	elif velocity.x < 0:
		if lightOn:
			$AnimatedSprite.animation = "light_left"
		else:
			$AnimatedSprite.animation = "walk_left"
			prevAnimation = "walk_left"
		playerDirection = 180
		$InteractionArea/CollisionShape2D.position = Vector2 (-100,0)
		if prevPlayerDir != 180:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
	elif velocity.y > 0:
		if lightOn:
			$AnimatedSprite.animation = "light_down"
		else:
			$AnimatedSprite.animation = "walk_down"
			prevAnimation = "walk_down"
		playerDirection = 90
		$InteractionArea/CollisionShape2D.position = Vector2 (20,120)
		if prevPlayerDir != 90:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
	elif velocity.y < 0:
		if lightOn:
			$AnimatedSprite.animation = "light_up"
		else:
			$AnimatedSprite.animation = "walk_up"
			prevAnimation = "walk_up"
		playerDirection = 270
		$InteractionArea/CollisionShape2D.position = Vector2 (20,-120)
		if prevPlayerDir != 270:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Change flashlight direction based on arrow keys
	if Input.is_action_pressed("light_right"):
		if $LightOccluder2D.rotation_degrees < playerDirection + 90:
			$LightOccluder2D.rotation_degrees += 1
			$FlashlightBeam/CollisionShape2D.rotation_degrees += 1
	if Input.is_action_pressed("light_left"):
		if $LightOccluder2D.rotation_degrees > playerDirection - 90:
			$LightOccluder2D.rotation_degrees -= 1
			$FlashlightBeam/CollisionShape2D.rotation_degrees -= 1
	if Input.is_action_pressed("light_forward"): #sets light to face same direction as player
		$LightOccluder2D.rotation_degrees = playerDirection
		$FlashlightBeam/CollisionShape2D.rotation_degrees = playerDirection

	if Input.is_action_pressed(("ui_accept")):
		if playerDirection == 0:
			$AnimatedSprite.animation = "light_right"
		elif playerDirection == 180:
			$AnimatedSprite.animation = "light_left"
		elif playerDirection == 270:
			$AnimatedSprite.animation = "light_up"
		elif playerDirection == 90:
			$AnimatedSprite.animation = "light_down"
		if flashlight_enabled:
			lightOn = true
			$Light2D.enabled = true
			$FlashlightBeam/CollisionShape2D.disabled = false
	else:
		lightOn = false
		$Light2D.enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true
		$AnimatedSprite.animation = prevAnimation

	if $Light2D.enabled:
		battery -= .5
	else:
		battery += .25
	battery = clamp(battery, 0, 100)
	
	if battery == 0:
		$Light2D.enabled = false
		flashlight_enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true
	if battery > 30:
		flashlight_enabled = true
	if interaction_target != null && Input.is_action_just_pressed("interact"):
		interaction_target.interact_action($InteractionArea)


func _on_HurtTimer_timeout():
	$Hitbox/CollisionShape2D2.disabled = false
	$AnimatedSprite.set_modulate(Color(1,1,1))


func _on_Player_directionChanged():
	$LightOccluder2D.rotation_degrees = playerDirection
	$FlashlightBeam/CollisionShape2D.rotation_degrees = playerDirection
	if playerDirection == 0:
		$Light2D.position = Vector2 (70, -15)
		$LightOccluder2D.position = Vector2 (70, -15)
		$FlashlightBeam.position = Vector2 (70, -15)
	elif playerDirection == 90:
		$Light2D.position = Vector2 (-42, -15)
		$LightOccluder2D.position = Vector2 (-42, -15)
		$FlashlightBeam.position = Vector2 (-42, -15)
	elif playerDirection == 180:
		$Light2D.position = Vector2 (-60, -10)
		$LightOccluder2D.position = Vector2 (-60, -10)
		$FlashlightBeam.position = Vector2 (-60, -10)
	elif playerDirection == 270:
		$Light2D.position = Vector2 (50, -5)
		$LightOccluder2D.position = Vector2 (50, -5)
		$FlashlightBeam.position = Vector2 (50, -5)

func _on_Hitbox_area_entered(area):
	if area.get("TYPE") == "HPOTION":
		health = 100
		$PotionSound.play()
		emit_signal("health_changed", health)
		area.queue_free()
	if area.get("TYPE") == "GHOST":
		health -= 25
		$Hitbox/CollisionShape2D2.set_deferred("disabled", true)
		$HurtTimer.start()
		$AnimatedSprite.set_modulate(Color(1,0,0))
		emit_signal("health_changed", health)
	if area.get("TYPE") == "BKEY":
		hasBrassKey = true
		get_parent().get_node("HUD/Inventory Background/BrassKey").visible = true
		$ItemPickup.play()
		area.queue_free()


func _on_InteractionArea_area_entered(area):
	if area.has_method("interact_action"):
		interaction_target = area
		$InteractPrompt.visible = true
		$InteractPrompt.play()


func _on_InteractionArea_area_exited(_area):
	interaction_target = null
	$InteractPrompt.stop()
	$InteractPrompt.visible = false
	
