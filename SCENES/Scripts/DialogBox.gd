extends CanvasLayer

signal next()
signal finished()

var charCount
var time
func _ready():
	$DialogBox.visible = false
	$DialogBox/AnimatedSprite.visible = false
	$DialogBox/RichTextLabel.percent_visible = 0
	#load_dialog()
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		emit_signal("next")
		
func load_dialog(text):
	get_tree().paused = true
	$DialogBox.visible = true
	for page in text:
		$DialogBox/AnimatedSprite.visible = false
		$DialogBox/RichTextLabel.percent_visible = 0 # reset percent visible before loading next page
		$DialogBox/RichTextLabel.bbcode_text = page
		charCount = page.length()
		time = charCount * 0.03
		$DialogBox/Tween.interpolate_property($DialogBox/RichTextLabel, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$DialogBox/Tween.start()
		yield($DialogBox/Tween,"tween_completed")
		$DialogBox/AnimatedSprite.visible = true
		$DialogBox/AnimatedSprite.play()
		$DialogBox/AnimatedSprite.visible = true
		yield(self,"next")
	emit_signal("finished")
	get_tree().paused = false
	$DialogBox.visible = false
