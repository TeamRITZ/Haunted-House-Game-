extends Control

var text = "The candles in this room are strange.\n Those that are lit refuse to be extinguished. \n The others refuse to stay lit."

var finished = false
var line = 1
func _ready():
	$AnimatedSprite.visible = false
	$RichTextLabel.bbcode_text = text
	$RichTextLabel.percent_visible = 0
	#load_dialog()
func _process(_delta):
	if finished and Input.is_action_just_pressed("interact"):
		get_tree().paused = false
		visible = false
		finished = false
func load_dialog():
	get_tree().paused = true
	$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$AnimatedSprite.visible = true
	$AnimatedSprite.play()
	finished = true
	$AnimatedSprite.visible = true
