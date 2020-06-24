extends Area2D

export var speed = 150
var move_direction = 0
export var hp = 100
var harm = false
var prevAnimation
const TYPE = "GHOST"
var dead = false
var offset = Vector2(40,-40)

var brass_key_scene = preload("res://SCENES/brassKey.tscn")
var player
export var dropBrassKey = false

func dropKey():
	var key = brass_key_scene.instance()
	get_tree().get_root().add_child(key)
	key.position = get_global_position() + offset
	
func takeBone():
	if dead == false:
		dropKey()
		$whimper.play()
		dead = true
		$CollisionShape2D.disabled = true
		get_node("../Player").hasBone = false
		get_node("../HUD/InventoryBackground/Bone").visible = false
	if $whimper.playing == false:
		queue_free()
	
func die():
	if dead == false:
		if dropBrassKey == true:
			dropKey()
		$deathSound.play()
		dead = true
		visible = false
		$CollisionShape2D.disabled = true
	if $deathSound.playing == false:
		queue_free()
	
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
		player.killedDog = true
		die()
		
		

func _on_DogGhost_area_entered(area):
	if area.get_name() == "FlashlightBeam":
		$HealthBar.visible = true
		harm = true
		speed = speed / 3
		$whine.play()
		player = area.get_parent()

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
