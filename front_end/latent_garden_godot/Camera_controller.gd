extends Node

const PADDING = 15

func _on_mouse_event(event):
	var viewport_x = get_viewport().size.x
	var viewport_y = get_viewport().size.y
	var mouse_x : float = event.position.x
	var mouse_y : float = event.position.y
	
	if(mouse_x < PADDING):
		var dir = Vector3(mouse_x, mouse_y, 0) + Vector3(viewport_x, viewport_y, 0)
		dir = dir.normalized()
		dir.x = dir.x * -1
		dir.y = 0
		dir = dir * 0.01
		print(dir)
		$Camera.translation += dir
	
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		_on_mouse_event(event)
