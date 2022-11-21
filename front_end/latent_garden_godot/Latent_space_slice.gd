tool 
extends Spatial
var Latent_space_node = load("res://Latent_space_node.tscn")

var id : int 
signal update_latent_node_scale

func initiate_latent_nodes(nodes_data: Array) -> void:
	for node_data in nodes_data:
		var pos: Vector3 = node_data.pos
		var id: int = node_data.id
		var latent_node : Spatial = Latent_space_node.instance()
		latent_node.translation = pos
		latent_node.id = id
		connect("update_latent_node_scale", latent_node, "_on_update_latent_node_scale")
		self.add_child(latent_node)
		
func handle_update_latent_nodes_scale() -> void:
	var new_scale = range_lerp(self.translation.z, -Constants.NODES_CONTAINER_SCALE_Z_MIN, -Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.LATENT_NODE_SCALE_MAX, Constants.LATENT_NODE_SCALE_MIN)
	emit_signal("update_latent_node_scale", Vector3(new_scale, new_scale, new_scale))

func _ready():
	#handle_slice_to_camera_distance_update()
	pass
	
func _process(delta):
	# WIP: trigger this on camera zoom event instead of running perpetually _process
	handle_update_latent_nodes_scale()
	#pass
