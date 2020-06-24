extends Area2D

var readable = true
var text = ["The lady of the house and mother of the boys,\nEventually felt she could not find joy.\nShe confronted [color=red]William[/color] about Amelia and all\nHe was violent, angry, and reeked of alcohol.",
"The head of the house and the family’s dread\n[color=red]William is the reason they are all now dead."]


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
