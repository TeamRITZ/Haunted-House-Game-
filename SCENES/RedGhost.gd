extends KinematicBody2D

export var speed = 125
export var hp = 125
var harm = false
var prevAnimation

var state = "Rest"
var player_in_range = false
var player_in_sight = false
var player_seen
var follow_direction
var player_position

onready var player = get_parent().get_node("Player")
onready var start_position = get_global_position()

func ready():
	$HealthBar/HealthBar.max_value = hp
	$HealthBar/HealthBar.value = hp

onready var path_follow = get_parent()

func _physics_process(delta):
	SightCheck()

func _process(delta):
	$AnimatedSprite.play()
	match state:
		"Rest":
			pass
		"Follow":
			#print("charge!")
			Follow(delta)
		"Return":
			Return(delta)
	
	#Checks if ghost is in flashlight beam
	if harm:
		hp -= 1
		$HealthBar._on_health_updated(hp, hp-1)
	if hp <=0:
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
func Follow(delta):
	follow_direction = (get_angle_to(player_position) / 3.14) * 180
	AnimationLoop()
	var move_rotation = get_angle_to(player_position)
	var motion = Vector2(speed,0).rotated(move_rotation)
	move_and_slide(motion)

func Return(delta):
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
			else:
				player_in_sight = false
				print("Sight blocked")
				state = "Return"
	else: 
		state = "Return"			

func _on_BodyArea_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		harm = true
		speed = speed / 3
		$GhostHurtSound.play()


func _on_BodyArea_area_exited(area):
	
	if area.get_name() == "FlashlightBeam":
		harm = false
		speed = speed * 3
