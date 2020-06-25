extends Area2D

var readable = true
var hint = ["It won't open.\nIt's sealed with a decorative lock."]

func interact_action(area):
	if area.TYPE == "PLAYER":
		if area.get_parent().hasElaborateKey == true:
			$CollisionShape2D.disabled = true
			$openSound.play()
			$collision/CollisionShape2D.disabled =true
			$Closed.visible = false
		else:
			if readable:
				$lockedSound.play()
				DialogBox.load_dialog(hint)
				#The following is an over-complicated way to make sure
				#the player doesn't automatically read the note again
				readable = false #mark unreadable
				yield(DialogBox, "finished") #wait for the player to finish reading
				yield(get_tree().create_timer(.5), "timeout") #wait half a second so pressing E doesn't trigger the read again
				readable = true
			else:
				return
