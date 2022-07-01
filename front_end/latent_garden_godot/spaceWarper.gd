extends Spatial

export var detectors_num = 3
export var detector_scalar_z = 0.01
var step_z = 0.11
#export(bool) var sides = true setget _sides
#export(float) var split = 0 setget _split

#var processed_once = false
#var vertices = null

#func _sides( s ):
#	sides = s
#	if processed_once:
#		cube_create()
#
#func _split( s ):
#	if s < 0:
#		s = 0
#	elif s > 0.5:
#		s = 0.5
#	split = s
#	if processed_once:
#		cube_create()
#
#func split_vertices():
#	if split != 0:
#		var tmp = []
#		for v in vertices:
#			tmp.append( v )
#		vertices = []
#		for i in range( 0, len( tmp ) / 2 ):
#			var a = tmp[i*2]
#			var b = tmp[i*2 + 1]
#			var mid = b - a
#			vertices.append( a )
#			vertices.append( a + mid * split )
#			vertices.append( b )
#			vertices.append( b - mid * split )

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
	
#	split_vertices()
	
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
	#self.add_child(_meshInstance)

func _ready():
	for i in range(3):
		var _cube : MeshInstance = cube_create()
		#_cube.transform.origin = Vector3(0,0,0)
		_cube.scale = Vector3(global_variables.warp, 0.1, 0.1)
		_cube.translation.x = global_variables.warp*2 * i #step_z * i
		_cube.name = "cube_" + str(i)
		self.add_child(_cube)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	for i in range(3):
		var c = get_node("cube_" + str(i))
		if c != null: 
			#c.transform.origin = Vector3(global_variables.origin, 0.0, 0.0)
			c.translation.x = (global_variables.warp*2 * i)
			c.scale = Vector3(global_variables.warp, 0.1, 0.1)
