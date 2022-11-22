tool 
extends Spatial
var Latent_space_node = load("res://Latent_space_node.tscn")

var id : int 
signal update_latent_node_scale
signal update_latent_node_visibility

func initiate_latent_nodes(nodes_data: Array) -> void:
	var node_mesh_scale : float = range_lerp(self.translation.z, Constants.NODES_CONTAINER_SCALE_Z_MIN, -Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.LATENT_NODE_SCALE_MAX, Constants.LATENT_NODE_SCALE_MIN)
	for node_data in nodes_data:
		var pos: Vector3 = node_data.pos
		var id: int = node_data.id
		var latent_node : Spatial = Latent_space_node.instance()
		latent_node.add_to_group(Constants.LATENT_NODES_GROUP_NAME)
		latent_node.translation = pos
		latent_node.id = id
		connect("update_latent_node_scale", latent_node, "_on_update_latent_node_visibility")		
		connect("update_latent_node_scale", latent_node, "_on_update_latent_node_scale")
		self.add_child(latent_node)
	emit_signal("update_latent_node_scale", node_mesh_scale)

func is_slice_visible() -> bool:
	if(abs(self.translation.z) < Constants.CAMERA_FAR):
		return true
	else:
		return false

func handle_slice_visibility() -> void:
	if(is_slice_visible()):
		emit_signal("update_latent_node_visibility", true)
	else:
		print("not vis")
		emit_signal("update_latent_node_visibility", false)		
		
func handle_slice_nodes_mesh_scale(new_scale) -> void:
	var node_mesh_scale = range_lerp(self.translation.z, -Constants.NODES_CONTAINER_SCALE_Z_MIN, -Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.LATENT_NODE_SCALE_MAX, Constants.LATENT_NODE_SCALE_MIN)
	emit_signal("update_latent_node_scale", node_mesh_scale)

func _on_z_scale_changed(new_z_scale : float) -> void:
	handle_slice_nodes_mesh_scale(new_z_scale)
	handle_slice_visibility()
	
func _ready():
	handle_slice_visibility()
	
func _process(delta):
	pass
