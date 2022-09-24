extends Spatial

### CONSTANTS ###
const EMBEDDINGS_DIMENSIONS = 3 # how many dimensions do the embeddings have?
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH = 1000 # how long is the longest side of the bounding box of the embeddings?
const TIMER_DELAY = 0.01
const VERTICES_INITIAL_INDEX = 2

### GLOBALS ###
var vertices_length : int = 0
var vertices_last_index : int = VERTICES_INITIAL_INDEX
var the_vertices : Array = [] # all vertices
var the_vertices_slice : Array = [] # slice of the vertices rendered in animation
var timer = null # global timer

### CSV IMPORT ###
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
		surf.add_color(Color(255,0,0)) 
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
		_surf.add_color(Color(255,0,0)) 
		_surf.add_uv(Vector2(0, 0))
		_surf.add_vertex(vertex)
	_surf.index()
	_surf.commit( _mesh )
	return _mesh	

func set_mesh_material(mesh: MeshInstance):
	var mat = SpatialMaterial.new()
	# use vertex color to color the mesh
	mat.vertex_color_use_as_albedo = true
	mesh.set_surface_material(0, mat)

				
### ANIMATION ###
# every tick of the timer additional embedding is added to the array of embeddings
# the array is rendered in the _process

func init_timer(timer):
	# expects globally initialised variable
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(TIMER_DELAY)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	
func _on_Timer_timeout():
	# increase last vertex index every on every timeout
	the_vertices_slice = the_vertices.slice(0, vertices_last_index)
	if(vertices_last_index >  vertices_length): 
		vertices_last_index = 0
	else:
		vertices_last_index += 1 		

### THE PROGRAM ###

func _ready():
	var embeddings : Array = load_csv_of_floats("data/noise/sky_watch_data_friday_embeddings.txt", EMBEDDINGS_DIMENSIONS)	
	embeddings = array_to_Vector3(embeddings)
	var embeddings_normalised : Array = normalise_embeddings(embeddings)	
	var embeddings_bounding_box_proportions : Vector3 = get_embeddings_bounding_box_proportions(embeddings)
	var embeddings_scaled : Array = scale_normalised_embeddings(embeddings_normalised, embeddings_bounding_box_proportions, EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH)
	
	# set the vertices of embeddings to a global variable
	# the global variable is used tot animate the embeddings
	the_vertices = embeddings_scaled
	
	# Initiate and add the embeddings Mesh Instance, the actual mesh will be set in _Process
	# var embeddings_mesh : Mesh = get_points_mesh(embeddings_scaled)
	var embeddings_mesh_instance = MeshInstance.new()
	set_mesh_material(embeddings_mesh_instance)
	#embeddings_mesh_instance.set_mesh(embeddings_mesh)
	embeddings_mesh_instance.name = "embeddings_mesh"
	self.add_child(embeddings_mesh_instance)	# add the embeddings mesh to the scene
	
	vertices_length = embeddings.size() # set global var
	init_timer(timer) # init global timer

func _process(delta):
	var embeddings_mesh = get_node("embeddings_mesh")
	var mesh : Mesh = get_polyline_mesh(get_polyline_vertices(the_vertices_slice))
	embeddings_mesh.set_mesh(mesh)
