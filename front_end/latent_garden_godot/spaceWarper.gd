extends Spatial

export var rooms_num = 20

var step_z = 0.11

func cube_create():
	var vertices = []
	# top
	vertices.append( Vector3( -1, -1, -1 ) )
	vertices.append( Vector3( 1, -1, -1 ) )
	vertices.append( Vector3( 1, -1, -1 ) )
	vertices.append( Vector3( 1, -1, 1 ) )
	vertices.append( Vector3( 1, -1, 1 ) )
	vertices.append( Vector3( -1, -1, 1 ) )
	vertices.append( Vector3( -1, -1, 1 ) )
	vertices.append( Vector3( -1, -1, -1 ) )
	# bottom
	vertices.append( Vector3( -1, 1, -1 ) )
	vertices.append( Vector3( 1, 1, -1 ) )
	vertices.append( Vector3( 1, 1, -1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )
	vertices.append( Vector3( -1, 1, 1 ) )
	vertices.append( Vector3( -1, 1, 1 ) )
	vertices.append( Vector3( -1, 1, -1 ) )
	
#	if sides:
	# sides
	vertices.append( Vector3( -1, -1, -1 ) )
	vertices.append( Vector3( -1, 1, -1 ) )
	vertices.append( Vector3( 1, -1, -1 ) )
	vertices.append( Vector3( 1, 1, -1 ) )
	vertices.append( Vector3( 1, -1, 1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )
	vertices.append( Vector3( -1, -1, 1 ) )
	vertices.append( Vector3( -1, 1, 1 ) )
		
	var _mesh = Mesh.new()
	var _surf = SurfaceTool.new()
	var _meshInstance = MeshInstance.new()
	
	_surf.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices:
		_surf.add_vertex(v)
	_surf.index()
	_surf.commit( _mesh )
	_meshInstance.set_mesh(_mesh)
	return _meshInstance

func _ready():
	for i in range(1,rooms_num+1):
		var _cube : MeshInstance = cube_create()
		_cube.scale = Vector3(global_variables.init_room_scale_x,
							 global_variables.init_room_scale_y,
							 global_variables.init_room_scale_z)
		_cube.name = "cube_" + str(i)
		self.add_child(_cube)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	for i in range(1, rooms_num+1):
		var cube = get_node("cube_" + str(i))
		if cube != null: 
			cube.translation.z = (-global_variables.room_scale_z * i)
			cube.scale = Vector3(global_variables.init_room_scale_x,
								global_variables.init_room_scale_y,
								global_variables.room_scale_z)
