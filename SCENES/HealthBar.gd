extends Control
#Health bar for ghosts

onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween

func _on_health_updated(health, ammount):
	health_bar.value = health
	#update_tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.4, Tween.TRANS_)
	#update_tween.start()
	
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
