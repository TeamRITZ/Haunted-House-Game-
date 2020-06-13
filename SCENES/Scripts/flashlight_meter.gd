extends CanvasLayer

var animated_health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HealthBar.value = animated_health




func update_health(new_value):
		$HealthBarAnimation.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not $HealthBarAnimation.is_active():
			$HealthBarAnimation.start()


func _on_Player_health_changed(health):
	update_health(health)
