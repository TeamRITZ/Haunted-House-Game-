extends Area2D

var lit = true

func interact_action(_area):
	if lit:
		$Light2D.enabled = false
		$AnimatedSprite.animation = "unlit"
		lit = false
		$LightTimer.start()
	else:
		$Light2D.enabled = true
		$AnimatedSprite.animation = "lit"
		lit = true
func _ready():
	$AnimatedSprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_LightTimer_timeout():
	$Light2D.enabled = true
	$AnimatedSprite.animation = "lit"
	lit = true
