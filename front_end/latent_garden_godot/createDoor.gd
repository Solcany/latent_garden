extends Spatial

export var door_width = 0.7
export var door_height = 0.8

func create_door():
	var stairs_amount = 40.0
	var step = 1.0 / stairs_amount
	print(step)
	var vertices = []
	
	vertices.append( Vector3( 0, -1, 1 ) )
	vertices.append( Vector3( 0, 1, 1 ) )
		
	vertices.append( Vector3( 0, 1, 1 ) )	
	vertices.append( Vector3( 0, 1, -1 ) )	
	
	vertices.append( Vector3( 0, 1, -1 ) )	
	vertices.append( Vector3( 0, -1, -1 ) )		
	
	vertices.append( Vector3( 0, -1, -1 ) )	
	vertices.append( Vector3( 0, -1, -door_width))			
	
	vertices.append( Vector3( 0, -1, -door_width))	
	vertices.append( Vector3( 0, door_height, -door_width))		
	
	vertices.append( Vector3( 0, door_height, -door_width))			
	vertices.append( Vector3( 0, door_height, door_width))	
				
	vertices.append( Vector3( 0, door_height, door_width))			
	vertices.append( Vector3( 0, -1, door_width))	
	
	vertices.append( Vector3( 0, -1, door_width))		
	vertices.append( Vector3( 0, -1, 1 ) )
		
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
	var door : MeshInstance = create_door()
	self.add_child(door)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
