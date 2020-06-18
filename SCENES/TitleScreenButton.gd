"""extends Control


func _ready():
	var scene = load("res://Player.tscn")
	var player = scene.instance()
	add_child(player)

func _on_InstructionsButton_pressed():
	get_tree().change_scene("res://Game/NewGame.tscn")


func _on_InstructionsButton_pressed():
	pass # Replace with function body.
	
	
	
	
	scene_path_to_load = scene_to_load
	 $FadeIn.fade_in() 


func _on_FadeIn_fade_finished():
	get_tree().change_scene_to(scene_path_to_load)
"""
