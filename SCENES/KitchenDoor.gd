extends Area2D

func interact_action(area):
	if area.TYPE == "PLAYER":
		$doorLocked.play()
