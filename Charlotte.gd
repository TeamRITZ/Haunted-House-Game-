extends Area2D

var readable = true
var text = ["Charlotte was the sweetest little girl\nAlways off in her own little world.\nThe family’s glaring looks made her outcasted\nBut [color=red]escaping through books[/color] is how she lasted.",
"At the [color=red]library desk[/color], she would sit for hours.\nLost in her head, as the princess in the tower."]
# Called when the node enters the scene tree for the first time.
#func _ready():

func interact_action(_area):
	if readable:
		JournalPage.load_dialog(text)
		#The following is an over-complicated way to make sure
		#the player doesn't automatically read the note again
		readable = false #mark unreadable
		yield(JournalPage, "finished") #wait for the player to finish reading
		yield(get_tree().create_timer(.5), "timeout") #wait half a second so pressing E doesn't trigger the read again
		readable = true
	else:
		return
