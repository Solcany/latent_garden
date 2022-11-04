extends Object

class_name Utils

### ASSET IMPORTS ###
static func load_csv_of_floats(path : String, row_size: int, skip_header : bool = false) -> Array:
	# Godot interprets .csv files as game language translation...
	# ...it breaks when trying to load a regular non translation data .csv
	# therefore change .csv extension to .txt to load it successfuly
	var file : File = File.new()
	file.open(path, file.READ)
	
	var data : Array = []
	
	var current_row_index : int = 0	
	while !file.eof_reached():
		var csv = file.get_csv_line()
		if(csv.size() == row_size):
			var data_row : Array = []
			for num in csv:
				data_row.append(float(num))
			# skip header, header is the 1st csv line
			if(skip_header && current_row_index > 0):		
				data.append(data_row)	
			# if there's no header, consider the 1st line to be data
			elif(!skip_header):	
				data.append(data_row)	
		current_row_index += 1				
				
	file.close()
	print("csv: ", path, " loaded!")
	return data
	
static func load_embeddings_groups_from_csv(csv_path : String, row_size: int, skip_header: bool = true) -> Array:
	# Godot interprets .csv files as game language translation...
	# ...it breaks when trying to load a regular non translation data .csv
	# therefore change .csv extension to .txt to load it successfuly
	
	# func loads grouped embeddings(3d coordinates) from a csv
	# col 0 in the csv is expected to be the index of the emeddings group
	# the rest should be 3 cols of the 3d coordinates (x, y, z)
	var file = File.new()
	file.open(csv_path, file.READ)
	
	var embeddings : Array = []
	var embeddings_groups_indices : Array = []
	
	var current_row_index : int = 0
	while !file.eof_reached():
		var	csv_row = file.get_csv_line()
		if(csv_row.size() == row_size):
			var embedding : Vector3 = Vector3(float(csv_row[1]), float(csv_row[2]),float(csv_row[3]))
			var group_index: int = int(csv_row[0])

			# skip header, header must be 1st line of the read csv
			if(skip_header && current_row_index > 0):		
				embeddings_groups_indices.append(group_index)		
				embeddings.append(embedding)	
			# if there's no header, consider the 1st line to be data
			elif(!skip_header):	
				embeddings_groups_indices.append(group_index)	
				embeddings.append(embedding)
		current_row_index += 1
	file.close()
	
	print("data from csv: ", csv_path, " loaded")
	
	return [embeddings, embeddings_groups_indices]	
	
static func load_images_to_textures(folder_path : String, extension : String, num_images: int, start_index: int = 1) -> Array:
	# expects folder with numbered image files, example: "1.jpg"
	var textures  : Array = []
	for i in range(start_index, num_images+start_index): #refactor: scan the folder for files, instead of using indexed loop
		var image_path = folder_path + str(i) + extension
		var texture : Texture = load(image_path)
		textures.append(texture)	
	return textures	

static func get_unique_numbers_of_array(array: Array) -> Array:
	var uniques : Array = []
	
	for value in array:
		if(uniques.size() > 0):
			var is_value_unique: bool = true
			for unique_value in uniques:
				if(value == unique_value):
					is_value_unique = false
					break
			if(is_value_unique):
				uniques.append(value)
		else:
			uniques.append(value)
	
	return uniques

static func get_normalised_colors(colors: Array) -> Array:
	# convert array of rgb vals in 0-255 range to 0-1 range
	var normalised_colors : Array = [] 
	for c_arr in colors:
		var normalised : Array = []
		for c in c_arr:
			normalised.append(c/255.0)
		normalised_colors.append(Color(normalised[0], normalised[1], normalised[2]))
	return normalised_colors

static func array_to_Vector2(array: Array) -> Array:
	# helper function to converst array of 2dim arrays to array of Vector2
	var vectors : Array = []
	for numbers in array:
		var vec = Vector2(numbers[0], numbers[1])
		vectors.append(vec)
	return vectors

static func array_to_Vector3(array: Array) -> Array:
	# helper function to converst array of 3dim arrays to array of Vector3
	var vectors : Array = []
	for numbers in array:
		var vec = Vector3(numbers[0], numbers[1], numbers[2])
		vectors.append(vec)
	return vectors
	
	
static func get_vec_array_max(array : Array, pos : String, max_val_init : int = -100000000 ) -> float:
	# find the highest float value in array
	# assumes array of arrays if dimension >= 0
	var max_val = max_val_init
	for vec in array:
		max_val = max(vec[pos], max_val)
	return max_val
	
static func get_vec_array_min(array : Array, vec_coord : String, min_val_init : int = 100000000 ) -> float:
	# find the highest float value in array
	# assumes array of arrays if dimension >= 0
	var min_val = min_val_init
	for vec in array:
		min_val = min(vec[vec_coord], min_val)
	return min_val

