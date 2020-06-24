extends Area2D

var readable = true
var text = ["The damage from [color=red]Dad[/color] was almost irreparable,\nIt made Timmy and Billy completely inseparable.",
"Billy was neglected and bullied, only Timmy could relate.\nBut Timmy was young, stuck in a naive helpless state.",
"So Billy swore to protect him, he still does to this day.\nFind [color=red]where they once stood[/color] to make their past escapes. "]


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
