extends CanvasLayer



func _on_NewGameButton_pressed():
	SceneChanger.change_scene("res://test.tscn")


func _on_InstructionsButton_pressed():
	SceneChanger.change_scene("res://Game/InstructionScreen.tscn")
