extends Control


var scene_path_to_load

func _ready():
	pass#$Menu/Buttons/NewGameButton.grab_focus()



func _on_NewGameButton_pressed():
	SceneChanger.change_scene("res://test.tscn")


func _on_InstructionsButton_pressed():
	pass
	#SceneChanger.change_scene("res://SCENES/")
