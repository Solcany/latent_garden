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
	
static func load_csv_to_dicts(csv_path : String, row_size: int) -> Array:
	# Godot interprets .csv files as game language translation...
	# ...it breaks when trying to load a regular non translation data .csv
	# therefore change .csv extension to .txt to load it successfuly
	
	# load csv into an array of dicts where keys are parsed from the csv header(1st csv line)
	var current_row_index : int = 0
	var csv_header : PoolStringArray
	var data : Array = []	
	
	var file = File.new()
	file.open(csv_path, file.READ)
	while !file.eof_reached():
		var	csv_row = file.get_csv_line()
		if(csv_row.size() == row_size):
			# the 1st line of csv file is expected to be the header
			if(current_row_index == 0):
				csv_header = csv_row
			else:
				var row_data : Dictionary = {}
				for i in csv_header.size():
					var key : String = csv_header[i]
					var value : String  =  csv_row[i]
					row_data[key] = value
				data.append(row_data)
		current_row_index += 1
	file.close()
	print("data from csv: ", csv_path, " loaded")
	return data

### ARRAYS ###

static func filter_dicts_array_to_array(dicts_array : Array, keys: Array) -> Array:
	var filtered: Array = []
	
	for dict in dicts_array:
		# if keys > 1, store dict vals in sub array
		if(keys.size() > 1):
			var new_array : Array = []			
			for key in keys:
				new_array.append(dict[key])
			filtered.append(new_array)
		# if there's 1 key, save the dict value directly in return array
		else:
			filtered.append(dict[keys[0]])

	return filtered
	
static func array_to_string(arr: Array, delimiter: String = ',') -> String:
	var s : String = ""
	for i in range(arr.size()):
		var el = arr[i]
		var el_type = typeof(el)
		# if the argument is array of arrays
		if(el_type == 19): # array type
			var sub_s : String = ""
			for sub_i in range(el.size()):
				var sub_el = el[sub_i]
				# don't add comma to the last sub element
				if(sub_i == el.size()-1):
					sub_s = sub_s + str(sub_el)
				else:
					sub_s = sub_s + str(sub_el) + delimiter
			if(i != arr.size()-1):
				sub_s = sub_s + "\n" #newline 
			# add substring to the returned string
			s = s + sub_s
		else:
			# don't add comma to the last element			
			if(i == arr.size()-1):
				s = s + str(el)
			else:
				s = s + str(el) + delimiter
	return s
	
static func string_to_array(string_array: String, delimiter: String = ',') -> Array:
	var pool_arr : PoolStringArray = string_array.split(delimiter)
	var arr : Array = []
	for v in pool_arr:
		arr.append(v)
	return arr
	
static func string_array_to_num_array(string_array: Array, num_type : String ="int") -> Array:
	var num_array = []
	for el in string_array: 
		# handle 2d array of numerical strings
		if(typeof(el) == 19): # array type
			var nums : Array = []
			for string in el:
				if(num_type == "int"):
					nums.append(int(string))
				elif(num_type == "float"):
					nums.append(float(string))
			num_array.append(nums)
		# handle simple numerical strings
		else:
			if(num_type == "int"):
				num_array.append(int(el))
			elif(num_type == "float"):
				num_array.append(float(el))	
	return num_array
		
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
	
static func numbers_array_to_Vector2_array(array: Array) -> Array:
	# helper function to converst array of 2dim arrays to array of Vector2
	var vectors : Array = []
	for numbers in array:
		var vec = Vector2(numbers[0], numbers[1])
		vectors.append(vec)
	return vectors

static func numbers_array_to_Vector3_array(array: Array) -> Array:
	# helper function to converst array of 3dim arrays to array of Vector3
	var vectors : Array = []
	for numbers in array:
		var vec = Vector3(numbers[0], numbers[1], numbers[2])
		vectors.append(vec)
	return vectors

static func get_array_max(array : Array, max_val_init : int = -100000000 ):
	# find the highest value in array	
	var max_val = max_val_init
	for val in array:
		max_val = max(val, max_val)
	return max_val

static func get_array_min(array : Array, min_val_init : int = 100000000 ):
	# find the lowest value in array
	var min_val = min_val_init
	for val in array:
		min_val = min(val, min_val)
	return min_val

static func get_vec_array_max(array : Array, pos : String, max_val_init : int = -100000000 ) -> float:
	# find the highest float value in array of vectors
	var max_val = max_val_init
	for vec in array:
		max_val = max(vec[pos], max_val)
	return max_val
	
static func get_vec_array_min(array : Array, vec_coord : String, min_val_init : int = 100000000 ) -> float:
	# find the lowest float value in array of vectors
	var min_val = min_val_init
	for vec in array:
		min_val = min(vec[vec_coord], min_val)
	return min_val
	
static func get_every_nth_el_of_array(array, n) -> Array:
	var new_array : Array = []
	for i in range(array.size()):
		if(i % n == 0):
			new_array.append(array[i])
	return new_array
	
static func remove_every_nth_el_of_array(array, n) -> Array:
	var new_array = array.duplicate()
	var n_removed : int = 0
	for i in range(array.size()):
		if(i % n == 0):
			new_array.remove(i - n_removed)
			n_removed += 1
	return new_array
		
### IMAGES, COLOR ###
	
static func load_images_to_textures(folder_path : String, extension : String, num_images: int, start_index: int = 1) -> Array:
	# expects folder with numbered image files, example: "1.jpg"
	var textures  : Array = []
	for i in range(start_index, num_images+start_index): #refactor: scan the folder for files, instead of using indexed loop
		var image_path = folder_path + str(i) + extension
		var texture : Texture = load(image_path)
		textures.append(texture)	
	return textures	

static func get_normalised_colors(colors: Array) -> Array:
	# convert array of rgb vals in 0-255 range to 0-1 range
	var normalised_colors : Array = [] 
	for c_arr in colors:
		var normalised : Array = []
		for c in c_arr:
			normalised.append(c/255.0)
		normalised_colors.append(Color(normalised[0], normalised[1], normalised[2]))
	return normalised_colors

static func decode_b64_image_to_texture(b64_image : String) -> ImageTexture:
	# decode image data to texture	
	var image : Image = Encode_utils.decode_b64_image_string(b64_image)
	var texture : ImageTexture = ImageTexture.new()
	texture.create_from_image(image, 0)
	return texture

### LERPING ###

### Lerping
static func get_linear_space(start, stop, steps, endpoint : bool = true) -> Array:
	if steps == 1:
		return [stop]

	var step : float
	if(endpoint):
		step = float(stop - start) / (int(steps)-1)
	else:
		step = float(stop - start) / int(steps)
	
	var ratios : Array = []	
	for i in range(steps):
		var ratio = start + step * i
		ratios.append(ratio)
	return ratios
	
static func lerp_vec3(pos1 : Vector3, pos2 : Vector3, weight: float) -> Vector3:
	var x : float = lerp(pos1.x, pos2.x, weight)
	var y : float = lerp(pos1.y, pos2.y, weight)
	var z : float = lerp(pos1.z, pos2.z, weight)
	return Vector3(x,y,z)
