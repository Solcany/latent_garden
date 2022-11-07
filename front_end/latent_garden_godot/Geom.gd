extends Reference

class_name Geom


## Embeddings

static func group_embeddings(embeddings : Array, embeddings_group_indices: Array) -> Array:
	var n_groups : Array = Utils.get_unique_numbers_of_array(embeddings_group_indices)
	var grouped_embeddings : Array = []
	for i_group in n_groups:
		grouped_embeddings.append([])
		for i in range(embeddings.size()):
			if (embeddings_group_indices[i] == i_group):
				grouped_embeddings[i_group].append(embeddings[i])
	return grouped_embeddings
	
static func get_3d_bounding_box_from_vertices(vertices : Array) -> Array:
	var min_x : float= Utils.get_vec_array_min(vertices, "x")
	var min_y : float= Utils.get_vec_array_min(vertices, "y")
	var min_z : float= Utils.get_vec_array_min(vertices, "z")
	var max_x : float= Utils.get_vec_array_max(vertices, "x")
	var max_y : float= Utils.get_vec_array_max(vertices, "y")
	var max_z : float= Utils.get_vec_array_max(vertices, "z")

	var min_vec = Vector3(min_x, min_y, min_z)
	var max_vec = Vector3(max_x, max_y, max_z)	

	return [min_vec, max_vec]
	
static func get_3d_embeddings_bounding_box_proportions(embeddings) -> Vector3:
	var min_x : float= Utils.get_vec_array_min(embeddings, "x")
	var min_y : float= Utils.get_vec_array_min(embeddings, "y")
	var min_z : float= Utils.get_vec_array_min(embeddings, "z")
	var max_x : float= Utils.get_vec_array_max(embeddings, "x")
	var max_y : float= Utils.get_vec_array_max(embeddings, "y")
	var max_z : float= Utils.get_vec_array_max(embeddings, "z")
	var max_ : float = max(max_x, max_y)
	max_ = max(max_, max_z)
	var min_ : float = min(min_x, min_y)
	min_ = 	min(min_, min_z)
	var prop_x : float = range_lerp(max_x, min_, max_, 0.0, 1.0)
	var prop_y : float = range_lerp(max_y, min_, max_, 0.0, 1.0)	
	var prop_z : float = range_lerp(max_z, min_, max_, 0.0, 1.0)	
	return Vector3(prop_x, prop_y, prop_z)
	
static func get_2d_embeddings_bounding_box_proportions(embeddings) -> Vector2:
	var min_x : float= Utils.get_vec_array_min(embeddings, "x")
	var min_y : float= Utils.get_vec_array_min(embeddings, "y")
	var max_x : float= Utils.get_vec_array_max(embeddings, "x")
	var max_y : float= Utils.get_vec_array_max(embeddings, "y")
	var max_ : float = max(max_x, max_y)
	var min_ : float = min(min_x, min_y)
	var prop_x : float = range_lerp(max_x, min_, max_, 0.0, 1.0)
	var prop_y : float = range_lerp(max_y, min_, max_, 0.0, 1.0)	
	return Vector2(prop_x, prop_y)	
		
static func normalise_3d_embeddings(embeddings: Array) -> Array:
	var min_x : float = Utils.get_vec_array_min(embeddings, "x")
	var min_y : float = Utils.get_vec_array_min(embeddings, "y")
	var min_z : float = Utils.get_vec_array_min(embeddings, "z")
	var max_x : float = Utils.get_vec_array_max(embeddings, "x")
	var max_y : float = Utils.get_vec_array_max(embeddings, "y")
	var max_z : float = Utils.get_vec_array_max(embeddings, "z")
	var normalised : Array = []
	for embedding in embeddings:
		var norm_x : float
		if(min_x == max_x):
			norm_x = embedding.x
		else:	
			norm_x = range_lerp(embedding.x, min_x, max_x, 0.0, 1.0)
			
		var norm_y : float
		if(min_y == max_y):
			norm_y = embedding.y
		else:	
			norm_y = range_lerp(embedding.y, min_y, max_y, 0.0, 1.0)			
			
		var norm_z : float
		if(min_z == max_z):
			norm_z = embedding.z
		else:	
			norm_z = range_lerp(embedding.z, min_z, max_z, 0.0, 1.0)		

		normalised.append(Vector3(norm_x, norm_y, norm_z))
	return normalised
	
static func normalise_2d_embeddings(embeddings: Array) -> Array:
	var min_x : float = Utils.get_vec_array_min(embeddings, "x")
	var min_y : float = Utils.get_vec_array_min(embeddings, "y")
	var max_x : float = Utils.get_vec_array_max(embeddings, "x")
	var max_y : float = Utils.get_vec_array_max(embeddings, "y")
	
	var normalised : Array = []
	for embedding in embeddings:
		var norm_x : float
		if(min_x == max_x):
			norm_x = embedding.x
		else:	
			norm_x = range_lerp(embedding.x, min_x, max_x, 0.0, 1.0)
			
		var norm_y : float
		if(min_y == max_y):
			norm_y = embedding.y
		else:	
			norm_y = range_lerp(embedding.y, min_y, max_y, 0.0, 1.0)
			
		normalised.append(Vector2(norm_x, norm_y))
	return normalised	
	
static func scale_normalised_3d_embeddings(embeddings : Array, bounding_box_proportions: Vector3, max_bounding_box_side_size: int) -> Array:
	var x_scalar : float = max_bounding_box_side_size * bounding_box_proportions.x
	var y_scalar : float = max_bounding_box_side_size * bounding_box_proportions.y	
	var z_scalar : float = max_bounding_box_side_size * bounding_box_proportions.z
	var scaled : Array = []		
	for embedding in embeddings:
		var scaled_x : float = embedding.x * x_scalar
		var scaled_y : float = embedding.y * y_scalar
		var scaled_z : float = embedding.z * z_scalar
		scaled.append(Vector3(scaled_x, scaled_y, scaled_z))
	return scaled	
	
static func scale_normalised_2d_embeddings(embeddings : Array, bounding_box_proportions: Vector2, max_bounding_box_side_size: int) -> Array:
	var x_scalar : float = max_bounding_box_side_size * bounding_box_proportions.x
	var y_scalar : float = max_bounding_box_side_size * bounding_box_proportions.y	
	var scaled : Array = []		
	for embedding in embeddings:
		var scaled_x : float = embedding.x * x_scalar
		var scaled_y : float = embedding.y * y_scalar
		scaled.append(Vector2(scaled_x, scaled_y))
	return scaled	
		
	
### Mesh
static func get_points_mesh_from_vectors_arr(vertices : Array, vertex_color: Color = Color(255,255,255)) -> Mesh:
	var mesh = Mesh.new()
	var surf = SurfaceTool.new()

	surf.begin(Mesh.PRIMITIVE_POINTS)
	for vertex in vertices:
		# this sets color individually for each vertex
		# set WorldEnvironment Ambient Light to a value to make this visible
		surf.add_color(vertex_color) 
		surf.add_uv(Vector2(0, 0))
		surf.add_vertex(vertex)
	surf.index()
	surf.commit( mesh )
	return mesh
	
	
static func get_cube_mesh(min_vec: Vector3, max_vec: Vector3) -> Mesh:
	#min_vec is the back-top-left vertex of the cube
	#max_vec is the front-bottom-right vertex of the cube
	
	var vertices = []
	##top
	#line1
	vertices.append( Vector3( min_vec.x, min_vec.y, min_vec.z ) )	
	vertices.append( Vector3( max_vec.x, min_vec.y, min_vec.z ) )	
	#line2
	vertices.append( Vector3( max_vec.x, min_vec.y, min_vec.z ) )	
	vertices.append( Vector3( max_vec.x, min_vec.y, max_vec.z ) )	
	#line3
	vertices.append( Vector3( max_vec.x, min_vec.y, max_vec.z ) )	
	vertices.append( Vector3( min_vec.x, min_vec.y, max_vec.z ) )	
	#line4
	vertices.append( Vector3( min_vec.x, min_vec.y, max_vec.z ) )	
	vertices.append( Vector3( min_vec.x, min_vec.y, min_vec.z ) )	
	
	
	##bottom
	#line1
	vertices.append( Vector3( min_vec.x, max_vec.y, min_vec.z ) )	
	vertices.append( Vector3( max_vec.x, max_vec.y, min_vec.z ) )	
	#line2
	vertices.append( Vector3( max_vec.x, max_vec.y, min_vec.z ) )	
	vertices.append( Vector3( max_vec.x, max_vec.y, max_vec.z ) )	
	#line3
	vertices.append( Vector3( max_vec.x, max_vec.y, max_vec.z ) )	
	vertices.append( Vector3( min_vec.x, max_vec.y, max_vec.z ) )	
	#line4
	vertices.append( Vector3( min_vec.x, max_vec.y, max_vec.z ) )	
	vertices.append( Vector3( min_vec.x, max_vec.y, min_vec.z ) )	
	
	##sides
	#line1
	vertices.append( Vector3( min_vec.x, min_vec.y, min_vec.z ) )		
	vertices.append( Vector3( min_vec.x, max_vec.y, min_vec.z ) )		
	#line2			
	vertices.append( Vector3( max_vec.x, min_vec.y, min_vec.z ) )	
	vertices.append( Vector3( max_vec.x, max_vec.y, min_vec.z ) )	
	#line3		
	vertices.append( Vector3( max_vec.x, min_vec.y, max_vec.z ) )	
	vertices.append( Vector3( max_vec.x, max_vec.y, max_vec.z ) )		
	#line4
	vertices.append( Vector3( min_vec.x, min_vec.y, max_vec.z ) )	
	vertices.append( Vector3( min_vec.x, max_vec.y, max_vec.z ) )	
		
	var mesh = Mesh.new()
	var surf = SurfaceTool.new()
	
	surf.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices:
		surf.add_vertex(v)
	surf.index()
	surf.commit( mesh )

	return mesh
	
static func add_debug_box_to_the_scene(self_ref: Node , bounding_vec_min : Vector3,  bounding_vec_max : Vector3) -> void:
	var bounding_box_mesh : Mesh = get_cube_mesh(bounding_vec_min, bounding_vec_max)
	var bounding_box_mesh_instance = MeshInstance.new()
	bounding_box_mesh_instance.set_mesh(bounding_box_mesh)
	self_ref.add_child(bounding_box_mesh_instance)
	
static func get_bounding_box_from_vec3(vec: Vector3) -> Array:
	var bounding_box_min = Vector3(-vec.x/2, -vec.y/2, -vec.z/2)
	var bounding_box_max = Vector3(vec.x/2, vec.y/2, vec.z/2)
	return[bounding_box_min, bounding_box_max]
#func get_polyline_vertices(vertices : Array, close=false) -> Array:
## segements of polyline are created from a vertex pair
## duplicate every vertex except of the first and the last to create the connected segments
## Array of Vector3 is expected
#	var polyline : Array = []
#	for index in range(vertices.size()):
#		var vertex : Vector3 = vertices[index]
#		polyline.append(vertex)
#		if(index > 0 && index < vertices.size()-1):
#			# if the vertex is not the first nor the last create a duplicate
#			polyline.append(vertex)
#		if(close && index == vertices.size()-1):
#			# with close=true argument create a closed polygon instead of polyline
#			polyline.append(vertices[0])
#	return polyline	
#
#func get_polyline_mesh(polyline_vertices: Array, vertex_color: Color = Color(255,255,255)) -> Mesh:
#	# excepts array of Vector3(s)
#	var _mesh = Mesh.new()
#	var _surf = SurfaceTool.new()
#
#	_surf.begin(Mesh.PRIMITIVE_LINES)
#	for vertex in polyline_vertices:
#		# this sets color individually for each vertex
#		# set WorldEnvironment Ambient Light to a value to make this visible
#		_surf.add_color(vertex_color) 
#		_surf.add_uv(Vector2(0, 0))
#		_surf.add_vertex(vertex)
#	_surf.index()
#	_surf.commit( _mesh )
#	return _mesh	
#
#func set_vertex_color_mesh_material(mesh: MeshInstance):
#	var mat = SpatialMaterial.new()
#	# use vertex color to color the mesh
#	mat.vertex_color_use_as_albedo = true
#	mesh.set_surface_material(0, mat)
#
#func set_mesh_albedo_color(mesh: MeshInstance, color: Color):
#	var mat = SpatialMaterial.new()
#	mat.albedo_color = color 
#	mesh.set_surface_material(0, mat)		
#
#func normalise_value(value):
#	if(value <= 99):
#		return value / 10.0
#	elif (value > 99 && value <= 999):
#		return value / 100.0
#	elif (value > 999 && value <= 9999):
#		return value / 1000.0
#	elif (value > 9999 && value <= 99999):
#		return value / 10000.0		
#	## WIP: this should go beyond 99999, for now the func is only used for normalising aspect ratios
#	# of images whose pixel dimension don't got beyond 99999
#
#func get_normalised_texture_aspect_ratio(texture: Texture) -> Vector2:
#	var width = texture.get_width()
#	var height = texture.get_height()
#	var normalised : Vector2 = Vector2(normalise_value(width), normalise_value(height))
#	return normalised
#
#func get_textured_meshes(positions : Array, textures: Array, mesh_width : int = 1, mesh_name_prefix : String = "mesh_") -> Array:
#	assert(positions.size() == textures.size(), "ERROR: positions array size doesn't match the textures array size")
#	var size : int = positions.size()
#	var meshes : Array = []
#	for index in range(size):
#		var mesh : QuadMesh = QuadMesh.new()
#		var mesh_instance: MeshInstance = MeshInstance.new()
#		mesh_instance.set_mesh(mesh)
#		var mat : SpatialMaterial = SpatialMaterial.new()
#		var texture : Texture = textures[index]
#		var texture_aspect_ratio = get_normalised_texture_aspect_ratio(texture)		
#		mat.albedo_texture = texture
#		mesh_instance.set_surface_material(0, mat)
#		mesh_instance.scale = Vector3(mesh_width * texture_aspect_ratio.x,
#									mesh_width * texture_aspect_ratio.y,
#									0)
#		var pos : Vector3 = positions[index]
#		mesh_instance.translation = pos
#		mesh_instance.set_rotation_degrees(Vector3(0, -90, 0))
#		mesh_instance.name = mesh_name_prefix + str(index)
#		meshes.append(mesh_instance)
#	return meshes
#
#func add_embeddings_groups_meshes_to_scene(grouped_embeddings: Array, groups_colors : Array) -> void:	
#	for group_i in range(grouped_embeddings.size()):
#		var group = grouped_embeddings[group_i]
#		# Initiate and add the embeddings Mesh Instance, the actual mesh will be set in _Process		
#		var polyline_vertices : Array = get_polyline_vertices(group)
#		var group_mesh : Mesh = get_polyline_mesh(polyline_vertices, groups_colors[group_i])
#		var group_mesh_instance = MeshInstance.new()
#
#		group_mesh_instance.set_mesh(group_mesh)
#		set_vertex_color_mesh_material(group_mesh_instance)	
#		# always set the material only after the mesh was set
#		#set_mesh_albedo_color(group_mesh_instance, groups_colors[group_i])		
#		group_mesh_instance.name = "mesh_group_" + str(group_i)
#		# add the embeddings mesh to the scene
#		self.add_child(group_mesh_instance)	
				
				
### DEBUG RENDERING ###

#func create_cube_mesh(min_vec: Vector3, max_vec: Vector3) -> Mesh:
#	#min_vec is the back-top-left vertex of the cube
#	#max_vec is the front-bottom-right vertex of the cube
#
#	var vertices = []
#	##top
#	#line1
#	vertices.append( Vector3( min_vec.x, min_vec.y, min_vec.z ) )	
#	vertices.append( Vector3( max_vec.x, min_vec.y, min_vec.z ) )	
#	#line2
#	vertices.append( Vector3( max_vec.x, min_vec.y, min_vec.z ) )	
#	vertices.append( Vector3( max_vec.x, min_vec.y, max_vec.z ) )	
#	#line3
#	vertices.append( Vector3( max_vec.x, min_vec.y, max_vec.z ) )	
#	vertices.append( Vector3( min_vec.x, min_vec.y, max_vec.z ) )	
#	#line4
#	vertices.append( Vector3( min_vec.x, min_vec.y, max_vec.z ) )	
#	vertices.append( Vector3( min_vec.x, min_vec.y, min_vec.z ) )	
#
#
#	##bottom
#	#line1
#	vertices.append( Vector3( min_vec.x, max_vec.y, min_vec.z ) )	
#	vertices.append( Vector3( max_vec.x, max_vec.y, min_vec.z ) )	
#	#line2
#	vertices.append( Vector3( max_vec.x, max_vec.y, min_vec.z ) )	
#	vertices.append( Vector3( max_vec.x, max_vec.y, max_vec.z ) )	
#	#line3
#	vertices.append( Vector3( max_vec.x, max_vec.y, max_vec.z ) )	
#	vertices.append( Vector3( min_vec.x, max_vec.y, max_vec.z ) )	
#	#line4
#	vertices.append( Vector3( min_vec.x, max_vec.y, max_vec.z ) )	
#	vertices.append( Vector3( min_vec.x, max_vec.y, min_vec.z ) )	
#
#	##sides
#	#line1
#	vertices.append( Vector3( min_vec.x, min_vec.y, min_vec.z ) )		
#	vertices.append( Vector3( min_vec.x, max_vec.y, min_vec.z ) )		
#	#line2			
#	vertices.append( Vector3( max_vec.x, min_vec.y, min_vec.z ) )	
#	vertices.append( Vector3( max_vec.x, max_vec.y, min_vec.z ) )	
#	#line3		
#	vertices.append( Vector3( max_vec.x, min_vec.y, max_vec.z ) )	
#	vertices.append( Vector3( max_vec.x, max_vec.y, max_vec.z ) )		
#	#line4
#	vertices.append( Vector3( min_vec.x, min_vec.y, max_vec.z ) )	
#	vertices.append( Vector3( min_vec.x, max_vec.y, max_vec.z ) )	
#
#	var mesh = Mesh.new()
#	var surf = SurfaceTool.new()
#
#	surf.begin(Mesh.PRIMITIVE_LINES)
#	for v in vertices:
#		surf.add_vertex(v)
#	surf.index()
#	surf.commit( mesh )
#
#	return mesh
#

#
#func create_embeddings_bounding_box_mesh(embeddings) -> MeshInstance:
#	var bounding_vertices : Dictionary = get_bounding_vertices(embeddings)
#	var bounding_box_mesh : Mesh = create_cube_mesh(bounding_vertices.min, bounding_vertices.max)
#	var bounding_box_mesh_instance : MeshInstance = MeshInstance.new()
#	bounding_box_mesh_instance.set_mesh(bounding_box_mesh)
#	return bounding_box_mesh_instance
