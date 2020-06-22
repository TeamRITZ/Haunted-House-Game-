extends Area2D

var readable = true

func interact_action(area):
	area.get_parent().hasAnatomyBook = true
	$pickupSound.play()
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	var text = ["I wonder why this anatomy book looks so worn.. it must get frequent use. Maybe if i put it back where it belongs something will happen..."]
	if readable:
		DialogBox.load_dialog(text)
		#The following is an over-complicated way to make sure
		#the player doesn't automatically read the note again
		readable = false #mark unreadable
		yield(DialogBox, "finished") #wait for the player to finish reading
		yield(get_tree().create_timer(.5), "timeout") #wait half a second so pressing E doesn't trigger the read again
		readable = true
