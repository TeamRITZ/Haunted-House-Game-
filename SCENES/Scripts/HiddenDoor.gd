extends StaticBody2D

var text = ["You hear a mechanism shifting behind the walls, and a door appears in the southern wall."]
var closed = true

func _on_Switch_pressed():
	$Timer.start()
	
func _on_Switch_unpressed():
	$Timer.stop()

func _on_Timer_timeout():
	if closed:
		$DoorOpen2.play()
		DialogBox.load_dialog(text)
		yield($DoorOpen2, "finished")
		$SecretSound.play()
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
		closed = false
	else:
		return
