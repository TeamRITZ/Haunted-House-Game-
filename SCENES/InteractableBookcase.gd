extends Area2D

var secretFound = false

func interact_action(area):
	if area.get_parent().hasAnatomyBook == true:
		if secretFound == false:
			$secretSound.play()
			secretFound = true
