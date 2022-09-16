extends Position2D

export var idx = 0

func _ready():
	pass # Replace with function body.

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Vector2(75,75)), Color.blanchedalmond)
	
func select():
	#for child in get_tree().get_nodes_in_group("zone"):
	#	child.deselect()
	modulate = Color.webmaroon
#
func deselect():
	modulate = Color.white 
