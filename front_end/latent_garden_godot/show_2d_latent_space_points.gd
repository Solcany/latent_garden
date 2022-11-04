tool
extends Spatial

const EMBEDDINGS_CSV_PATH = "data/embeddings/random_nums_3d_embeddings.txt"
const EMBEDDINGS_ROW_SIZE = 3
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 5
const EMBEDDINGS_CSV_SKIP_HEADER = true
const DEBUG = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func center_self(bounding_vec_min: Vector3, bounding_vec_max: Vector3) -> void: 
	self.translation.x = -bounding_vec_max.x/2
	self.translation.y = -bounding_vec_max.y/2
	self.translation.z = -bounding_vec_max.z/2
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var embeddings_raw : Array = Utils.load_csv_of_floats(EMBEDDINGS_CSV_PATH, 
														EMBEDDINGS_ROW_SIZE, 
														EMBEDDINGS_CSV_SKIP_HEADER)
	var embeddings_vectors = Utils.array_to_Vector3(embeddings_raw)
	var embeddings_normalised : Array = Geom.normalise_3d_embeddings(embeddings_vectors)
	var embeddings_bounding_box_proportions : Vector3 = Geom.get_3d_embeddings_bounding_box_proportions(embeddings_vectors)
	var embeddings_scaled : Array = Geom.scale_normalised_3d_embeddings(embeddings_normalised, 
																	embeddings_bounding_box_proportions, 
																	EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)
	var embeddings_mesh = Geom.get_points_mesh_from_vectors_arr(embeddings_scaled, Color(1,1,1))
	var embeddings_mesh_instance = MeshInstance.new()
	embeddings_mesh_instance.set_mesh(embeddings_mesh)
	Mat.assign_vertex_albedo_color_material(embeddings_mesh_instance)
	self.add_child(embeddings_mesh_instance)	
	
	var bounding_box_coords : Array = Geom.get_3d_bounding_box_from_vertices(embeddings_scaled)
	center_self(bounding_box_coords[0], bounding_box_coords[1])
	
	if(DEBUG):
		Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
		
		
