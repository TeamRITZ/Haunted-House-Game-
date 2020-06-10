extends Area2D

#signal healPlayer

func _on_HealthPotion_area_entered(area):
#	emit_signal("healPlayer")
	if area.get_name() == "Player":
		queue_free()
		
	
