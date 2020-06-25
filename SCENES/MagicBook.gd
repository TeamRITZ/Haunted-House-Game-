extends Area2D

var readable = true

func interact_action(area):
	area.get_parent().hasAnatomyBook = true
	$pickupSound.play()
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	if readable and area.get_parent().killedBoss == true:
		if area.get_parent().killedWhiteGhost or area.get_parent().killedDog:
			var text = ["""When you remove the book from its pedastle you feel a sense of dark magic leaving GrimWood Chateau.
With that dark magic gone you can more easily tell the difference between the aggressive nature of the red and black spirts and 
the passive nature of the white spirits. Maybe it would have been possible to clear the mansion of only the red and black spirits"""]
			DialogBox.load_dialog(text)
		elif area.get_parent().tookDamage == false:
			var text = ["""When you remove the book from its pedastle you feel a sense of dark magic leaving the GrimWood Chateau.
Congratulations! You have beaten the game with optimal results! You didn't kill any passive spirits, and you didn't take any damage!"""]
			DialogBox.load_dialog(text)
		else:
			var text = ["""When you remove the book from its pedastle you feel a sense of dark magic leaving the GrimWood Chateau.
Congratulations! You have beaten the game without killing any passive spirits! Now try to do it without taking any damage!"""]
			DialogBox.load_dialog(text)
		#The following is an over-complicated way to make sure
		#the player doesn't automatically read the note again
		readable = false #mark unreadable
		yield(DialogBox, "finished") #wait for the player to finish reading
		yield(get_tree().create_timer(.5), "timeout") #wait half a second so pressing E doesn't trigger the read again
		readable = true
		SceneChanger.change_scene("res://SCENES/WinScene.tscn")
		#Go to game ending screen here?
