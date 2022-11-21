extends Camera


# WIP this handler func should be more meaningful, change in App
func _on_nodes_container_z_scale_changed(value) -> void:
	var projection_size = range_lerp(value, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.CAMERA_Z_MIN, Constants.CAMERA_Z_MAX)
	self.size = projection_size

func _ready():
	pass # Replace with function body.
