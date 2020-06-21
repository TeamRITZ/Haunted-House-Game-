extends Area2D

var invulnerable = true
var harm = false
var dead = false
var player_in_range = false

export var hp = 500

var red_ghost_scene = preload("res://SCENES/RedGhost.tscn")

func ready():
	$HealthBar._on_max_health_updated(hp)
	$HealthBar._on_health_updated(hp)



func _process(delta):
	if harm:
		hp -= 1
		$HealthBar._on_health_updated(hp)
	if hp <=0:
		queue_free()


func _on_Boss_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		$HealthBar.visible = true
		harm = true
		
func _on_Boss_area_exited(area):
	if area.get_name() == "FlashlightBeam":
		harm = false


func _on_Sight_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		print ("Player in range")
		$AnimatedSprite.animation = "front"
		var key = red_ghost_scene.instance()
		get_tree().get_root().add_child(key)
		key.start_position = get_global_position()
		key.position = get_global_position()
		

func _on_Sight_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print ("Player not in range")
		$AnimatedSprite.animation = "back"
