tool
extends Spatial

var Latent_space_slice = load("res://Latent_space_slice.tscn")
var selected_nodes_ids : Array = []
signal return_selected_latent_nodes_ids
signal z_scale_changed

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
	
func circle_pack_embeddings_slices(embeddings: Array, slice_ids: Array, ids : Array, circle_radius : float) -> Array:
	var slices_ids = Utils.get_unique_numbers_of_array(slice_ids)	
	slices_ids.sort()
	var lowest_id = slices_ids[0]
	var highest_id = slices_ids[-1]
	
	var packed_embeddings : Array = range(embeddings.size())
	
	for slice_id in slices_ids:
		var slice_points : Array = []
		var slice_points_ids : Array = []
		# get points and their ids belonging to a slice
		for idx in range(embeddings.size()):
			var point = embeddings[idx]
			var point_slice_id =  slice_ids[idx]
			var point_id = ids[idx]
			if(slice_id == point_slice_id):
				slice_points.append(point)
				slice_points_ids.append(point_id)
		# circle pack the points of the slice
		var circles : Array = Packer.vec3s_to_circles(slice_points, circle_radius)
		circles = Packer.pack_circles(circles)
		# restore circles to points
		var packed_points : Array = Packer.circles_to_vec3s(circles)
		
		# add the newly packed points to array containing all points
		# while preserving the initial order of the points
		for idx in range(packed_points.size()):
			var point_id : int = slice_points_ids[idx]
			var point : Vector3 = packed_points[idx]
			packed_embeddings[point_id] = point
		
	return packed_embeddings
	
func initiate_latent_space_slices(embeddings : Array, slice_ids: Array, ids: Array) -> void:
	var slices_ids = Utils.get_unique_numbers_of_array(slice_ids)
	slices_ids.sort()
	var lowest_id = slices_ids[0]
	var highest_id = slices_ids[-1]
	for slice_id in range(1): #slices_ids:
		var slice : Spatial = Latent_space_slice.instance()
		slice.add_to_group(Constants.LATENT_SLICES_GROUP_NAME)		
		var slice_z_pos = range_lerp(slice_id, lowest_id, highest_id, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX)
		slice.id = slice_id
		slice.translation.z = -slice_z_pos
		slice.all_slices_amount = slices_ids.size()
		
		connect("z_scale_changed", slice, "_on_z_scale_changed")
		# filter relevant latent nodes data
		var points_data : Array = []
		for point_index in range(embeddings.size()):
			var point_slice_id =  slice_ids[point_index]
			if(point_slice_id == slice_id):
				var point_embeddings =  embeddings[point_index]
				var point_id = ids[point_index]
				points_data.append({"pos": point_embeddings, "id": point_id})
		slice.initiate_latent_nodes(points_data)
		self.add_child(slice)
		
func set_images_to_existing_nodes(images_data : Array, nodes_indices: Array):
	var all_existing_nodes : Array = get_tree().get_nodes_in_group(Constants.LATENT_NODES_GROUP_NAME)
	# pass decoded images to the relevant instances of Latent_space_node node
	for index in range(images_data.size()):
		# search through all existing nodes, find the relevant ones
		for node in all_existing_nodes:
			if(node.id == nodes_indices[index]):
				# unselect the nodes
				update_selected_nodes_list(node)
				# apply generated textures
				var texture : Texture = Utils.decode_b64_image_to_texture(images_data[index])
				node.set_image_texture(texture)
				break
				
func add_lerped_latent_nodes(images_data: Array, existing_nodes_ids : Array, lerped_nodes_ids : Array, slerp_steps : int) -> void:
	# WIP hack: add new slices to the top most slice for now
	var slices = get_tree().get_nodes_in_group(Constants.LATENT_SLICES_GROUP_NAME)
	var top_slice : Spatial 
	# find the top most slice
	for slice in slices:
		if(slice.id == 0):
			top_slice = slice
	# find the relevant nodes	 in the scene
	var all_latent_nodes : Array = get_tree().get_nodes_in_group(Constants.LATENT_NODES_GROUP_NAME)	
	var existing_latent_nodes : Array = []
	for id in existing_nodes_ids:	
		for node in all_latent_nodes:
			if (node.id == id):
				existing_latent_nodes.append(node)
				break
	# unselect the existing nodes
	for node in existing_latent_nodes:
		update_selected_nodes_list(node)

	# create new nodes lerped from the existing ones
	var lerp_weights : Array = Utils.get_linear_space(0.0, 1.0, slerp_steps)
	# remove the first weight = 0.0 to avoid duplicating existing node
	lerp_weights.pop_front()
	# remove the last weight = 1.0 to avoid duplicating existing node	
	lerp_weights.pop_back()
	# create new nodes by lerping positions of existing nodes
	for node_i in range(existing_nodes_ids.size()-1):
		# process existing nodes in pairs
		var first_pos : Vector3 = existing_latent_nodes[node_i].translation
		var second_pos : Vector3 = existing_latent_nodes[node_i+1].translation
		for lerp_i in range(lerp_weights.size()):
			# the ids of lerped nodes are generated on the backend and delivered with metadata of the generated images
			# they are separate from the ids of existing nodes to avoid duplicating existing nodes
			var id : int = lerped_nodes_ids[node_i + lerp_i]
			var weight : float = lerp_weights[lerp_i]
			var pos : Vector3 = Utils.lerp_vec3(first_pos, second_pos, weight)
			var texture : Texture = Utils.decode_b64_image_to_texture(images_data[node_i + lerp_i])
			top_slice.add_latent_node(id, pos, Color(0, 1, 0), texture)

func update_selected_nodes_list(node : Spatial) -> void:
	# if the node is being deselected remove it frorm the selected ids array	
	if(node.is_selected):
		var remove_index = selected_nodes_ids.find(node.id)
		if(remove_index >= 0):
			selected_nodes_ids.remove(remove_index)
	# otherwise add it to the ids array
	else: 
		selected_nodes_ids.append(node.id)
	# update the selected state of the node itself
	node.update_on_selected()	

func _on_latent_node_selected(body) -> void: 
	var node = body.get_parent()
	update_selected_nodes_list(node)



func _on_get_selected_latent_nodes(request_kind : String) -> void:
	# emit ids of the selected nodes
	emit_signal("return_selected_latent_nodes_ids", selected_nodes_ids, request_kind)
	
func _on_z_scale_changed(z_scalar: float) -> void:
	emit_signal("z_scale_changed", z_scalar)

func _on_return_images(data) -> void:
	var metadata: Dictionary = data[0]
	var images_data: PoolStringArray = data[1] 
	set_images_to_existing_nodes(images_data, metadata.indices)
 
func _on_return_slerped_images(data) -> void:
	var metadata: Dictionary = data[0]
	var images_data: PoolStringArray = data[1] 
	add_lerped_latent_nodes(images_data, metadata.indices, metadata.lerped_indices, Constants.LATENT_NODE_SLERP_STEPS)
	
func _ready():
	# connect signals
	connect("return_selected_latent_nodes_ids", get_node("/root/App"), "_on_return_selected_latent_nodes_ids")
	
	# process the csv data
	var data = Utils.load_csv_to_dicts(Constants.CSV_DATA_PATH, Constants.CSV_DATA_ROW_SIZE)
	var embeddings_raw : Array = Utils.filter_dicts_array_to_array(data, ["x", "y", "z"])
	var embeddings_numbers : Array = Utils.string_array_to_num_array(embeddings_raw, "float")
	var embeddings_vectors : Array = Utils.numbers_array_to_Vector3_array(embeddings_numbers)
	var embeddings_normalised : Array = Geom.normalise_3d_embeddings(embeddings_vectors)
	var embeddings_bounding_box_proportions : Vector3 = Geom.get_3d_embeddings_bounding_box_proportions(embeddings_vectors)
	var embeddings_scaled : Array = Geom.scale_normalised_3d_embeddings(embeddings_normalised, 
																		embeddings_bounding_box_proportions, 
																		Constants.EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)	

	var slice_ids : Array = Utils.filter_dicts_array_to_array(data, ["slice_id"])
	slice_ids = Utils.string_array_to_num_array(slice_ids, "int")
	var ids : Array = Utils.filter_dicts_array_to_array(data, ["id"])
	ids = Utils.string_array_to_num_array(ids, "int")
	#var packed_embeddings : Array = circle_pack_embeddings_slices(embeddings_scaled, slice_ids, ids, Constants.LATENT_NODES_CIRCLE_MESH_RADIUS)
	#initiate_latent_space_slices(packed_embeddings, slice_ids, ids)
	
	initiate_latent_space_slices(embeddings_scaled, slice_ids, ids)
	
	var bounding_box_coords : Array = Geom.get_3d_bounding_box_from_vertices(embeddings_scaled)
	center_self(bounding_box_coords[0], bounding_box_coords[1])
#	if(DEBUG):
#		Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
#
#func _process(delta):
#	pass
	#for slice in get_tree().get_nodes_in_group("latent_space_slices"):
		#handle_slice_camera_distance_update(slice)
