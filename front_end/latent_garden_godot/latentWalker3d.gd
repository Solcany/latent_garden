extends Spatial

const IMAGES_PATH_ROOT : String = "res://Data/images"
const DATA_PATH : String = "res://Data/data.json"
const DOMAIN_WIDTH : float = 0.5
const CANVAS_NAME_ROOT : String = "image_canvas"
const IMAGE_WIDHT_SCALAR : float= 0.1
var IMAGES_DATA : Array = []
var IMAGE_FORMAT : String


func cond(v) -> bool:
	return v == 0

func filter(filter_function: FuncRef, candidate_array: Array)->Array:
	var filtered_array := []

	for candidate_value in candidate_array:
		if filter_function.call_func(candidate_value):
			filtered_array.append(candidate_value)

	return filtered_array

func remap_range(value, InputA, InputB, OutputA, OutputB)->float:
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA

func load_data(path) -> Dictionary:
	var json_data : File = File.new()
	if not json_data.file_exists(path):
		push_error("file doesn't exists")

	json_data.open(path, json_data.READ)
	var json_text : String = json_data.get_as_text()

	var parsed : JSONParseResult = JSON.parse(json_text)
	if parsed.error != OK:
		push_error("error while parsing json")
	
	var data : Dictionary = parsed.result
	json_data.close()

	return data

func remap_points_2d(points_2d : Array, b_box_2d : Dictionary, new_domain_size: float)->Array:
	var bb_x1 : float = b_box_2d.x1
	var bb_y1 : float = b_box_2d.y1
	var bb_x2 : float = b_box_2d.x2
	var bb_y2 : float = b_box_2d.y2
	
	# scale new dim according to the aspect ratio of the points domain
	var low_extreme : float = max(bb_x1, bb_y1)
	var high_extreme : float = max(bb_x2, bb_y2)
	var x_scalar : float = remap_range(bb_x2, low_extreme, high_extreme, 0.0, 1.0);
	var y_scalar : float = remap_range(bb_y2, low_extreme, high_extreme, 0.0, 1.0);
	var x_new_dim : float = new_domain_size * x_scalar
	var y_new_dim : float = new_domain_size * y_scalar
	
	# remap points to new domain
	var new_points : Array
	for point in points_2d:
		var x_norm : float = remap_range(point.x, bb_x1, bb_x2, 0.0, 1.0) 
		var y_norm : float = remap_range(point.y, bb_y1, bb_y2, 0.0, 1.0) 	
		var new_x : float = (x_norm * x_new_dim)
		var new_y : float = (y_norm * y_new_dim)
		var new_point : Vector3 = Vector3(new_x, new_y, 0)
		new_points.append(new_point)
	return new_points

func create_image_plane(pos : Vector3, texture : Texture, mesh_size : float)-> MeshInstance:
	var vertices = PoolVector3Array()
	var UVs = PoolVector2Array()
	var mat = SpatialMaterial.new()
	var color = Color(0.0, 1.0, 0.1)
	
	# create plane mesh
	vertices.push_back(Vector3(0,0,0))
	vertices.push_back(Vector3(0,mesh_size,0))
	vertices.push_back(Vector3(mesh_size,mesh_size,0))
	vertices.push_back(Vector3(mesh_size,0,0))
	UVs.push_back(Vector2(0,0))
	UVs.push_back(Vector2(0,1))
	UVs.push_back(Vector2(1,1))
	UVs.push_back(Vector2(1,0))

	mat.albedo_texture = texture

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	st.set_material(mat)

	for v in vertices.size(): 
		#st.add_color(texture)
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])

	var mesh : Mesh = st.commit()
	var meshInstance : MeshInstance = MeshInstance.new()
	meshInstance.mesh = mesh
	
	var centerX : float = pos.x + mesh_size/2
	var centerY : float = pos.y + mesh_size/2
	var centerZ : float = pos.z

	meshInstance.translation = Vector3(centerX, centerY, centerZ)
	return meshInstance

func add_image_canvases_to_scene(images_data : Array)-> void:
	var canvas_z_pos : float = 0
	for i in range(images_data.size()):
		var generation = images_data[i]
		var c_name : String = CANVAS_NAME_ROOT + str(i)	
		var image_canvas = Spatial.new()
		image_canvas.set_name(c_name)
		image_canvas.visible = true
		image_canvas.translate(Vector3(0,0,canvas_z_pos))
		canvas_z_pos += 0.3
		for datapoint in generation.datapoints:
			var meshInstance : MeshInstance = create_image_plane(datapoint.pos, datapoint.texture, 0.1)
			image_canvas.add_child(meshInstance) 
		self.add_child(image_canvas)
	print(self.get_children())
	#get_node("image_canvas2")
	#$image_canvas1.visible = true
	
	
func debug_show_points(images_data : Dictionary) -> void:
	pass
#	var points = images_data.points
#	var color : Color = Color(1.0, 0.0, 0.0)
#	for datapoint in points:
#		draw_circle(datapoint.pos, 1.0, color)

func _ready():
	var data : Dictionary = load_data(DATA_PATH)
	IMAGE_FORMAT = data.meta.img_format
	var bounding_box : Dictionary = data.meta.bounding_box_2d
	var n_generations : int = data.data.size()
	bounding_box.x1 = float(bounding_box.x1)
	bounding_box.y1 = float(bounding_box.y1)
	bounding_box.x2 = float(bounding_box.x2)
	bounding_box.y2 = float(bounding_box.y2)
	
	# remap points of all generations into arbitrary domain	
	var remapped_points : Array = []
	for g_i in range(n_generations):
		var gen_data = data.data[g_i].data
		var points2d : Array = []
		for datapoint in gen_data:
			var x : float = float(datapoint.z_2d[0])
			var y : float = float(datapoint.z_2d[1]) 
			var point2d : Vector2 = Vector2(x,y)
			points2d.append(point2d)
		remapped_points.append(remap_points_2d(points2d, bounding_box, DOMAIN_WIDTH))
		 
	# Preprocess all image data
	#
	# image data shape in pseudo code:
	# each generation represents
	# image_data = [ 
	#					generation1 : Dictionary = { generation_label : String,
	#								   				 points = [{point3d : Vector3, texture : Texture}, 
	#											    		   {point3d, texture},
	#														   {point3d, texture},
	#										     				...]}
	#					generation2,
	#					generation3,
	#					...]
	var n_points : int = remapped_points[0].size()
	for g_i in range(n_generations):
		var gen_data : Array = data.data[g_i].data
		var gen_points_3d : Array = remapped_points[g_i]
		var gen_label : String = data.data[g_i].label
		var new_datapoints : Array
		for i in range(n_points):
			var point3d : Vector3 = gen_points_3d[i]
			var img_name : String = gen_data[i].img_name
			var img_path : String = IMAGES_PATH_ROOT + "/" + gen_label + "/"+ img_name + "." + IMAGE_FORMAT
			var img_tex : Texture = load(img_path)
			new_datapoints.append({"pos" : point3d, "texture" : img_tex})
		var generation : Dictionary = {"label": gen_label, 
									   "datapoints": new_datapoints}
		IMAGES_DATA.append(generation)
		
	add_image_canvases_to_scene(IMAGES_DATA)


func _draw():
	pass

func _input(event):
	if event.is_action_pressed("delete"):
		var children = self.get_children()
		for child in children:
			print(child)
