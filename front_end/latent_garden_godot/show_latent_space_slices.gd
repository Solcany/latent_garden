tool
extends Spatial

const CSV_DATA_PATH = "data/latent_space_slices/frontend_2d_embeddings_slices.txt"
const CSV_DATA_ROW_SIZE = 5
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 5
const EMBEDDINGS_CSV_SKIP_HEADER = true
const LATENT_NODES_GROUP_NAME = "latent_nodes"
const DEBUG = true
var Latent_space_slice = load("res://Latent_space_slice.tscn")

func center_self(bounding_vec_min: Vector3, bounding_vec_max: Vector3) -> void: 
	self.translation.x = -bounding_vec_max.x/2
	self.translation.y = -bounding_vec_max.y/2
	self.translation.z = -bounding_vec_max.z/2
	
func add_points_mesh_to_scene(points: Array) -> void:
	var points_mesh = Geom.get_points_mesh_from_vectors_arr(points, Color(1,1,1))
	var mesh_instance = MeshInstance.new()
	mesh_instance.set_mesh(points_mesh)
	Mat.assign_vertex_albedo_color_material(mesh_instance)
	self.add_child(mesh_instance)		
#
#func add_latent_space_nodes_to_scene(points: Array) -> void:
#	for i in points.size():
#		var node : Spatial = Latent_space_node.instance()
#		node.translation = points[i]
#		node.id = i
#		node.add_to_group(LATENT_NODES_GROUP_NAME)
#		self.add_child(node)

func add_latent_space_slices_to_scene(embeddings : Array, slice_ids: Array, ids: Array) -> void:
	var slices_ids = Utils.get_unique_numbers_of_array(slice_ids)
	var z = -1.0
	for slice_id in slices_ids:
		var slice : Spatial = Latent_space_slice.instance()
		slice.id = slice_id
		slice.translation = Vector3(0,0,z)
		slice.camera_ref = get_node("/root/App/Camera")
		#slice.add_to_group("latent_space_slices")
		
		# filter relevant latent nodes data
		var points_data : Array = []
		for point_index in range(embeddings.size()):
			var point_slice_id =  slice_ids[point_index]
			if(point_slice_id == slice_id):
				var point_embeddings =  embeddings[point_index]
				var point_id = ids[point_index]
				points_data.append({"pos": point_embeddings, "id": point_id})

				#var latent_node : Spatial = Latent_space_node.instance()
				#latent_node.translation = point_embeddings
				#latent_node.id = point_id
		slice.initiate_latent_nodes(points_data)
				#slice.add_child(latent_node)
				
		z -= 1
		self.add_child(slice)

func handle_slice_camera_distance_update(slice_ref) -> void:
	var cam_pos = get_node("/root/App/Camera").global_transform.origin
	var slice_pos = slice_ref.global_transform.origin
	var dist = cam_pos.distance_to(slice_pos)
	emit_signal("update_slice_camera_distance", dist)

			
func _on_latent_node_selected(body) -> void: 
	var latent_node_ref = body.get_parent()
	latent_node_ref.is_selected = !latent_node_ref.is_selected
	
func _on_get_selected_latent_nodes() -> void:
	var selected : Array = []
	var nodes = get_tree().get_nodes_in_group(LATENT_NODES_GROUP_NAME)
	for node in nodes:
		if(node.is_selected):
			selected.append(node.id)
	emit_signal("return_selected_latent_nodes_ids", selected)
	
func _on_return_images(data) -> void:
	print("ims received in container")
	var metadata: Dictionary = data[0]
	var images_data: PoolStringArray = data[1] 
	var latent_nodes : Array = get_tree().get_nodes_in_group(LATENT_NODES_GROUP_NAME)
	# pass decoded images to the relevant instances of Latent_space_node node
	for index in range(images_data.size()):
		# decode image data to texture
		var image : Image = Encode_utils.decode_b64_image_string(images_data[index])
		var texture : ImageTexture = ImageTexture.new()
		texture.create_from_image(image, 0)
		# find where does the image belong to in the latent space
		var latent_space_index : int = metadata.indices[index]
		# find the relevant latent node 
		for node in latent_nodes:
			if(node.id == latent_space_index):
				node.set_image_texture(texture)
				break
		

func _ready():
	# connect signals
	connect("return_selected_latent_nodes_ids", get_node("/root/App"), "_on_return_selected_latent_nodes_ids")
	
	# process the csv data
	var data = Utils.load_csv_to_dicts(CSV_DATA_PATH, CSV_DATA_ROW_SIZE)
	var embeddings_raw : Array = Utils.filter_dicts_array_to_array(data, ["x", "y", "z"])
	var embeddings_numbers : Array = Utils.string_array_to_num_array(embeddings_raw, "float")
	var embeddings_vectors : Array = Utils.numbers_array_to_Vector3_array(embeddings_numbers)
	var embeddings_normalised : Array = Geom.normalise_3d_embeddings(embeddings_vectors)
	var embeddings_bounding_box_proportions : Vector3 = Geom.get_3d_embeddings_bounding_box_proportions(embeddings_vectors)
	var embeddings_scaled : Array = Geom.scale_normalised_3d_embeddings(embeddings_normalised, 
																		embeddings_bounding_box_proportions, 
																		EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)	
	#add_points_mesh_to_scene(embeddings_scaled)
	#add_latent_space_nodes_to_scene(embeddings_scaled)
	
	var slice_ids : Array = Utils.filter_dicts_array_to_array(data, ["slice_id"])
	slice_ids = Utils.string_array_to_num_array(slice_ids, "int")
	var ids : Array = Utils.filter_dicts_array_to_array(data, ["id"])
	ids = Utils.string_array_to_num_array(ids, "int")
	add_latent_space_slices_to_scene(embeddings_scaled, slice_ids, ids)
	
	var bounding_box_coords : Array = Geom.get_3d_bounding_box_from_vertices(embeddings_scaled)
	center_self(bounding_box_coords[0], bounding_box_coords[1])
#	if(DEBUG):
#		Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
#
#func _process(delta):
#	pass
	#for slice in get_tree().get_nodes_in_group("latent_space_slices"):
		#handle_slice_camera_distance_update(slice)
