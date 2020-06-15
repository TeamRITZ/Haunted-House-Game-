extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready():
	#$JournalPage.visible = false

func interact_action(_area):
	$JournalPage.visible = true
	$JournalPage/JournalPage.visible = true
	$JournalPage/JournalPage.load_dialog()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
