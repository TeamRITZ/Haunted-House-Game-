extends Area2D

func interact_action(area):
	if area.TYPE == "PLAYER":
		if area.get_parent().hasSilverKey == true:
			$CollisionShape2D.disabled = true
			get_parent().get_node("CollisionShape2D").disabled = true
			$DoorOpen.play()
			get_parent().get_node("Closed").visible = false #Should be replaced with door opening animation
		else:
			$DoorLocked.play()
