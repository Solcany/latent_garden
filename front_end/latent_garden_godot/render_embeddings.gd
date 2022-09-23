extends Spatial

func load_csv_to_array(path : String):
	var file = File.new()
	file.open(path, file.READ)
	while !file.eof_reached():
		print(file.get_csv_line())
	   # var csv = file.get_csv_line ()


# Called when the node enters the scene tree for the first time.
func _ready():
	load_csv_to_array("res://resources/data/noise/sky_watch_data_friday_embeddings.csv")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
