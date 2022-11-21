extends VSlider

func _ready():
	self.min_value = Constants.NODES_CONTAINER_SCALE_Z_MIN
	self.max_value = Constants.NODES_CONTAINER_SCALE_Z_MAX
	self.step = 0.1
	connect("value_changed", get_node("/root/App"), "_on_slider_nodes_container_z_scale_value_changed")
