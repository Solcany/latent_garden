extends Area

func _ready():
	connect("body_entered", get_parent(), "_on_body_entered_selector")
	connect("body_exited", get_parent(), "_on_body_exited_selector")
