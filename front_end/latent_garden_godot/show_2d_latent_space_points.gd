extends Node2D

const EMBEDDINGS_CSV_PATH = "data/embeddings/random_embeddings_2d.txt"
const EMBEDDINGS_ROW_SIZE = 3
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var embeddings_data : Array = Utils.load_csv_of_floats(EMBEDDINGS_CSV_PATH, EMBEDDINGS_ROW_SIZE)
	var embeddings_vectors = Utils.array_to_Vector2(embeddings_data)
	var embeddings_normalised : Array = Geometry.normalise_2d_embeddings(embeddings_vectors)	
	var embeddings_bounding_box_proportions : Vector2 = Geometry.get_2d_embeddings_bounding_box_proportions(embeddings_data)
	var embeddings_scaled : Array = Geometry.scale_normalised_2d_embeddings(embeddings_normalised, 
																		embeddings_bounding_box_proportions, 
																		EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)
	var test = 1
