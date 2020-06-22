extends Area2D

var text = ["It's a textbook on anatomy.", "For some reason, you get the feeling you should take it."]
var readable = true
func interact_action(area):
	if readable: #Prevents dialogue loop bug
		$CollisionShape2D.disabled = true
		readable = false
		DialogBox.load_dialog(text)
		yield(DialogBox, "finished")
		area.get_parent().hasAnatomyBook = true
		$pickupSound.play()
		$Sprite.visible = false
