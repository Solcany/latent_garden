extends Spatial

var all_vertices : Array= [Vector3(-1,-1,-1),
						   Vector3(2,2,0),
						   Vector3(2,2,0),
						   Vector3(1,2,2),
						   Vector3(1,2,2),
						   Vector3(3,4,1),
						   Vector3(3,4,1),
						   Vector3(-1,-1,-1)]
						
var vertices_slice : Array = all_vertices.slice(0,2)
var vertex_index : int = 2
var _timer = null

var rng = RandomNumberGenerator.new()					

func create_polyline_mesh(vertices: Array) -> Mesh:
	# excepts array of Vector3(s)
	# Godot 4 supports typed arrays! this'll work: (vertices: Array[Vector3])
	var _mesh = Mesh.new()
	var _surf = SurfaceTool.new()

	_surf.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices:
		var r = rng.randf()
		var g = rng.randf()	
		var b = rng.randf()
			
		_surf.add_color(Color(r,g,b)) # set WorldEnvironment Ambient Light to a valuue to make this visible
		_surf.add_uv(Vector2(0, 0))
		_surf.add_vertex(v)
	_surf.index()
	_surf.commit( _mesh )
	return _mesh

func _ready():
	var polyline_mesh : Mesh = create_polyline_mesh(vertices_slice)

	var polyline = MeshInstance.new();
	polyline.set_mesh(polyline_mesh)

	var mat = SpatialMaterial.new()

	# use vertex color to color the mesh
	mat.vertex_color_use_as_albedo = true

	# set color for the entire mesh
	#mat.albedo_color = Color( 1, 0, 0 )		
	#mat.emission = Color(1, 0, 0)

	# make it glow 

	#mat.emission_enabled = true
	#mat.emission_energy = 5

	polyline.set_surface_material(0, mat)

	polyline.name = "line_" + str(0)
	self.add_child(polyline)


	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var line = get_node("line_0")
	# assign new mesh at the runtime
	# it might be more efficient to 
	line.set_mesh(create_polyline_mesh(vertices_slice)) 
	#pass
#
#	for i in range(1, rooms_num+1):
#		var cube = get_node("cube_" + str(i))
#		if cube != null: 
#			cube.translation.z = (-global_variables.room_scale_z * i)
#			cube.scale = Vector3(global_variables.init_room_scale_x,
#								global_variables.init_room_scale_y,
#								global_variables.room_scale_z)
func _on_Timer_timeout():
	vertices_slice = all_vertices.slice(0, vertex_index)
	print(vertices_slice)
	vertex_index += 1 
