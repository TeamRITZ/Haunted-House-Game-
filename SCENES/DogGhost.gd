extends Area2D

export var speed = 150
var move_direction = 0
export var hp = 100
var harm = false
var prevAnimation
const TYPE = "GHOST"
var dead = false

var brass_key_scene = preload("res://SCENES/brassKey.tscn")
export var dropBrassKey = false

func ready():
	$HealthBar.visible = false
	$HealthBar._on_max_health_updated(hp)
	$HealthBar._on_health_updated(hp)
	
func _process(_delta):
	#Checks if ghost is in flashlight beam
	if harm:
		hp -= 1
		$HealthBar._on_health_updated(hp)
	if hp <=0:
		if dead == false:
			if dropBrassKey == true:
				var key = brass_key_scene.instance()
				get_tree().get_root().add_child(key)
				key.position = get_global_position()
			$deathSound.play()
			dead = true
			visible = false
			$CollisionShape2D.disabled = true
		if $deathSound.playing == false:
			queue_free()

func _on_DogGhost_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		$HealthBar.visible = true
		harm = true
		speed = speed / 3
		$whine.play()

func _on_DogGhost_area_exited(area):
	if area.get_name() == "FlashlightBeam":
		harm = false
		speed = speed * 3

func _on_Sight_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite.animation = "stand"
		$AnimatedSprite.play()
		$bark.play()


func _on_Sight_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite.animation = "sit"
