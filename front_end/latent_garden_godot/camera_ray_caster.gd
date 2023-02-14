extends Camera

var ray_origin : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	#if event is InputEventMouseMotion:
	#	handle_mouse_move(event)
	if event is InputEventMouseButton :
		var from = self.project_ray_origin(event.position)
		var to = from + self.project_ray_normal(event.position) * 100
		var direct_state = get_world().direct_space_state
		var collision = direct_state.intersect_ray(from, to)
		if collision:
			print("collision!")			
			print(collision)
		#var cursorPos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		#print(cursorPos)
