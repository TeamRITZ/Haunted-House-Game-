extends Control
#Health bar for ghosts

onready var health_bar = $HealthBar
export var Max = 100

func _ready():
	health_bar.max_value = Max
	health_bar.value = Max
	
func _on_health_updated(current_health):
	health_bar.value = current_health
	
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
