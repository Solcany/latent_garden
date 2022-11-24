extends Node

const PADDING = 30

func _on_mouse_event(event):
	var viewport_middle_x : float = get_viewport().size.x/2
	var viewport_middle_y : float = get_viewport().size.y/2
	var mouse_x : float = event.position.x
	var mouse_y : float = event.position.y
	
	if(mouse_x < PADDING):
		var angle : float = atan2(viewport_middle_y - mouse_y, viewport_middle_x - mouse_x);
		var x : float= -cos(angle) * Constants.CAMERA_LATERAL_MOVEMENT_DAMPING
		var y : float = sin(angle) * Constants.CAMERA_LATERAL_MOVEMENT_DAMPING
		var dir : Vector3 = Vector3(x, y, 0);
		$Camera.translation += dir
	
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		_on_mouse_event(event)
