extends Spatial
var Frame = load("res://Frame.tscn")
var frames_parent_ref = null

func spawn_frames():
	var low_extent_z =  -global_variables.room_scale_z
	var high_extent_z = global_variables.room_scale_z
	var dist = abs(low_extent_z) + abs(high_extent_z)
	var frame_width = global_variables.frame_scale.z + global_variables.frame_padding_z
	var frames_amt = floor(dist / frame_width)
	var frames_parent = Spatial.new()
	frames_parent.name = "frames_parent"
		
	for i in range(frames_amt):
		var frame = Frame.instance()
		var frame_name = "frame_" + str(i)		
		frame.name = frame_name		
		var weight = (1 / frames_amt) * i
		var z = lerp(low_extent_z, high_extent_z, weight)	+ global_variables.frame_padding_z
		var pos = Vector3(-global_variables.init_room_scale_x, 0, z)	
		frame.translation = pos
		frames_parent.add_child(frame)
	frames_parent_ref = frames_parent	
	self.add_child(frames_parent)

func destroy_frames():
	if(is_instance_valid(frames_parent_ref)):
		frames_parent_ref.queue_free()
	
func _ready():
	spawn_frames()
	
func _process(delta):
	pass
	
func _on_room_scale_changed():
	destroy_frames()
	spawn_frames()	
