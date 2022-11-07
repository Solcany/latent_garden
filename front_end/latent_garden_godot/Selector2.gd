extends ReferenceRect

onready var view_width = get_viewport().size.x
onready var view_height = get_viewport().size.y
const selector_width : int = 100
const selector_height : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		var mouse_x : float = event.position.x
		var mouse_y : float = event.position.y		
		
		var margin_left : float = event.position.x - selector_width/2
		var margin_right : float = event.position.x + selector_width/2	
		var margin_top : float = event.position.y - selector_height/2
		var margin_bottom : float = event.position.y + selector_height/2
		
		self.margin_left	= margin_left
		self.margin_right = margin_right
		self.margin_top	= margin_top
		self.margin_bottom = margin_bottom
						
