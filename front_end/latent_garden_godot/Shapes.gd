extends Reference

class_name Shapes

static func get_square_mesh():
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
	

static func create_circle_mesh_z_normal(center: Vector3 = Vector3(0, 0, 0), radius: float = 1, segments: int = 100) -> MeshInstance: 
	var vertices : Array = []
	
	# add the very first segment of the circle
	var x1 : float = cos(0.0) * radius + center.x
	var y1 : float = sin(0.0) * radius + center.y
	var z1 : float = 0 + center.z
	var first_vertex : Vector3 = Vector3(x1,y1,z1)
	
	# the first vertex of the first segment of the circle
	vertices.append(first_vertex)
	
	for i in range(1, segments):
		var scalar : float= float(i)/float(segments)
		var angle : float = PI*2*scalar			
		var x : float = cos(angle) * radius + center.x
		var y : float = sin(angle) * radius + center.y
		var z : float = 0 + center.z
		#var segment_start : Vector3 = vertices[i-1]
		var vertex : Vector3 = Vector3(x,y,z)
		# append the same vertex twice to form the end of the current segment
		# and the beginning of the next one
		vertices.append(vertex)		
		vertices.append(vertex)
	
	# the second vertex of the last segment of the circle
	vertices.append(first_vertex)
			
	var mesh = Mesh.new()
	var surf = SurfaceTool.new()
	var meshInstance = MeshInstance.new()
	
	surf.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices:
		surf.add_vertex(v)
	surf.index()
	surf.commit( mesh )
	meshInstance.set_mesh(mesh)
	return meshInstance

static func test_create_circle_mesh_z_normal(center: Vector3 = Vector3(0, 0, 0), radius: float = 1, segments: int = 100) -> MeshInstance: 
	var vertices : Array = []
	
	
	
#	# add the very first segment of the circle
#	var x1 : float = cos(0.0) * radius + center.x
#	var y1 : float = sin(0.0) * radius + center.y
#	var z1 : float = 0 + center.z
#	var first_vertex : Vector3 = Vector3(x1,y1,z1)
#
#	# the first vertex of the first segment of the circle
#	vertices.append(first_vertex)
#
	for i in range(1, segments):
		var scalar : float= float(i)/float(segments)
		var angle : float = PI*2*scalar			
		var x : float = cos(angle) * radius + center.x
		var y : float = sin(angle) * radius + center.y
		var z : float = 0 + center.z
		#var segment_start : Vector3 = vertices[i-1]
		var vertex : Vector3 = Vector3(x,y,z)
		# append the same vertex twice to form the end of the current segment
		# and the beginning of the next one
		#vertices.append(vertex)		
		#vertices.append(center)				
		#vertices.append(vertex)


#	# the second vertex of the last segment of the circle
#	vertices.append(first_vertex)
			
	var mesh = Mesh.new()
	var surf = SurfaceTool.new()
	var meshInstance = MeshInstance.new()
	
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(0.5,0,0.23)
	#mat.vertex_color_use_as_albedo = true
	
	surf.begin(Mesh.PRIMITIVE_TRIANGLES)


#	surf.add_vertex(Vector3(0,0.1,0))
#	surf.add_vertex(Vector3(0.1,0.1,0))
#	surf.add_vertex(Vector3(0.1,0,0))

	for v in vertices:
		surf.add_vertex(v)
		#surf.add_color(Color(1, 0, 0))
		#surf.add_uv(Vector2(0, 0))		
	surf.index()
	surf.generate_normals()
	surf.set_material(mat)
	surf.commit( mesh )

	meshInstance.set_mesh(mesh)

	
	
	return meshInstance
