extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func interact_action():
	SceneChanger.change_scene("res://interaction_test.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass