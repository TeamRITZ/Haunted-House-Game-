extends Area2D

var readable = true
var text = ["It won't open.", "...\nThere doesn't appear to be a lock"]

func interact_action(area):
	if area.TYPE == "PLAYER":
		if readable:
			$doorLocked.play()
			DialogBox.load_dialog(text)
			#The following is an over-complicated way to make sure
			#the player doesn't automatically read the note again
			readable = false #mark unreadable
			yield(DialogBox, "finished") #wait for the player to finish reading
			yield(get_tree().create_timer(.5), "timeout") #wait half a second so pressing E doesn't trigger the read again
			readable = true
		else:
			return
