extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Arr.array_to_csv_string([1,2,3])
	var a = Arr.array_to_csv_string([1,2,3]).to_utf8()
	print(a)
	#pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
