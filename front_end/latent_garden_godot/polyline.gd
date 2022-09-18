extends Spatial

func create_polyline(vertices: Array) -> MeshInstance:
	# excepts array of Vector3(s)
	# Godot 4 supports typed arrays! this'll work: (vertices: Array[Vector3])
	var _mesh = Mesh.new()
	var _surf = SurfaceTool.new()
	var _meshInstance = MeshInstance.new()

	_surf.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices:
		_surf.add_color(Color(1,0,0)) # set WorldEnvironment Ambient Light to a valuue to make this visible
		_surf.add_uv(Vector2(0, 0))
		_surf.add_vertex(v)
	_surf.index()
	_surf.commit( _mesh )
	_meshInstance.set_mesh(_mesh)
	return _meshInstance

func _ready():
		var vertices : Array= [Vector3(-1,-1,-1),
							   Vector3(2,2,0),
							   Vector3(2,2,0),
							   Vector3(1,2,2),
							   Vector3(1,2,2),
							   Vector3(3,4,1),
							   Vector3(3,4,1),
							   Vector3(-1,-1,-1)]
		var polyline : MeshInstance = create_polyline(vertices)

		var mat = SpatialMaterial.new()
		#mat.albedo_color = Color( 1, 0, 0 )
		mat.vertex_color_use_as_albedo = true
		#mat.emission = Color(1, 0, 0)
		#mat.emission_enabled = true
		#mat.emission_energy = 5
		polyline.set_surface_material(0, mat)
		
#		_cube.scale = Vector3(global_variables.init_room_scale_x,
#							 global_variables.init_room_scale_y,
#							 global_variables.init_room_scale_z)
		polyline.name = "line_" + str(0)
		self.add_child(polyline)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#
#	for i in range(1, rooms_num+1):
#		var cube = get_node("cube_" + str(i))
#		if cube != null: 
#			cube.translation.z = (-global_variables.room_scale_z * i)
#			cube.scale = Vector3(global_variables.init_room_scale_x,
#								global_variables.init_room_scale_y,
#								global_variables.room_scale_z)
