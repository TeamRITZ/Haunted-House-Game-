extends KinematicBody2D

export var battery = 100;
export var health = 100;
var flashlight_enabled = true
export var speed = 400
signal health_changed
signal directionChanged
var screen_size
var playerDirection = 0
var prevPlayerDir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
		if flashlight_enabled:
			$Light2D.enabled = true
			$FlashlightBeam/CollisionShape2D.disabled = false
	else:
		$Light2D.enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	
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
	if velocity.x >0:
		$AnimatedSprite.animation = "walk_right"
		playerDirection = 0
		if prevPlayerDir != 0:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
	elif velocity.x < 0:
		$AnimatedSprite.animation = "walk_left"
		playerDirection = 180
		if prevPlayerDir != 180:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
	elif velocity.y > 0:
		$AnimatedSprite.animation = "walk_down"
		playerDirection = 90
		if prevPlayerDir != 90:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection
	elif velocity.y < 0:
		$AnimatedSprite.animation = "walk_up"
		playerDirection = 270
		if prevPlayerDir != 270:
			emit_signal("directionChanged")
			prevPlayerDir = playerDirection

func _on_Player_area_entered(area):
	print(area.get_name())
	if area.get_name() == "HealthPotion":
		health = 100
		$PotionSound.play()
		emit_signal("health_changed", health)
	if area.get_name() != "FlashlightBeam" and area.get_name() != "HealthPotion":
		health -= 25
		$CollisionShape2D.set_deferred("disabled", true)
		$HurtTimer.start()
		$AnimatedSprite.set_modulate(Color(1,0,0))
		emit_signal("health_changed", health)
	
func _on_HurtTimer_timeout():
	$CollisionShape2D.disabled = false
	$AnimatedSprite.set_modulate(Color(1,1,1))


func _on_Player_directionChanged():
	$LightOccluder2D.rotation_degrees = playerDirection
	$FlashlightBeam/CollisionShape2D.rotation_degrees = playerDirection
