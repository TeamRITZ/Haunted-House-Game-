extends Area2D

var secretFound = false

func _ready():
	$silverKey/CollisionShape2D.disabled = true
	$silverKey/Sprite.visible = false

func interact_action(area):
	if area.get_parent().hasAnatomyBook == true:
		if secretFound == false:
			$secretSound.play()
			secretFound = true
			$silverKey/CollisionShape2D.disabled = false
			$silverKey/Sprite.visible = true
