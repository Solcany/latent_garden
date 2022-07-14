extends Area

func handle_body_entered():
	connect("body_entered", get_parent(), "_on_body_entered_room")
	
func handle_body_exited():
	connect("body_exited", get_parent(), "_on_body_exited_room")

func _ready():
	handle_body_entered()
	handle_body_exited()
	##pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		#cube.translation.z = (-global_variables.room_scale_z)
		self.scale = Vector3(global_variables.init_room_scale_x,
							global_variables.init_room_scale_y,
							global_variables.room_scale_z)
