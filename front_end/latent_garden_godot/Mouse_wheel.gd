extends Control

var mouse_wheel_value : float = 0.0 # value between 0.0 - 1.0
signal mouse_wheel_update	

func handle_mouse_wheel_up() -> void:
	if(mouse_wheel_value < 1.0):
		mouse_wheel_value += Constants.MOUSE_WHEEL_VELOCITY
		emit_signal("mouse_wheel_update", mouse_wheel_value)
	
func handle_mouse_wheel_down() -> void:
	if(mouse_wheel_value > 0.0):
		mouse_wheel_value -= Constants.MOUSE_WHEEL_VELOCITY
		emit_signal("mouse_wheel_update", mouse_wheel_value)
		
func _ready():
	connect("mouse_wheel_update", get_node("/root/App"), "_on_mouse_wheel_update")

func _process(delta):
	if Input.is_action_just_released("ui_mouse_wheel_up"):
		handle_mouse_wheel_up()
		
	elif Input.is_action_just_released("ui_mouse_wheel_down"):
		handle_mouse_wheel_down()
