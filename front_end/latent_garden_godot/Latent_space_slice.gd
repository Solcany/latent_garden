tool 
extends Spatial
var Latent_space_node = load("res://Latent_space_node.tscn")

var id : int
var camera_ref
var current_dist_from_camera : float = 10000.0
signal update_latent_node_scale
var scan = true

func initiate_latent_nodes(nodes_data: Array) -> void:
	for node_data in nodes_data:
		var pos: Vector3 = node_data.pos
		var id: int = node_data.id
		var latent_node : Spatial = Latent_space_node.instance()
		latent_node.translation = pos
		latent_node.id = id
		connect("update_latent_node_scale", latent_node, "_on_update_latent_node_scale")
		self.add_child(latent_node)

func handle_slice_to_camera_distance_update() -> void:
	if(camera_ref):
		var camera_pos = camera_ref.global_transform.origin
		var slice_pos = self.global_transform.origin
		var dist = camera_pos.distance_to(slice_pos)
		if(dist != current_dist_from_camera):
			var new_scale = range_lerp(dist, 10.56, 3.53, 0.3, 0.1)
			emit_signal("update_latent_node_scale", Vector3(new_scale, new_scale,new_scale))
			current_dist_from_camera = dist

func _ready():
	pass

func _process(delta):
	# WIP: trigger this on camera zoom event instead of running perpetually _process
	handle_slice_to_camera_distance_update()
