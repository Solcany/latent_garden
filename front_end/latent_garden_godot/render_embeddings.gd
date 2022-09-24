extends Spatial

const EMBEDDINGS_DIMENSIONS = 3 # how many dimensions do the embeddings have?
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 10 # how long is the longest side of the bounding box of the embeddings?

func load_csv_of_floats(path : String, row_size: int) -> Array:
	# Godot interprets .csv files as game language translation...
	# ...it breaks when trying to load a regular non translation data .csv
	# therefore change .csv extension to .txt to load it successfuly
	var file = File.new()
	file.open(path, file.READ)
	
	var data = []
		
	while !file.eof_reached():
		var csv = file.get_csv_line()
		if(csv.size() == row_size):
			var data_row :Array = []
			for num in csv:
				data_row.append(float(num))
			data.append(data_row)
	file.close()
	
	print("csv: ", path, " loaded!")
	
	return data
	
func array_to_Vector3(array: Array) -> Array:
	# helper function to converst array of 3dim arrays to array of Vector3
	var vectors : Array = []
	for numbers in array:
		var vec = Vector3(numbers[0], numbers[1], numbers[2])
		vectors.append(vec)
	return vectors
	
func get_vec_array_max(array : Array, pos : String, max_val_init : int = -100000000 ) -> float:
	# find the highest float value in array
	# assumes array of arrays if dimension >= 0
	var max_val = max_val_init
	for vec in array:
		max_val = max(vec[pos], max_val)
	return max_val
	
func get_vec_array_min(array : Array, vec_coord : String, min_val_init : int = 100000000 ) -> float:
	# find the highest float value in array
	# assumes array of arrays if dimension >= 0
	var min_val = min_val_init
	for vec in array:
		min_val = min(vec[vec_coord], min_val)
	return min_val

func get_embeddings_bounding_box_proportions(embeddings) -> Vector3:
	var min_x : float= get_vec_array_min(embeddings, "x")
	var min_y : float= get_vec_array_min(embeddings, "y")
	var min_z : float= get_vec_array_min(embeddings, "z")
	var max_x : float= get_vec_array_max(embeddings, "x")
	var max_y : float= get_vec_array_max(embeddings, "y")
	var max_z : float= get_vec_array_max(embeddings, "z")
	var max_ : float = max(max_x, max_y)
	max_ = max(max_, max_z)
	var min_ : float = min(min_x, min_y)
	min_ = 	min(min_, min_z)

	var prop_x : float = range_lerp(max_x, min_, max_, 0.0, 1.0)
	var prop_y : float = range_lerp(max_y, min_, max_, 0.0, 1.0)	
	var prop_z : float = range_lerp(max_z, min_, max_, 0.0, 1.0)	
	return Vector3(prop_x, prop_y, prop_z)
		
func normalise_embeddings(embeddings: Array) -> Array:
	var min_x : float = get_vec_array_min(embeddings, "x")
	var min_y : float = get_vec_array_min(embeddings, "y")
	var min_z : float = get_vec_array_min(embeddings, "z")
	var max_x : float = get_vec_array_max(embeddings, "x")
	var max_y : float = get_vec_array_max(embeddings, "y")
	var max_z : float = get_vec_array_max(embeddings, "z")
	
	var normalised : Array = []
	for embedding in embeddings:
		var norm_x : float = range_lerp(embedding.x, min_x, max_x, 0.0, 1.0)
		var norm_y : float = range_lerp(embedding.y, min_y, max_y, 0.0, 1.0)
		var norm_z : float = range_lerp(embedding.z, min_z, max_z, 0.0, 1.0)
		normalised.append(Vector3(norm_x, norm_y, norm_z))
	return normalised
	
	
#vector<ofVec2f> ofApp::scale_vectors(vector<ofVec2f> &vectors, ofVec2f scalars, int max_width) {
#    float w = max_width * scalars.x;
#    float h = max_width * scalars.y;
#
#    vector<ofVec2f> scaled_vectors;
#    for(auto & v : vectors) {
#        ofVec2f scaled_v(v.x * w, v.y * h);
#        scaled_vectors.push_back(scaled_v);
#    }
#    return scaled_vectors;
#}

func scale_normalised_embeddings(embeddings : Array, bounding_box_proportions: Vector3, max_bounding_box_side_size: int) -> Array:
	var x_scalar : float = max_bounding_box_side_size * bounding_box_proportions.x
	var y_scalar : float = max_bounding_box_side_size * bounding_box_proportions.y	
	var z_scalar : float = max_bounding_box_side_size * bounding_box_proportions.z
	
	var scaled : Array = []		
	for embedding in embeddings:
		var scaled_x : float = embedding.x * x_scalar
		var scaled_y : float = embedding.y * y_scalar
		var scaled_z : float = embedding.z * z_scalar
		scaled.append(Vector3(scaled_x, scaled_y, scaled_z))
	return scaled		
			
				
# Called when the node enters the scene tree for the first time.
func _ready():
	var embeddings : Array = load_csv_of_floats("data/noise/sky_watch_data_friday_embeddings.txt", EMBEDDINGS_DIMENSIONS)
	embeddings = array_to_Vector3(embeddings)
	var embeddings_normalised : Array = normalise_embeddings(embeddings)	
	var embeddings_bounding_box_proportions : Vector3 = get_embeddings_bounding_box_proportions(embeddings)
	var embeddings_scaled : Array = scale_normalised_embeddings(embeddings_normalised, embeddings_bounding_box_proportions, EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)

	#print(get_vec_array_max(embeddings, "z")) # bug: returns -inf?
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
