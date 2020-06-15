extends Control

var text = "The candles in this room are strange.\n Those that are lit refuse to be extinguished. \n The others refuse to stay lit."

var finished = false
var line = 1
func _ready():
	$AnimatedSprite.visible = false
	$RichTextLabel.bbcode_text = text
	$RichTextLabel.percent_visible = 0
	load_dialog()
func _process(delta):
	if finished and Input.is_action_just_pressed("interact"):
		load_dialog()
func load_dialog():
	if line == 1:
		$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, .327, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		$AnimatedSprite.visible = true
		$AnimatedSprite.play()
		finished = true
		$AnimatedSprite.visible = true
		line += 1
		return
	if line == 2:
		finished = false
		$AnimatedSprite.visible = false
		$Tween.interpolate_property($RichTextLabel, "percent_visible", .327, .739, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		finished = true
		$AnimatedSprite.visible = true
		line += 1
		return
	if line == 3:
		finished = false
		$AnimatedSprite.visible = false
		$Tween.interpolate_property($RichTextLabel, "percent_visible", .739, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		finished = true
		$AnimatedSprite.visible = true
		line += 1
		return
	if line == 4:
		queue_free()
