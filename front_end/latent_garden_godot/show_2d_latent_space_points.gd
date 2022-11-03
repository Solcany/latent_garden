extends Node2D

const EMBEDDINGS_CSV_PATH = "data/embeddings/random_embeddings_2d.txt"
const EMBEDDINGS_ROW_SIZE = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var embeddings_data : Array = Utils.load_csv_of_floats(EMBEDDINGS_CSV_PATH, EMBEDDINGS_ROW_SIZE)
	var test = 1
