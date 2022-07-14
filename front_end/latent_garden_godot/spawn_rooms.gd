extends Spatial
export var rooms_num = 3
export var detector_scalar_z = 0.1
var step_z = 0.11 #detector_scalar_z/2;
#var PLAYER_DETECTOR_SCENE = load("res://PlayerDetector.tscn")
var Room = load("res://Room.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(rooms_num):
		var room = Room.instance()
		#room.scale.z = detector_scalar_z
		#room.translation.z = step_z * i
		room.name = "room_" + str(i)

		#image_canvas.set_name(c_name)
		#image_canvas.visible = true
	#player_detector.translate(Vector3(0,0,10))
		self.add_child(room)
	
func _on_room_scale_changed():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
