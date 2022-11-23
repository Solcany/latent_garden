extends Node
signal z_scale_changed

func _on_nodes_container_z_scale_changed(scale : float):
	var scalar = range_lerp(scale, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX, 0.0, 1.0)
	emit_signal("z_scale_changed", scalar)

func _ready():
	connect("z_scale_changed", get_node("Nodes_Selector"), "_on_z_scale_changed")
	connect("z_scale_changed", get_node("Nodes_container"), "_on_z_scale_changed")
