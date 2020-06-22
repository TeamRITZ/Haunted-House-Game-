extends Node2D

var can1
var can2
var can3
var can4
var can5
var can6
var solved = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	can1 = get_node("Candle")
	can2 = get_node("Candle2")
	can3 = get_node("Candle3")
	can4 = get_node("Candle4")
	can5 = get_node("Candle5")
	can6 = get_node("Candle6")





func _on_Candle_candle_changed():
	if !solved:
		if !can1.lit:
			if can2.lit:
				if !can3.lit:
					if can4.lit:
						if can5.lit:
							if !can6.lit:
								$Door.queue_free()
								$AudioStreamPlayer2D.play()
								solved = true
