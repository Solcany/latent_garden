tool
extends Spatial

const EMBEDDINGS_CSV_PATH = "data/embeddings/random_nums_3d_embeddings.txt"
const EMBEDDINGS_ROW_SIZE = 3
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 5
const EMBEDDINGS_CSV_SKIP_HEADER = true
const LATENT_NODES_GROUP_NAME = "latent_nodes"
const DEBUG = true
var Latent_space_node = load("res://Latent_space_node.tscn")

signal return_selected_latent_nodes_ids

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
		
func add_latent_space_nodes_to_scene(points: Array) -> void:
	for i in points.size():
		var node = Latent_space_node.instance()
		node.translation = points[i]
		node.id = i
		node.add_to_group(LATENT_NODES_GROUP_NAME)
		self.add_child(node)

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
		
	
	
	# set their image textures
	
		
func _ready():
	# connect signals
	connect("return_selected_latent_nodes_ids", get_node("/root/App"), "_on_return_selected_latent_nodes_ids")
	
	# process the embeddings csv
	var embeddings_raw : Array = Utils.load_csv_of_floats(EMBEDDINGS_CSV_PATH, 
														  EMBEDDINGS_ROW_SIZE, 
														  EMBEDDINGS_CSV_SKIP_HEADER)
	var embeddings_vectors = Utils.array_to_Vector3(embeddings_raw)
	var embeddings_normalised : Array = Geom.normalise_3d_embeddings(embeddings_vectors)
	var embeddings_bounding_box_proportions : Vector3 = Geom.get_3d_embeddings_bounding_box_proportions(embeddings_vectors)
	var embeddings_scaled : Array = Geom.scale_normalised_3d_embeddings(embeddings_normalised, 
																	embeddings_bounding_box_proportions, 
																	EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)
	add_points_mesh_to_scene(embeddings_scaled)
	add_latent_space_nodes_to_scene(embeddings_scaled)
	
	var bounding_box_coords : Array = Geom.get_3d_bounding_box_from_vertices(embeddings_scaled)
	center_self(bounding_box_coords[0], bounding_box_coords[1])
	if(DEBUG):
		Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
		
		
