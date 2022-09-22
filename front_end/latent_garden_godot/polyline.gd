extends Spatial

var vertices : Array = []
						
var polyline_length : int = 1000 #vertices.size()
var vertex_index_initial : int = 2
var vertex_index : int = vertex_index_initial
var vertices_slice : Array = []
var timer = null # global timer
var timer_delay = 0.01 # seconds
var rng = RandomNumberGenerator.new()

func create_polyline_vertices(vertices : Array, close=false):
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
	
func create_polyline_mesh(polyline_vertices: Array) -> Mesh:
	# excepts array of Vector3(s)
	# WIP: Godot 4 supports typed arrays! this'll work: (vertices: Array[Vector3])
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
	
func set_polyline_material(polyline: MeshInstance):
	var mat = SpatialMaterial.new()

	# use vertex color to color the mesh
	mat.vertex_color_use_as_albedo = true

	# uncomment to set the color to the entire polyline
	#mat.albedo_color = Color( 1, 0, 0 )		
	# make it visible without external light source
	#mat.emission = Color(1, 0, 0)	
	#mat.emission_enabled = true
	#mat.emission_energy = 5
	
	polyline.set_surface_material(0, mat)
	
func init_timer(timer):
	# expects globally initialised variable
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(timer_delay)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	
func _on_Timer_timeout():
	print("tick")
	vertices_slice = vertices.slice(0, vertex_index)
	if(vertex_index >  polyline_length): 
		vertex_index = 0
	else:
		vertex_index += 1 
	
func _ready():
	var first_vertex = Vector3(rng.randf_range(-2.0, 2.0),
					  rng.randf_range(-2.0, 2.0),
					  rng.randf_range(-2.0, 2.0))	
	vertices.append(first_vertex)
	
	for i in range(polyline_length-1):
		var last_vertex = vertices[i]
		var new_vertex = Vector3(last_vertex.x + rng.randf_range(-0.2, 0.2),
								last_vertex.y + rng.randf_range(-0.2, 0.2),
								last_vertex.z + rng.randf_range(-0.2, 0.2))
		vertices.append(new_vertex)
		
	vertices_slice = vertices.slice(0,vertex_index)
	var polyline_mesh : Mesh = create_polyline_mesh(vertices_slice)
	var polyline = MeshInstance.new();
	set_polyline_material(polyline)
	polyline.set_mesh(polyline_mesh)
	polyline.name = "polyline_" + str(0)
	self.add_child(polyline)
	
	init_timer(timer)

func _process(_delta):
	var polyline = get_node("polyline_0")
	var polyline_vertices = create_polyline_vertices(vertices_slice)
	var mesh = create_polyline_mesh(polyline_vertices)
	polyline.set_mesh(mesh) 

#
#	for i in range(1, rooms_num+1):
#		var cube = get_node("cube_" + str(i))
#		if cube != null: 
#			cube.translation.z = (-global_variables.room_scale_z * i)
#			cube.scale = Vector3(global_variables.init_room_scale_x,
#								global_variables.init_room_scale_y,
#								global_variables.room_scale_z)

