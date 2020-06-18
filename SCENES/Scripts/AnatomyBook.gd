extends Area2D

func interact_action(area):
	area.get_parent().hasAnatomyBook = true
	$pickupSound.play()
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
