extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/InventoryBackground.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HUD/FlashlightBar.value = $Player.battery
	$HUD/HealthBar.value = $Player.health
