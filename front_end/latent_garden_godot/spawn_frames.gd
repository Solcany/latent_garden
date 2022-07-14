extends Spatial
var frames_amt = 10
var Frame = load("res://Frame.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = Frame.instance()
	frame.name = "frame"
	frame.translation.y = global_variables.init_room_scale_y	
	frame.translation.x = -global_variables.init_room_scale_x
	self.add_child(frame)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var frame = get_node("frame")
	if frame != null: 	
		frame.translation.z = global_variables.room_scale_z
	
