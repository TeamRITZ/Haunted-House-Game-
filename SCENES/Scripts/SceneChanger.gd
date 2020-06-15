extends CanvasLayer


onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func change_scene(path):
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	Global.goto_scene(path)
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
