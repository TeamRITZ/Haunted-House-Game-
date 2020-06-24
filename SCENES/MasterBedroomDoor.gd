extends Area2D

func interact_action(area):
	if area.TYPE == "PLAYER":
		if area.get_parent().hasElaborateKey == true:
			$CollisionShape2D.disabled = true
			$openSound.play()
			$collision/CollisionShape2D.disabled =true
			$Closed.visible = false
		else:
			$lockedSound.play()
