extends KinematicBody2D

signal health_changed
export var battery = 100;
export var battery_drain = .5
export var battery_recharge = .25
export var health = 100;
export var speed = 100



var flashlight_enabled = true
var screen_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() *speed* delta
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	move_and_collide(velocity)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Change flashlight direction based on arrow keys
	if Input.is_action_pressed("light_right"):
		$LightOccluder2D.rotation_degrees = $LightOccluder2D.rotation_degrees + 1 
		$FlashlightBeam/CollisionShape2D.rotation_degrees = 0
	if Input.is_action_pressed("light_left"):
		$LightOccluder2D.rotation_degrees = $LightOccluder2D.rotation_degrees - 1
		$FlashlightBeam/CollisionShape2D.rotation_degrees=180
	if Input.is_action_pressed("light_back"):
		$LightOccluder2D.rotation_degrees = 90
		$FlashlightBeam/CollisionShape2D.rotation_degrees = 90
	if Input.is_action_pressed("light_forward"):
		$LightOccluder2D.rotation_degrees = 270
		$FlashlightBeam/CollisionShape2D.rotation_degrees = 270
	if Input.is_action_pressed(("ui_accept")):
		if flashlight_enabled:
			$Light2D.enabled = true
			$FlashlightBeam/CollisionShape2D.disabled = false
	else:
		$Light2D.enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true

	if $Light2D.enabled:
		battery -= battery_drain
	else:
		battery += battery_recharge
		
	battery = clamp(battery, 0, 100)
	
	if battery == 0:
		$Light2D.enabled = false
		flashlight_enabled = false
		$FlashlightBeam/CollisionShape2D.disabled = true
	if battery > 30:
		flashlight_enabled = true


func _on_HurtTimer_timeout():
	$CollisionShape2D.disabled = false
	$AnimatedSprite.set_modulate(Color(1,1,1))


func _on_Area2D_area_entered(area):
	if area.get_name() != "FlashlightBeam":
		health -= 25
		$CollisionShape2D.set_deferred("disabled", true)
		$HurtTimer.start()
		$AnimatedSprite.set_modulate(Color(1,0,0))
		emit_signal("health_changed", health)
	elif area.get_name() == "HealthPotion":
		health = 100
		$PotionSound.play()
		emit_signal("health_changed", health)
