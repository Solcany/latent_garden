extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const path = "res://Data/data.json"

func cond(v) -> bool:
	return v == 0

func filter(filter_function: FuncRef, candidate_array: Array)->Array:
	var filtered_array := []

	for candidate_value in candidate_array:
		if filter_function.call_func(candidate_value):
			filtered_array.append(candidate_value)

	return filtered_array


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


# Called when the node enters the scene tree for the first time.
func _ready():
	var data : Dictionary = load_data(path)
	var img_format : String = data["meta"].img_format
	var bounding_box : Dictionary = data["meta"].bounding_box_2d
	
	var img_data : Array
	for v in data["data"]:
		var id : int = int(v.img_idx)
		var x : float = float(v.z_2d[0])
		var y : float = float(v.z_2d[1])
		var v_ : Dictionary = {"x": x, "y": y, "id": id}
		img_data.append(v_)
	
	print(img_data)

	
		

	
	
	#print(data["1"])





# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
