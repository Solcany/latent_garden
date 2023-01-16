extends Node

var is_camera_moving : bool = false
var mouse_pos : Vector2 = Vector2(0,0)
var viewport_size : Vector2
var viewport_center : Vector2
var is_mouse_pressed : bool = false
var prev_norm_mouse_pos : Vector2 = Vector2(0,0)

func _on_mouse_movement(event) -> void:
	var mouse_x : float = event.position.x
	var mouse_y : float = event.position.y
	
	if(mouse_x <= Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_x > 0 or
		mouse_x >= viewport_size.x - Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_x < viewport_size.x or
		mouse_y <=  Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_y > 0 or
		mouse_y >= viewport_size.y - Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_y < viewport_size.y):
		is_camera_moving = true
	else:
		is_camera_moving = false

	mouse_pos = Vector2(mouse_x, mouse_y)

func handle_camera_moving() -> void:
	if is_camera_moving:
		var angle : float = atan2(viewport_center.y - mouse_pos.y, viewport_center.x - mouse_pos.x);
		var x : float= -cos(angle) * Constants.CAMERA_LATERAL_MOVEMENT_DAMPING
		var y : float = sin(angle) * Constants.CAMERA_LATERAL_MOVEMENT_DAMPING
		var dir : Vector3 = Vector3(x, y, 0);
		$Camera.translation += dir

func handle_mouse_moving(event) -> void:
	if(is_mouse_pressed):
		var mouse_norm_pos : Vector2
		
		mouse_norm_pos.x = event.position.x / viewport_size.x * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range
		mouse_norm_pos.y = event.position.y / viewport_size.y * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range
		
		var screen_travel : Vector2 = mouse_norm_pos - prev_norm_mouse_pos
		
		var new_translation : Vector3
		new_translation.x = - screen_travel.x * (viewport_size.x/viewport_size.y)
		new_translation.y = screen_travel.y
		new_translation.z = 0.0
		
		$Camera.translation += new_translation
		
		prev_norm_mouse_pos = mouse_norm_pos
	else:
		prev_norm_mouse_pos.x = event.position.x / viewport_size.x * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range
		prev_norm_mouse_pos.y = event.position.y / viewport_size.y * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range

func handle_mouse_pressed(event) -> void:
	if(event.pressed):
		is_mouse_pressed = true
	else:
		is_mouse_pressed = false
		
# WIP this handler funcand the event should be renamed to more generic name, 
# change in App and the slider
func _on_nodes_container_z_scale_changed(value : float) -> void:
	var projection_size = range_lerp(value, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.CAMERA_PROJECTION_SIZE_MIN, Constants.CAMERA_PROJECTION_SIZE_MAX)
	$Camera.size = projection_size		
		
func _ready():
	$Camera.far = Constants.CAMERA_FAR	
	viewport_size = get_viewport().size
	viewport_center = viewport_size/2
	
func _process(delta):
	handle_camera_moving()
	
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_moving(event)
		
	if event is InputEventMouseButton:
		handle_mouse_pressed(event)
		
	
