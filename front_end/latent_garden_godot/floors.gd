extends Spatial
export var floors_amount = 2

var Floor = load("res://Floor.tscn")
signal room_scale_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(floors_amount):
		var floor_ = Floor.instance()
		floor_.index = i
		connect("room_scale_changed", floor_, "_on_room_scale_changed")
		self.add_child(floor_)
		
		
func _on_room_scale_changed():
	# relay the signal to the individual rooms
	emit_signal("room_scale_changed")
