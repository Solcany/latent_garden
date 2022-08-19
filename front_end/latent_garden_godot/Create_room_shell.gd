extends Spatial
# creates wireframey shell

func create_cube():
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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var shell : MeshInstance = create_cube()
	self.add_child(shell)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
