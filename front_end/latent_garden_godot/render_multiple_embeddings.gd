extends Spatial

### CONSTANTS ###
const DEBUG = true
const SHOW_WEATHER_IMAGES = true
const EMBEDDINGS_CSV_PATH = "data/embeddings/sky_watch_gan_images_embeddings.txt"
const EMBEDDINGS_DIMENSIONS = 3 # how many dimensions do the embeddings have?
const HAS_INDEXED_EMBEDDINGS = true
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 20 # how long is the longest side of the bounding box of the embeddings?
const TIMER_DELAY = 0.01
const VERTICES_INITIAL_INDEX = 2
const IMAGES_FOLDER_PATH = "data/images/sky_watch_friday/"
const IMAGE_ASPECT_RATIO : Vector2 = Vector2(1.6, 0.8)
const IMAGE_EXT = ".JPG"
const NUM_IMAGES = 116 

### GLOBALS ###
var vertices_length : int = 0
var vertices_last_index : int = VERTICES_INITIAL_INDEX
var the_vertices : Array = [] # all vertices
var the_vertices_slice : Array = [] # slice of the vertices rendered in animation
var camera_ref = null

### ASSET IMPORTS ###
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
	
func load_embeddings_groups_from_csv(csv_path : String, row_size: int, skip_header: bool = true) -> Array:
	# Godot interprets .csv files as game language translation...
	# ...it breaks when trying to load a regular non translation data .csv
	# therefore change .csv extension to .txt to load it successfuly
	
	# func loads embeddings(3d coordinates) from a csv
	# col 0 in the csv is expected to be the index of the emeddings instance
	# the rest should be cols of 3d coordinates (x, y, z)
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
	
func load_images_to_textures(folder_path : String, extension : String, num_images: int, start_index: int = 1) -> Array:
	# expects folder with numbered image files, example: "1.jpg"
	var textures  : Array = []
	for i in range(start_index, num_images+start_index): #refactor: scan the folder for files, instead of using indexed loop
		var image_path = folder_path + str(i) + extension
		var texture : Texture = load(image_path)
		textures.append(texture)	
	return textures
	

	
### EMBEDDINGS GEOMETRY ###
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
	
### RENDERING ###
func get_points_mesh(vertices : Array) -> Mesh:
	var mesh = Mesh.new()
	var surf = SurfaceTool.new()

	surf.begin(Mesh.PRIMITIVE_POINTS)
	for vertex in vertices:
		# this sets color individually for each vertex
		# set WorldEnvironment Ambient Light to a value to make this visible
		surf.add_color(Color(255,255,255)) 
		surf.add_uv(Vector2(0, 0))
		surf.add_vertex(vertex)
	surf.index()
	surf.commit( mesh )
	return mesh
	
func get_polyline_vertices(vertices : Array, close=false):
# segements of polyline are created from a vertex pair
# duplicate every vertex except of the first and the last to create the connected segments
# Array of Vector3 is expected
	var polyline : Array = []
	for index in range(vertices.size()):
		var vertex : Vector3 = vertices[index]
		polyline.append(vertex)
		if(index > 0 && index < vertices.size()-1):
			# if the vertex is not the first nor the last create a duplicate
			polyline.append(vertex)
		if(close && index == vertices.size()-1):
			# with close=true argument create a closed polygon instead of polyline
			polyline.append(vertices[0])
	return polyline	
	
func get_polyline_mesh(polyline_vertices: Array) -> Mesh:
	# excepts array of Vector3(s)
	var _mesh = Mesh.new()
	var _surf = SurfaceTool.new()

	_surf.begin(Mesh.PRIMITIVE_LINES)
	for vertex in polyline_vertices:
		# this sets color individually for each vertex
		# set WorldEnvironment Ambient Light to a value to make this visible
		_surf.add_color(Color(255,255,255)) 
		_surf.add_uv(Vector2(0, 0))
		_surf.add_vertex(vertex)
	_surf.index()
	_surf.commit( _mesh )
	return _mesh	

func set_vertex_color_mesh_material(mesh: MeshInstance):
	var mat = SpatialMaterial.new()
	# use vertex color to color the mesh
	mat.vertex_color_use_as_albedo = true
	mesh.set_surface_material(0, mat)
	
func normalise_value(value):
	if(value <= 99):
		return value / 10.0
	elif (value > 99 && value <= 999):
		return value / 100.0
	elif (value > 999 && value <= 9999):
		return value / 1000.0
	elif (value > 9999 && value <= 99999):
		return value / 10000.0		
	## WIP: this should go beyond 99999, for now the func is only used for normalising aspect ratios
	# of images whose pixel dimension don't got beyond 99999

func get_normalised_texture_aspect_ratio(texture: Texture) -> Vector2:
	var width = texture.get_width()
	var height = texture.get_height()
	var normalised : Vector2 = Vector2(normalise_value(width), normalise_value(height))
	return normalised

func get_textured_meshes(positions : Array, textures: Array, mesh_width : int = 1, mesh_name_prefix : String = "mesh_") -> Array:
	assert(positions.size() == textures.size(), "ERROR: positions array size doesn't match the textures array size")
	var size : int = positions.size()
	var meshes : Array = []
	for index in range(size):
		var mesh : QuadMesh = QuadMesh.new()
		var mesh_instance: MeshInstance = MeshInstance.new()
		mesh_instance.set_mesh(mesh)
		var mat : SpatialMaterial = SpatialMaterial.new()
		var texture : Texture = textures[index]
		var texture_aspect_ratio = get_normalised_texture_aspect_ratio(texture)		
		mat.albedo_texture = texture
		mesh_instance.set_surface_material(0, mat)
		mesh_instance.scale = Vector3(mesh_width * texture_aspect_ratio.x,
									mesh_width * texture_aspect_ratio.y,
									0)
		var pos : Vector3 = positions[index]
		mesh_instance.translation = pos
		mesh_instance.set_rotation_degrees(Vector3(0, -90, 0))
		mesh_instance.name = mesh_name_prefix + str(index)
		meshes.append(mesh_instance)
	return meshes
	 
	
	
### DEBUG RENDERING ###

func create_cube_mesh(v1: Vector3, v2: Vector3) -> Mesh:
	#v1 is the back-top-left vertex of the cube
	#v2 is the front-bottom-right vertex of the cube
	
	var vertices = []
	##top
	#line1
	vertices.append( Vector3( v1.x, v1.y, v1.z ) )	
	vertices.append( Vector3( v2.x, v1.y, v1.z ) )	
	#line2
	vertices.append( Vector3( v2.x, v1.y, v1.z ) )	
	vertices.append( Vector3( v2.x, v1.y, v2.z ) )	
	#line3
	vertices.append( Vector3( v2.x, v1.y, v2.z ) )	
	vertices.append( Vector3( v1.x, v1.y, v2.z ) )	
	#line4
	vertices.append( Vector3( v1.x, v1.y, v2.z ) )	
	vertices.append( Vector3( v1.x, v1.y, v1.z ) )	
	
	
	##bottom
	#line1
	vertices.append( Vector3( v1.x, v2.y, v1.z ) )	
	vertices.append( Vector3( v2.x, v2.y, v1.z ) )	
	#line2
	vertices.append( Vector3( v2.x, v2.y, v1.z ) )	
	vertices.append( Vector3( v2.x, v2.y, v2.z ) )	
	#line3
	vertices.append( Vector3( v2.x, v2.y, v2.z ) )	
	vertices.append( Vector3( v1.x, v2.y, v2.z ) )	
	#line4
	vertices.append( Vector3( v1.x, v2.y, v2.z ) )	
	vertices.append( Vector3( v1.x, v2.y, v1.z ) )	
	
	##sides
	#line1
	vertices.append( Vector3( v1.x, v1.y, v1.z ) )		
	vertices.append( Vector3( v1.x, v2.y, v1.z ) )		
	#line2			
	vertices.append( Vector3( v2.x, v1.y, v1.z ) )	
	vertices.append( Vector3( v2.x, v2.y, v1.z ) )	
	#line3		
	vertices.append( Vector3( v2.x, v1.y, v2.z ) )	
	vertices.append( Vector3( v2.x, v2.y, v2.z ) )		
	#line4
	vertices.append( Vector3( v1.x, v1.y, v2.z ) )	
	vertices.append( Vector3( v1.x, v2.y, v2.z ) )	
		
	var mesh = Mesh.new()
	var surf = SurfaceTool.new()
	
	surf.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices:
		surf.add_vertex(v)
	surf.index()
	surf.commit( mesh )

	return mesh
	
func get_bounding_vertices(embeddings : Array)	 -> Dictionary:
	var min_x : float= get_vec_array_min(embeddings, "x")
	var min_y : float= get_vec_array_min(embeddings, "y")
	var min_z : float= get_vec_array_min(embeddings, "z")
	var max_x : float= get_vec_array_max(embeddings, "x")
	var max_y : float= get_vec_array_max(embeddings, "y")
	var max_z : float= get_vec_array_max(embeddings, "z")
	
	var min_vec = Vector3(min_x, min_y, min_z)
	var max_vec = Vector3(max_x, max_y, max_z)	
	
	return {"min": min_vec, "max": max_vec}
		
func create_embeddings_bounding_box_mesh(embeddings) -> MeshInstance:
	var bounding_vertices : Dictionary = get_bounding_vertices(embeddings)
	var bounding_box_mesh : Mesh = create_cube_mesh(bounding_vertices.min, bounding_vertices.max)
	var bounding_box_mesh_instance : MeshInstance = MeshInstance.new()
	bounding_box_mesh_instance.set_mesh(bounding_box_mesh)
	return bounding_box_mesh_instance

				
### ANIMATION ###
# Expects a Timer node in the parent scene tree
	
func _on_Timer_timeout():
	# on the tick of the timer the next embedding is added to the array of visible embeddings
	the_vertices_slice = the_vertices.slice(0, vertices_last_index)
	if(vertices_last_index >  vertices_length): 
		vertices_last_index = 0
	else:
		vertices_last_index += 1 		

### THE PROGRAM ###

func _ready():
	var csv_row_length = EMBEDDINGS_DIMENSIONS
	if(HAS_INDEXED_EMBEDDINGS):
		csv_row_length += 1
	var embeddings : Array = load_embeddings_groups_from_csv(EMBEDDINGS_CSV_PATH, csv_row_length)	
	print(embeddings[0])
#	embeddings = array_to_Vector3(embeddings)
	var embeddings_normalised : Array = normalise_embeddings(embeddings)	
#	var embeddings_bounding_box_proportions : Vector3 = get_embeddings_bounding_box_proportions(embeddings)
#	var embeddings_scaled : Array = scale_normalised_embeddings(embeddings_normalised, 
#															embeddings_bounding_box_proportions, 
#															EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)
	
	# set the vertices of embeddings to a global variable
	# the global variable is used tot animate the embeddings
	#the_vertices = embeddings_scaled
	
	# set camera reference
	#camera_ref = get_parent().get_node("fps_player")
	
	# preload all weather images as textures
#	if(SHOW_WEATHER_IMAGES):
#		var textures = load_images_to_textures(IMAGES_FOLDER_PATH, IMAGE_EXT, NUM_IMAGES)
#		var weather_image_meshes = get_textured_meshes(embeddings_scaled, textures, 2, "weather_mesh_")
#		for mesh in weather_image_meshes:
#			self.add_child(mesh)
	
	# Initiate and add the embeddings Mesh Instance, the actual mesh will be set in _Process
	# var embeddings_mesh : Mesh = get_points_mesh(embeddings_scaled)
	#var embeddings_mesh_instance = MeshInstance.new()
	#set_vertex_color_mesh_material(embeddings_mesh_instance)
	#embeddings_mesh_instance.set_mesh(embeddings_mesh)
	#embeddings_mesh_instance.name = "embeddings_mesh"
	#self.add_child(embeddings_mesh_instance)	# add the embeddings mesh to the scene
	
	# set amount of embeddings	
	#vertices_length = embeddings.size() # set the global var

	
	if(DEBUG):
		pass
		# show the embeddings as points		
#		var embeddings_as_points = MeshInstance.new()
#		embeddings_as_points.set_mesh(get_points_mesh(the_vertices))	
#		set_vertex_color_mesh_material(embeddings_as_points)	
#		self.add_child(embeddings_as_points)	
#
#		# show embeddings bounding box 
#		var embeddings_bounding_box_mesh : MeshInstance = create_embeddings_bounding_box_mesh(embeddings_scaled)
#		self.add_child(embeddings_bounding_box_mesh)			
	
func _process(delta):
	pass
	# animate embeddings polyline
	#var embeddings_mesh = get_node("embeddings_mesh")
	#var mesh : Mesh = get_polyline_mesh(get_polyline_vertices(the_vertices_slice))
	#embeddings_mesh.set_mesh(mesh)
	
	# make weather images follow the camera movement
	# WIP: doesn't work, probably issue with the Up vector set in the look_at func
	#	for index in range(vertices_length):
	#		var weather_mesh = get_node("weather_mesh_" + str(index))
	#		weather_mesh.look_at(camera_ref.translation, Vector3(0,0,0))
		
	
	
