extends KinematicBody2D

export var speed = 125
export var hp = 125
export var dropBrassKey = false
var harm = false
var prevAnimation

var state = "Rest"
var player_in_range = false
var player_in_sight = false
var player_seen
var follow_direction
var player_position
var dead = false

var rng = RandomNumberGenerator.new()
var potion_scene = preload("res://SCENES/HealthPotion.tscn")
var brass_key_scene = preload("res://SCENES/brassKey.tscn")

onready var player = get_parent().get_node("Player")
onready var start_position = get_global_position()

func ready():
	$HealthBar._on_max_health_updated(hp)
	$HealthBar._on_health_updated(hp)

onready var path_follow = get_parent()

func _physics_process(_delta):
	SightCheck()

func _process(delta):
	$AnimatedSprite.play()
	match state:
		"Rest":
			pass
			print("rest")
		"Follow":
			print("charge!")
			Follow(delta)
		"Return":
			Return(delta)
			print("return")
	
	#Checks if ghost is in flashlight beam
	if harm:
		hp -= 1
		$HealthBar._on_health_updated(hp)
	if hp <=0:
		$GhostAgro.stop()
		if dead == false:
			if dropBrassKey == true:
				var key = brass_key_scene.instance()
				get_tree().get_root().add_child(key)
				key.position = position
			else:
				rng.randomize()
				var random = rng.randf()
				if random <= 0.4: #40% cahnce to drop health potion on death
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
	follow_direction = (get_angle_to(player_position) / 3.14) * 180
	AnimationLoop()
	var move_rotation = get_angle_to(player_position)
	var motion = Vector2(speed,0).rotated(move_rotation)
	move_and_slide(motion)

func Return(_delta):
	if get_global_position() >= start_position:
		follow_direction = (get_angle_to(start_position) /3.14) * 180
		AnimationLoop()
		var move_rotation = get_angle_to(start_position)
		var motion = Vector2(speed,0).rotated(move_rotation)
		move_and_slide(motion)
	else:
		state = "Rest"
		$AnimatedSprite.animation = "down"
	
#Checks if player is in ghost's sight range
func _on_Sight_body_entered(body):
	if body == player:
		player_in_range = true
func _on_Sight_body_exited(body):
	if body == player:
		player_in_range = false

#Checks if ghost can see player I.E. No obstacles blocking line of sight.
func SightCheck():
	if player_in_range == true:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position,player.position,[self], collision_mask)
		if sight_check:
			if sight_check.collider.name == "Player":
				player_in_sight = true
				player_seen = true
				player_position = player.get_global_position()
				state = "Follow"
				if $GhostAgro.playing == false:
					$GhostAgro.play()
			else:
				player_in_sight = false
				state = "Return"
	else: 
		state = "Return"

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
