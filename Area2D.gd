extends Area2D
export var hp = 90
var harm = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if harm:
		hp -= 1
	if hp <=0:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		harm = true
		
#func _on_Timer_timeout():
	#queue_free()


func _on_Demo_enemy_area_exited(area):
	if area.get_name() == "FlashlightBeam":
		harm = false
