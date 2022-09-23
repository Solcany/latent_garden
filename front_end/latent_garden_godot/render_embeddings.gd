extends Spatial

const EMBEDDINGS_SIZE = 3

func load_csv_of_floats(path : String, row_size: int) -> Array:
	# Godot interprets .csv files as game translation 
	# it breaks when trying to load a regular non translation .csv
	# therefore change .csv extension to .txt to load it properly
	var file = File.new()
	file.open(path, file.READ)
	
	var data = []
		
	while !file.eof_reached():
		var csv = file.get_csv_line()
		if(csv.size() == row_size):
			var data_row :Array = []
			for num in csv:
				data_row.append(float(num))
			data.append(data_row)
	file.close()
	
	print("csv: ", path, " loaded!")
	
	return data
	


# Called when the node enters the scene tree for the first time.
func _ready():
	var embeddings : Array = load_csv_of_floats("data/noise/sky_watch_data_friday_embeddings.txt", EMBEDDINGS_SIZE)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
