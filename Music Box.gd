extends Area2D

var playing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()

func interact_action(_area):
	if playing == false:
		$AnimatedSprite.animation = "opening"
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.animation = "playing"
		$AudioStreamPlayer2D.play()
		playing = true
	else:
		$AudioStreamPlayer2D.stop()
		$AnimatedSprite.animation = "closing"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
