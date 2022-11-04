extends Spatial

const EMBEDDINGS_CSV_PATH = "data/embeddings/random_nums_3d_embeddings.txt"
const EMBEDDINGS_ROW_SIZE = 3
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 200
const EMBEDDINGS_CSV_SKIP_HEADER = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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

