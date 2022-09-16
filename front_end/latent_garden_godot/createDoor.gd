extends Spatial

export var door_width = 0.7
export var door_height = 0.8
var height = global_variables.init_room_scale_y;

func create_door():
	var vertices = []
	
	vertices.append( Vector3( 0, -height, 1 ) )
	vertices.append( Vector3( 0, height, 1 ) )
		
	vertices.append( Vector3( 0, height, 1 ) )	
	vertices.append( Vector3( 0, height, -1 ) )	
	
	vertices.append( Vector3( 0, height, -1 ) )	
	vertices.append( Vector3( 0, -height, -1 ) )		
	
	vertices.append( Vector3( 0, -height, -1 ) )	
	vertices.append( Vector3( 0, -height, -door_width))			
	
	vertices.append( Vector3( 0, -height, -door_width))	
	vertices.append( Vector3( 0, door_height, -door_width))		
	
	vertices.append( Vector3( 0, door_height, -door_width))			
	vertices.append( Vector3( 0, door_height, door_width))	
				
	vertices.append( Vector3( 0, door_height, door_width))			
	vertices.append( Vector3( 0, -height, door_width))	
	
	vertices.append( Vector3( 0, -height, door_width))		
	vertices.append( Vector3( 0, -height, 1 ) )
		
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

func setup(width_ratio, height_ratio):
	door_width = 1 * width_ratio
	door_height = height * height_ratio

func _ready():
	var door : MeshInstance = create_door()
	self.add_child(door)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
