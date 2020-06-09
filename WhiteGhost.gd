extends Area2D

export var speed = 150
var move_direction = 0
export var hp = 50
var harm = false
var prevAnimation

onready var path_follow = get_parent()

func _physics_process(delta):
	MovementLoop(delta)

#Causes ghost to follow the path
func MovementLoop(delta):
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()
	move_direction = (pos.angle_to_point(prepos) / 3.14) * 180

func _process(delta):
	AnimationLoop()
	
	#Checks if ghost is in flashlight beam
	if harm:
		hp -= 1
	if hp <=0:
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

func _on_WhiteGhost_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		harm = true
