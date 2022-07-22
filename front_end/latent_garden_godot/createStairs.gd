extends Spatial


func create_stairs():
	var stairs_amount = 5
	var step = 1 / stairs_amount
	var vertices = []
	# vertical step
	vertices.append( Vector3( -1, 1, 1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )	
	vertices.append( Vector3( 1, step, 1 ) )	
	vertices.append( Vector3( -1, step, 1 ) )	
	vertices.append( Vector3( -1, 1, 1 ) )		
		
#	vertices.append( Vector3( 1, -1, -1 ) )
#	vertices.append( Vector3( 1, -1, -1 ) )
#	vertices.append( Vector3( 1, -1, 1 ) )
#	vertices.append( Vector3( 1, -1, 1 ) )
#	vertices.append( Vector3( -1, -1, 1 ) )
#	vertices.append( Vector3( -1, -1, 1 ) )
#	vertices.append( Vector3( -1, -1, -1 ) )

		
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
	var stairs : MeshInstance = create_stairs()
	#stairs.scale = Vector3(global_variables.init_room_scale_x,
	#					global_variables.init_room_scale_y,
	#					global_variables.init_room_scale_z)
	stairs.name = "stairs"
	self.add_child(stairs)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
