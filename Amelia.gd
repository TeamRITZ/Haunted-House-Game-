extends Area2D

var readable = true
var text = ["Amelia, the maid, and the hopeless romantic\nUnder William’s employ, was often left frantic.",
"Sometimes he was hot and sometimes he was cold,\nBut she just wanted love before she grew old.",
"So she accepted his advances despite the red flags.\nAnd their daughter Charlotte is who they soon had.",
"On her third birthday, they took her away.\nGrimwood Chateau is where she would now stay.",
"So Amelia keeps [color=red]three candles lit[/color] to signal her love,\n For her poor estranged daughter she’s always thinking of."]


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
