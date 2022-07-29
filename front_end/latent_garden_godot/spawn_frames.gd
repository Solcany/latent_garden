extends Spatial
var Frame = load("res://Frame.tscn")
var frames_ref = null
onready var room_index = get_parent().room_index

func create_frames():
	var low_extent_z =  -global_variables.room_scale_z
	var high_extent_z = global_variables.room_scale_z
	var dist = abs(low_extent_z) + abs(high_extent_z)
	var frame_width = global_variables.frame_scale.z + global_variables.frame_padding_z
	var frames_amt = floor(dist / frame_width)
	var frames_parent = Spatial.new()
	frames_parent.name = "frames_parent"
		
	for i in range(frames_amt):
		var frame = Frame.instance()
		var frame_name = "frame_" + str(i)		
		frame.name = frame_name		
		var lerp_weight = (1 / frames_amt) * i
		var z = lerp(low_extent_z, high_extent_z, lerp_weight)	+ global_variables.frame_padding_z
		var pos = Vector3(-global_variables.init_room_scale_x, 0, z)	
		frame.translation = pos
		frames_parent.add_child(frame)
	return frames_parent
	#frames_parent_ref = frames_parent	
	#self.add_child(frames_parent)

func create_image_mesh(pos : Vector3, texture : Texture, mesh_size : float)-> MeshInstance:
	var vertices = PoolVector3Array()
	var UVs = PoolVector2Array()
	var mat = SpatialMaterial.new()
	var color = Color(0.0, 1.0, 0.1)
	
	# top right
	vertices.push_back(Vector3(0, -mesh_size, -mesh_size))
	# top left
	vertices.push_back(Vector3(0,-mesh_size,mesh_size))
	#bottom left
	vertices.push_back(Vector3(0, mesh_size, mesh_size))	
	# bottom right
	vertices.push_back(Vector3(0, mesh_size, -mesh_size))
	
	# https://gamedev.stackexchange.com/questions/6911/what-exactly-is-uv-and-uvw-mapping
	UVs.push_back(Vector2(0,1))
	UVs.push_back(Vector2(1,1))
	UVs.push_back(Vector2(1,0))
	UVs.push_back(Vector2(0,0))

	mat.albedo_texture = texture

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	st.set_material(mat)

	for v in vertices.size(): 
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])

	var mesh : Mesh = st.commit()
	var meshInstance : MeshInstance = MeshInstance.new()
	meshInstance.mesh = mesh
	
	var centerX : float = pos.x
	var centerY : float = pos.y
	var centerZ : float = pos.z

	meshInstance.translation = Vector3(centerX, centerY, centerZ)
	return meshInstance


func add_images_to_frames(frames):
	for frame in frames.get_children():
		var texture : Texture = load("data/images/test.jpg")
		var x = global_variables.frame_scale.x + 0.0001 # add the value to prevent clipping
		var position = Vector3(x, 0, 0)
		var image_mesh : MeshInstance = create_image_mesh(position, 
														texture,
														0.1)
		frame.add_child(image_mesh)
	return frames
	
func destroy_frames():
	if(is_instance_valid(frames_ref)):
		frames_ref.queue_free()
		
func _ready():
	var frames = create_frames()
	frames = add_images_to_frames(frames)
	frames_ref = frames
	self.add_child(frames)
	# self.add_child(frames)

	
func _process(delta):
	pass
	
func _on_room_scale_changed():
	pass
	destroy_frames()
	var frames = create_frames()
	frames = add_images_to_frames(frames)
	frames_ref = frames
	self.add_child(frames)
