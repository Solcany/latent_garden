extends Node2D

const IMAGES_PATH = "res://Data/images/"
const DATA_PATH = "res://Data/data.json"
const DOMAIN_WIDTH = 300
const IMAGE_WIDHT_SCALAR = 0.1

var IMAGES_DATA : Array = []


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

func load_and_show_images(images_path : String, image_format : String, images_data : Array) -> void:
	for image_data in images_data:
		var sprite : Sprite = Sprite.new() 
		var node : Node2D = Node2D.new()
		var path = images_path + image_data.name + "." + image_format
		var tex : Texture = load(path)
		sprite.set_texture(tex)
		sprite.scale = Vector2(IMAGE_WIDHT_SCALAR, IMAGE_WIDHT_SCALAR)
		node.set_position(image_data.pos)      
		node.add_child(sprite)
		add_child(node)	  
		
func debug_show_points(images_data : Array) -> void:
	var color : Color = Color(1.0, 0.0, 0.0)
	for image_data in images_data:
		draw_circle(image_data.pos, 1.0, color)

# Called when the node enters the scene tree for the first time.
func _ready():
	var data : Dictionary = load_data(DATA_PATH)
	var img_format : String = data["meta"].img_format
	var bounding_box : Dictionary = data["meta"].bounding_box_2d
	bounding_box.x1 = float(bounding_box.x1)
	bounding_box.y1 = float(bounding_box.y1)
	bounding_box.x2 = float(bounding_box.x2)
	bounding_box.y2 = float(bounding_box.y2)
	
	# get points from data array
	var points : Array = []
	for val in data.data:
		var x : float = float(val.z_2d[0])
		var y : float = float(val.z_2d[1])
		var point : Vector2 = Vector2(x,y)
		points.append(point)
	# remap all points to arbitrary domain		
	var remapped_points : Array = remap_points(points, bounding_box, DOMAIN_WIDTH)
	
	# merge all image data into dict
	#var img_data : Array = []
	for i in range(remapped_points.size()):
		var point : Vector2 = remapped_points[i]
		var img_name : String = data.data[i].img_idx
		var dict : Dictionary = {"pos" : point, "name" : img_name}
		IMAGES_DATA.append(dict)
		
	# show images
	#load_and_show_images(IMAGES_PATH, img_format, img_data)

func _draw():
	debug_show_points(IMAGES_DATA)

#func _process(delta):
#	pass
