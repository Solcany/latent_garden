extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var app_ref = get_node("/root/App")
	connect("pressed", app_ref, "_on_submit_button_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
