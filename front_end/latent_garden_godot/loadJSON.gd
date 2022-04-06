extends Node2D

const IMAGES_PATH_ROOT : String = "res://Data/images/"
const DATA_PATH : String = "res://Data/data.json"
const DOMAIN_WIDTH : int = 300
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

func remap_points(points : Array, b_box_2d : Dictionary, new_dim: int)->Array:
	var bb_x1 : float = b_box_2d.x1
	var bb_y1 : float = b_box_2d.y1
	var bb_x2 : float = b_box_2d.x2
	var bb_y2 : float = b_box_2d.y2
	
	# scale new dim according to the aspect ratio of the points domain
	var low_extreme : float = max(bb_x1, bb_y1)
	var high_extreme : float = max(bb_x2, bb_y2)
	var x_scalar : float = remap_range(bb_x2, low_extreme, high_extreme, 0.0, 1.0);
	var y_scalar : float = remap_range(bb_y2, low_extreme, high_extreme, 0.0, 1.0);
	var x_new_dim : float = new_dim * x_scalar
	var y_new_dim : float = new_dim * y_scalar
	
	# remap points to new domain
	var new_points : Array
	for point in points:
		var x_norm : float = remap_range(point.x, bb_x1, bb_x2, 0.0, 1.0) 
		var y_norm : float = remap_range(point.y, bb_y1, bb_y2, 0.0, 1.0) 	
		var new_x : float = (x_norm * x_new_dim) + 50
		var new_y : float = (y_norm * y_new_dim) + 50
		var new_point : Vector2 = Vector2(new_x, new_y)
		new_points.append(new_point)
	return new_points

func load_and_show_images(images_root_path : String, image_format : String, images_data : Dictionary) -> void:
	var points = images_data.points
	var label = images_data.label
	
	var images = Node2D.new()
	images.set_name("images");
	
	for datapoint in points:
		var sprite : Sprite = Sprite.new() 
		var node : Node2D = Node2D.new()
		var path = images_root_path + label + "/"+ datapoint.name + "." + image_format
		var tex : Texture = load(path)
		sprite.set_texture(tex)
		sprite.scale = Vector2(IMAGE_WIDHT_SCALAR, IMAGE_WIDHT_SCALAR)
		node.set_position(datapoint.pos)      
		node.add_child(sprite)
		images.add_child(node)
	self.add_child(images)  
		
func debug_show_points(images_data : Dictionary) -> void:
	var points = images_data.points
	var color : Color = Color(1.0, 0.0, 0.0)
	for datapoint in points:
		draw_circle(datapoint.pos, 1.0, color)

# Called when the node enters the scene tree for the first time.
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
		remapped_points.append(remap_points(points2d, bounding_box, DOMAIN_WIDTH))

	# merge all image data into a new dict array
	#
	# images data shape (pseudo code):
	# IMAGES_DATA = [ 
	#					generation1 = { generation label = String,
	#								    points = [{point2d = Vector2, image name= String}, 
	#											  {point2d, image name},
	#										     ...]}
	#					generation2,
	#					generation3,
	#					...]
	
	var n_points : int = remapped_points[0].size()
	for g_i in range(n_generations):
		var gen_data : Array = data.data[g_i].data
		var gen_points2d : Array = remapped_points[g_i]
		var gen_label : String = data.data[g_i].label
		var new_datapoints : Array
		for i in range(n_points):
			var point2d : Vector2 = gen_points2d[i]
			var img_name : String = gen_data[i].img_name
			new_datapoints.append({"pos" : point2d, "name" : img_name})
		var generation : Dictionary = {"label": gen_label, 
									   "points": new_datapoints}
		IMAGES_DATA.append(generation)
		
	# show images
	#load_and_show_images(IMAGES_PATH_ROOT, img_format, IMAGES_DATA[2])

func _draw():
	debug_show_points(IMAGES_DATA[2])
	load_and_show_images(IMAGES_PATH_ROOT, IMAGE_FORMAT, IMAGES_DATA[2])
	print(get_tree())
#func _process(delta):
#	pass


func _input(event):
	if event.is_action_pressed("delete"):
		self.get_node("images").queue_free()

	#	for child in children:
	#		print(len(children))
	#		print(child)
		#get_node("images").queue_free()
