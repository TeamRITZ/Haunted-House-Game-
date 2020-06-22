extends Button


export(String) var scene_to_load


func _on_NewGameButton_pressed():
	SceneChanger.change_scene("res://test.tscn")
