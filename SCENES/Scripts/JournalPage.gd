extends CanvasLayer

signal next()
signal finished()
#var text = "The candles in this room are strange.\n Those that are lit refuse to be extinguished. \n The others refuse to stay lit."

var finished = false
var index = 0
func _ready():
	$JournalPage.visible = false
	$JournalPage/AnimatedSprite.visible = false
	$JournalPage/RichTextLabel.percent_visible = 0
	#load_dialog()
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		emit_signal("next")
		
func load_dialog(text):
	get_tree().paused = true
	$JournalPage.visible = true
	for page in text:
		$JournalPage/RichTextLabel.bbcode_text = page
		$JournalPage/Tween.interpolate_property($JournalPage/RichTextLabel, "percent_visible", 0, 1, 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$JournalPage/Tween.start()
		yield($JournalPage/Tween,"tween_completed")
		$JournalPage/AnimatedSprite.visible = true
		$JournalPage/AnimatedSprite.play()
		$JournalPage/AnimatedSprite.visible = true
		yield(self,"next")
	emit_signal("finished")
	get_tree().paused = false
	$JournalPage.visible = false
