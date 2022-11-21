extends Button

func _ready():
	connect("pressed", get_node("/root/App"), "_on_submit_button_pressed")
