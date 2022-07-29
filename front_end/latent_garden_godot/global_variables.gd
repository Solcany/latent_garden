extends Node

var rooms_amt = 9
var init_room_scale_x = 0.8
var init_room_scale_y = 0.8
var init_room_scale_z = 0.2
var room_scale_z = init_room_scale_z
var room_scaling_step_z = 0.1

var frame_scale = Vector3(0.01, 0.2, 0.2)
var frame_padding_z = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
