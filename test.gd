extends Node2D


func _ready():
	$HUD/InventoryBackground.visible = false
	#JournalPage.load_dialog(text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HUD/FlashlightBar.value = $Player.battery
	$HUD/HealthBar.value = $Player.health
