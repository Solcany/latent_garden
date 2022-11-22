extends Camera


# WIP this handler funcand the event should be renamed to more generic name, 
# change in App and the slider
func _on_nodes_container_z_scale_changed(value : float) -> void:
	var projection_size = range_lerp(value, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.CAMERA_PROJECTION_SIZE_MIN, Constants.CAMERA_PROJECTION_SIZE_MAX)
	self.size = projection_size

func _ready():
	self.far = Constants.CAMERA_FAR
