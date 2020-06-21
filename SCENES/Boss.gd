extends Area2D

var invulnerable = true
var harm = false
var dead = false
var player_in_range = false

export var hp = 500

var boss_ghost_scene = preload("res://SCENES/BossGhost.tscn")
var rng = RandomNumberGenerator.new()

func ready():
	$HealthBar._on_max_health_updated(hp)
	$HealthBar._on_health_updated(hp)
	$AnimatedSprite.play()
	#$SpawnTimer.set_wait_time(2)
	

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
		$AnimatedSprite.animation = "front"
		$SpawnTimer.start()
		#Spawn a single ghost immediately 
		var key = boss_ghost_scene.instance()
		key.start_position = get_global_position()
		key.position = get_global_position()
		key.player = get_parent().get_node("Player")
		get_tree().get_root().add_child(key)

func _on_Sight_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		$AnimatedSprite.animation = "back"
		$SpawnTimer.stop()

#Timer will time out every 2 seconds that player spends in boss's sight.
#For each timout the boss has a 50% chance to spawn a ghost
func _on_SpawnTimer_timeout():
	rng.randomize()
	var random = rng.randf()
	if random <= 0.5: #50% cahnce to spawn BossGhost
		var key = boss_ghost_scene.instance()
		key.start_position = get_global_position()
		key.position = get_global_position()
		key.player = get_parent().get_node("Player")
		get_tree().get_root().add_child(key)
	
	
