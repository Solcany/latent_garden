tool 
extends Spatial
var Latent_space_node = load("res://Latent_space_node.tscn")

var id : int 
var all_slices_amount : int
signal z_scale_changed
signal slice_visibility_changed
var rng = RandomNumberGenerator.new()
	
func add_latent_node(id: int, pos: Vector3, color : Color = Color(0.0, 1.0, 0.0), texture : Texture = null) -> void:
	var latent_node : Spatial = Latent_space_node.instance()
	latent_node.add_to_group(Constants.LATENT_NODES_GROUP_NAME)	
	latent_node.translation = pos
	latent_node.id = id
	latent_node.color = color
	if(texture):
		latent_node.set_image_texture(texture)
	connect("slice_visibility_changed", latent_node, "_on_slice_visibility_changed")		
	connect("z_scale_changed", latent_node, "_on_z_scale_changed")
	self.add_child(latent_node)
	
	# WIP: should z_scale_changed be emitted when individual node is added?
	# check last lines of initiate_latent_nodes func

func initiate_latent_nodes(nodes_data: Array) -> void:
	rng.randomize()
	var color: Color = Color(rng.randf_range(0.5, 1.0), rng.randf_range(0.5, 1.0), rng.randf_range(0.5, 1.0))

	for node_data in nodes_data:
		var pos: Vector3 = node_data.pos
		var id: int = node_data.id
		add_latent_node(id, pos, color)
		
	var node_mesh_scalar : float = range_lerp(self.translation.z, -Constants.NODES_CONTAINER_SCALE_Z_MIN, -Constants.NODES_CONTAINER_SCALE_Z_MAX, 1.0, 0.0)		
	emit_signal("z_scale_changed", node_mesh_scalar)
	
func signal_own_visibility() -> void:
	if(abs(self.translation.z) < Constants.CAMERA_FAR):
		emit_signal("slice_visibility_changed", true)
	else:
		emit_signal("slice_visibility_changed", false)	
			
func update_own_z_position(z_scalar: float) -> void:
	var z_max = range_lerp(z_scalar, 0.0, 1.0, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX)
	var slice_z_pos = range_lerp(self.id, 0, all_slices_amount-1, Constants.NODES_CONTAINER_SCALE_Z_MIN, z_max)
	self.translation.z = -slice_z_pos
	
func _on_z_scale_changed(z_scalar : float) -> void:
	update_own_z_position(z_scalar)
	signal_own_visibility()
	var node_mesh_scalar : float = range_lerp(self.translation.z, -Constants.NODES_CONTAINER_SCALE_Z_MIN, -Constants.NODES_CONTAINER_SCALE_Z_MAX, 1.0, 0.0)			
	emit_signal("z_scale_changed", node_mesh_scalar)	
	
func _ready():
	signal_own_visibility()
	
#func _process(delta):
#	pass
