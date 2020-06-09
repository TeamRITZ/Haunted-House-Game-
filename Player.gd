extends Area2D

export var battery = 100;
export var health = 100;
export var speed = 400
export var battery_drain = 0.5
export var battery_recharge = 0.25
var flashlight_enabled = true

signal health_changed
var screen_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#movement on arrow keys
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	#flashlight on space bar
	if Input.is_action_pressed(("ui_accept")):
		if flashlight_enabled:
			$Light2D.enabled = true
			$FlashlightBeam/CollisionShape2D.disabled = false
	#turns off flashlight when key released
	else:
		$Light2D.enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true
	#makes sure diagonal movement is the same speed as horizontal or vertical
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	#flashlight battery drain, recharge
	if $Light2D.enabled:
		battery -= battery_drain
	else:
		battery += battery_recharge
	#Keeps battery between 0 and 100
	battery = clamp(battery, 0, 100)
	
	#if battery hits zero, turns off the light, disables flashlight until
	# recharged to at least 30
	if battery == 0:
		$Light2D.enabled = false
		flashlight_enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true
	if battery > 30:
		flashlight_enabled = true
		
	# handles sprite and flashlight rotation based on movement direction
	if velocity.x != 0:
		$AnimatedSprite.animation = "side"
		$LightOccluder2D.rotation_degrees = 0
		$FlashlightBeam/CollisionShape2D.rotation_degrees = 0
		$AnimatedSprite.flip_h = velocity.x < 0
		if $AnimatedSprite.flip_h:
			$LightOccluder2D.rotation_degrees = 180
			$FlashlightBeam/CollisionShape2D.rotation_degrees=180
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
		$LightOccluder2D.rotation_degrees = 90
		$FlashlightBeam/CollisionShape2D.rotation_degrees = 90
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"
		$LightOccluder2D.rotation_degrees = 270
		$FlashlightBeam/CollisionShape2D.rotation_degrees = 270

	

# player taks 25 hp damage on enemy contact. Color turns red, hit detection
# temporarily turned off
func _on_Player_area_entered(area):
	if area.get_name() != "FlashlightBeam": # don't want the flashlight to hurt us
		health -= 25
		$CollisionShape2D.set_deferred("disabled", true)
		$HurtTimer.start()
		$AnimatedSprite.set_modulate(Color(1,0,0))
		emit_signal("health_changed", health)

# Restores hit detection and normal color
func _on_HurtTimer_timeout():
	$CollisionShape2D.disabled = false
	$AnimatedSprite.set_modulate(Color(1,1,1))
