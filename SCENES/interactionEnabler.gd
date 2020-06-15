extends Area2D

func interact_action():
	print("I am a brass door")
	$CollisionShape2D.disabled = true
	get_parent().get_node("CollisionShape2D").disabled = true
