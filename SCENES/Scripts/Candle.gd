extends Area2D

export var lit = true
signal candle_changed()

func interact_action(_area):
	if lit:
		$Light2D.enabled = false
		$AnimatedSprite.animation = "unlit"
		lit = false
		emit_signal("candle_changed")
	else:
		$Light2D.enabled = true
		$AnimatedSprite.animation = "lit"
		lit = true
		
		emit_signal("candle_changed")
func _ready():
	$AnimatedSprite.play()
	if lit:
		$Light2D.enabled = true
		$AnimatedSprite.animation = "lit"
	else:
		$Light2D.enabled = false
		$AnimatedSprite.animation = "unlit"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
