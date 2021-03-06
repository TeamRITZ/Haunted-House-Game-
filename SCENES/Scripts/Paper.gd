extends Area2D

var readable = true
var text = ["The [color=red]candles[/color] in this room are [wave]strange.[/wave]\n Those that are lit refuse to be extinguished. \n The others refuse to stay lit.","Meanwhile, the [color=red]candles in the kitchen[/color] are behaving normally. This house is [shake level=6]driving me insane[/shake]"]
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
