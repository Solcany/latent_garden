extends Spatial
export var detector_scalar_z = 0.1
var step_z = 0.11
var Room = load("res://Room.tscn")
signal room_scale_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(global_variables.rooms_amt):
		var room = Room.instance()
		#room.scale.z = detector_scalar_z
		
		room.translation.x = -global_variables.init_room_scale_x*2 * i
		var room_name  = "room_" + str(i)
		room.name = room_name
		self.add_child(room)
		
		# GameController controls the room_scale variable
		# GameController sends signal to this object when room scale changes		
		# this object relays the signal to individual Room instances		
		var room_ref = get_node(room_name + "/frames")
		connect("room_scale_changed", room_ref, "_on_room_scale_changed")
	
func _on_room_scale_changed():
	# relay the signal to the individual rooms
	emit_signal("room_scale_changed")
