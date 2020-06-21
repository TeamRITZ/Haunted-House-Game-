extends KinematicBody2D

export var speed = 100
export var hp = 80


var harm = false
var prevAnimation

var follow_direction
var player_position
var dead = false

var rng = RandomNumberGenerator.new()
var potion_scene = preload("res://SCENES/HealthPotion.tscn")

onready var player # = get_parent().get_node("Player")
onready var start_position = get_global_position()

func ready():
	$HealthBar._on_max_health_updated(hp)
	$HealthBar._on_health_updated(hp)

onready var path_follow = get_parent()

func _process(delta):
	$AnimatedSprite.play()
	Follow(delta)
	
	#Checks if ghost is in flashlight beam
	if harm:
		hp -= 1
		$HealthBar._on_health_updated(hp)
	if hp <=0:
		if dead == false:
			rng.randomize()
			var random = rng.randf()
			if random <= 0.2: #20% cahnce to drop health potion on death
				var Health_Potion = potion_scene.instance()
				get_tree().get_root().add_child(Health_Potion)
				Health_Potion.position = position
			$GhostDeath.play()
			dead = true
			visible = false
			$BodyArea/CollisionShape2D.disabled = true
			$CollisionShape2D.disabled = true
		if $GhostDeath.playing == false:
			queue_free()

#Picks the appropriate animation based on direction of movement
func AnimationLoop():
	if follow_direction <= 45 and follow_direction >= -45:
		$AnimatedSprite.animation = "right"
	elif follow_direction <= 135 and follow_direction >= 45:
		$AnimatedSprite.animation = "down"
	elif follow_direction <= -45 and follow_direction >= -135:
		$AnimatedSprite.animation = "up"
	elif follow_direction >= 135 or follow_direction <= -135:
		$AnimatedSprite.animation = "left"
	
#Ghost will follow player
func Follow(_delta):
	player_position = player.get_node("InteractionArea").get_global_position()
	follow_direction = (get_angle_to(player_position) / 3.14) * 180
	AnimationLoop()
	var move_rotation = get_angle_to(player_position)
	var motion = Vector2(speed,0).rotated(move_rotation)
	move_and_slide(motion)

func _on_BodyArea_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		$HealthBar.visible = true
		harm = true
		speed = speed / 3
		$GhostHurtSound.play()

func _on_BodyArea_area_exited(area):
	if area.get_name() == "FlashlightBeam":
		harm = false
		speed = speed * 3
