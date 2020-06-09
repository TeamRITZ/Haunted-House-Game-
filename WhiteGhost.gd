extends RigidBody2D

var currentPos = position
var prevPos = position

func _ready():
	$AnimatedSprite.play()
	

func _process(delta):
	get_parent().set_offset(get_parent().get_offset() + (100*delta))
	currentPos = position
	if (currentPos.x >= prevPos.x):
		$AnimatedSprite.animation = "right"
	else:
		$AnimatedSprite.animation = "left"
	prevPos = position

	
	
	
	

