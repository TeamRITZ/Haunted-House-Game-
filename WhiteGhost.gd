extends KinematicBody2D

export var speed = 150
var move_direction = 0
export var hp = 50
var harm = false

onready var path_follow = get_parent()

func _ready():
	$AnimatedSprite.play()

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
#There is a bug with the lines that wer supposed to mkae it turn left, 
#but the first line of this function acts a s a workaround 
func AnimationLoop():
	$AnimatedSprite.animation = "left" #workaround for bug below
	if move_direction <= 15 and move_direction >= -15:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.play()
	elif move_direction <= 60 and move_direction >= 15:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.play()
	elif move_direction <= 120 and move_direction >= 60:
		$AnimatedSprite.animation = "down"
		$AnimatedSprite.play()
	elif move_direction <= 165 and move_direction >= 120:
		$AnimatedSprite.animation = "down"
		$AnimatedSprite.play()
	elif move_direction >= -60 and move_direction <= -15:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.play()
	elif move_direction >= -120 and move_direction <= -60:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.play()
	#$AnimatedSprite.play()
	#This is where the bug is:
	#elif move_direction >= -165 and move_direction <= -120:
	#	animation_direction = "left"
	#elif move_direction <= -165 and move_direction >= -165:
	#	animation_direction = "left"

func _on_Area2D_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		harm = true

func _on_Demo_enemy_area_exited(area):
	if area.get_name() == "FlashlightBeam":
		harm = false
	
	
	



