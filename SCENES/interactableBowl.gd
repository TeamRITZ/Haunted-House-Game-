extends Area2D

var secretFound = false
var readable = true
var text = ["There doesn't seem to be anything left to do here."]
func _ready():
	get_parent().get_node("brassKey/CollisionShape2D").disabled = true
	get_parent().get_node("brassKey/Sprite").visible = false
	pass
func interact_action(area):
	if area.get_parent().hasBone == true:
		if secretFound == false:
			$secretSound.play()
			secretFound = true
			$boneSprite.visible= true
			get_parent().get_node("brassKey/CollisionShape2D").disabled = false
			get_parent().get_node("brassKey/Sprite").visible = true
	
		elif readable:
			DialogBox.load_dialog(text)
			#The following is an over-complicated way to make sure
			#the player doesn't automatically read the note again
			readable = false #mark unreadable
			yield(DialogBox, "finished") #wait for the player to finish reading
			yield(get_tree().create_timer(.5), "timeout") #wait half a second so pressing E doesn't trigger the read again
			readable = true
		else:
			return
