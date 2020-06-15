extends Area2D
var page
func interact_action(_area):
	add_child(page)
	yield()
# Called when the node enters the scene tree for the first time.
func _ready():
	var page = preload("res://SCENES/JournalPage.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
