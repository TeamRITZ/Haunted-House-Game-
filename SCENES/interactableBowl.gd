extends Area2D

var secretFound = false
var readable = true
var text = ["There doesn't seem to be anything left to do here."]
func _ready():
	pass
	
func interact_action(area):
	if area.get_parent().hasBone == true:
		if secretFound == false:
			$secretSound.play()
			secretFound = true
			$boneSprite.visible= true
			get_parent().takeBone()
			area.get_parent().killedDog = false
