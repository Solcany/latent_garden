extends Node

var viewport_size : Vector2
var is_camera_panning : bool = false
var prev_norm_mouse_pos : Vector2
var camera_zoom : float = 0.0
var camera_velocity: float = 0.03

func handle_mouse_moving(event) -> void:
	if(is_camera_panning):
		var mouse_norm_pos : Vector2
		
		# normalise mouse pos
		mouse_norm_pos.x = event.position.x / viewport_size.x * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range
		mouse_norm_pos.y = event.position.y / viewport_size.y * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range
		
		# how far has the mouse travel since the last time?
		var screen_travel : Vector2 = mouse_norm_pos - prev_norm_mouse_pos
		
		# get new camera velocity
		var camera_velocity : Vector3
		camera_velocity.x = - screen_travel.x * (viewport_size.x/viewport_size.y)
		camera_velocity.y = screen_travel.y
		camera_velocity.z = 0.0
		
		# update previous mouse pos
		prev_norm_mouse_pos = mouse_norm_pos
			
		$Camera.translation += camera_velocity
	else:
		prev_norm_mouse_pos.x = event.position.x / viewport_size.x * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range
		prev_norm_mouse_pos.y = event.position.y / viewport_size.y * 2.0 - 1.0 # normalise & remap to -1.0, 1.0 range

# legacy code for old camera interactions
# camera moves when the mouse reaches the edge of the viewport
# needs some global vars set up to work

#func _on_mouse_movement(event) -> void:
#	var mouse_x : float = event.position.x
#	var mouse_y : float = event.position.y
#
#	if(mouse_x <= Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_x > 0 or
#		mouse_x >= viewport_size.x - Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_x < viewport_size.x or
#		mouse_y <=  Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_y > 0 or
#		mouse_y >= viewport_size.y - Constants.CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA and mouse_y < viewport_size.y):
#		is_camera_moving = true
#	else:
#		is_camera_moving = false
#
#	mouse_pos = Vector2(mouse_x, mouse_y)
#
#func handle_camera_moving() -> void:
#	if is_camera_moving:
#		var angle : float = atan2(viewport_center.y - mouse_pos.y, viewport_center.x - mouse_pos.x);
#		var x : float= -cos(angle) * Constants.CAMERA_LATERAL_MOVEMENT_DAMPING
#		var y : float = sin(angle) * Constants.CAMERA_LATERAL_MOVEMENT_DAMPING
#		var dir : Vector3 = Vector3(x, y, 0);
#		$Camera.translation += dir
		
# WIP this handler funcand the event should be renamed to more generic name, 
# change in App and the slider
func _on_nodes_container_z_scale_changed(value : float) -> void:
	var projection_size = range_lerp(value, Constants.NODES_CONTAINER_SCALE_Z_MIN, Constants.NODES_CONTAINER_SCALE_Z_MAX, Constants.CAMERA_PROJECTION_SIZE_MIN, Constants.CAMERA_PROJECTION_SIZE_MAX)
	$Camera.size = projection_size		
	
func _on_mouse_wheel_update(mouse_wheel_value: float) -> void:
	var projection_size = range_lerp(mouse_wheel_value, 1.0, 0.0, Constants.CAMERA_PROJECTION_SIZE_MIN, Constants.CAMERA_PROJECTION_SIZE_MAX)
	$Camera.size = projection_size
	
func _ready():
	$Camera.far = Constants.CAMERA_FAR	
	viewport_size = get_viewport().size
	
func _process(delta):
	if !is_camera_panning and Input.is_action_pressed("ui_mouse_left") and Input.is_action_pressed("camera_pan_key"):
		print("PAN!")
		is_camera_panning = true
	elif is_camera_panning and Input.is_action_just_released("ui_mouse_left") or Input.is_action_just_released("camera_pan_key"):
		print("UNPAN!")
		is_camera_panning = false
	
func _input(event):
	if event is InputEventMouseMotion: 
		handle_mouse_moving(event)
