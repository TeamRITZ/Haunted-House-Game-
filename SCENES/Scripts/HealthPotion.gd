extends Area2D

const TYPE = "HPOTION"
#signal healPlayer

func _on_HealthPotion_area_entered(area):
#	emit_signal("healPlayer")
	if area.get_name() == "Player":
		queue_free()

func _on_HealthPotion_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "Player":
		queue_free()
