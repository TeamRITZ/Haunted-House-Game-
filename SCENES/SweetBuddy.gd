extends Area2D

var readable = true
var text = ["Our dear sweet [color=red]Buddy[/color], as loyal as can be,\nOnce got aggressive and bit poor Timmy.",
"[color=red]William[/color] got mad and took it too far\nThen locked Buddy in the [color=red]basement[/color] to hide his scars.",
"Now his spirit remains whimpering and alone,\nMaybe give him some company or bring him a [color=red]bone[/color]."]
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
