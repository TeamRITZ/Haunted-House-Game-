extends Area2D

export var speed = 150
var move_direction = 0
export var hp = 250
var harm = false
var prevAnimation
const TYPE = "GHOST"
var dead = false

var rng = RandomNumberGenerator.new()
var potion_scene = preload("res://SCENES/HealthPotion.tscn")
var brass_key_scene = preload("res://SCENES/brassKey.tscn")
export var dropBrassKey = false
var player

func ready():
	$HealthBar.visible = false
	$HealthBar._on_max_health_updated(hp)
	$HealthBar._on_health_updated(hp)

onready var path_follow = get_parent()

func _physics_process(delta):
	MovementLoop(delta)

#Causes ghost to follow the path
func MovementLoop(delta):
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()
	move_direction = (pos.angle_to_point(prepos) / 3.14) * 180

func _process(_delta):
	AnimationLoop()
	
	#Checks if ghost is in flashlight beam
	if harm:
		hp -= 1
		$HealthBar._on_health_updated(hp)
	if hp <=0:
		if dead == false:
			if dropBrassKey == true:
				var key = brass_key_scene.instance()
				get_tree().get_root().add_child(key)
				key.position = get_global_position()
			else:
				rng.randomize()
				var random = rng.randf()
				if random <= 0.1: #10% cahnce to drop health potion on death
					var Health_Potion = potion_scene.instance()
					get_tree().get_root().add_child(Health_Potion)
					Health_Potion.position = get_global_position()
			$GhostDeath.play()
			dead = true
			visible = false
			$CollisionShape2D.disabled = true
		if $GhostDeath.playing == false:
			player.killedWhiteGhost = true
			queue_free()

#Picks the appropriate animation based on direction of movement
func AnimationLoop():
	if move_direction <= 45 and move_direction >= -45:
		$AnimatedSprite.animation = "right"
	elif move_direction <= 135 and move_direction >= 45:
		$AnimatedSprite.animation = "down"
	elif move_direction <= -45 and move_direction >= -135:
		$AnimatedSprite.animation = "up"
	elif move_direction >= 135 or move_direction <= -135:
		$AnimatedSprite.animation = "left"

func _on_WhiteGhost_area_exited(area):
	if area.get_name() == "FlashlightBeam":
		harm = false
		speed = speed * 3
		

func _on_WhiteGhost_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		$HealthBar.visible = true
		harm = true
		speed = speed / 3
		$GhostHurtSound.play()
		player = area.get_parent()
