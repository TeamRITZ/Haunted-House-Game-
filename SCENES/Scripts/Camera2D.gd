extends Camera2D

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size



func _process(_delta):
	var pos = get_node("../Player").global_position
	var x = floor(pos.x / screen_size.x) * screen_size.x
	var y = floor(pos.y / screen_size.y) * screen_size.y
	global_position = lerp(global_position, Vector2(x,y), 0.1)
