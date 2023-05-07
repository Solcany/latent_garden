extends Node

var colliding_body = null
var selector_gui_size: Vector2
var selector_screen_pos : Vector2
onready var camera_ref = get_node("/root/App/Camera_controller/Camera")
signal latent_node_selected

func unproject_world_selector_to_gui_representation(selector_world_scale: Vector3) -> Vector2: 
	# unproject 3d selector to 2d representation, returns width and height of 2d rect
	# relative top left vertex
	var p1 = camera_ref.unproject_position(Vector3(-selector_world_scale.x, -selector_world_scale.y, selector_world_scale.z))
	# relative top right vertex
	var p2 = camera_ref.unproject_position(Vector3(selector_world_scale.x, -selector_world_scale.y, selector_world_scale.z))	
	# relative bottom left vertex
	var p3 = camera_ref.unproject_position(Vector3(-selector_world_scale.x, selector_world_scale.y, selector_world_scale.z))	
	var selector_gui_width = p1.distance_to(p2)
	var selector_gui_height = p1.distance_to(p3)		
	return Vector2(selector_gui_width, selector_gui_height)

func init_selector_collider():
	var collision_shape_scale : Vector3 = Vector3(Constants.SELECTOR_COLLIDER_SHAPE_XY_SCALE,
												Constants.SELECTOR_COLLIDER_SHAPE_XY_SCALE,
												Constants.SELECTOR_COLLIDER_SHAPE_Z_SCALE)
												
	var collision_debug_box_scale : Vector3 = Vector3(Constants.SELECTOR_COLLIDER_DEBUG_BOX_XY,
													Constants.SELECTOR_COLLIDER_DEBUG_BOX_XY,
													Constants.SELECTOR_COLLIDER_DEBUG_BOX_Z)
										
	$Selector_collider/Collision_shape.scale = collision_shape_scale
	$Selector_collider/Collision_shape.shape.extents.x = Constants.SELECTOR_COLLIDER_SHAPE_XYZ_EXTENTS
	$Selector_collider/Collision_shape.shape.extents.y = Constants.SELECTOR_COLLIDER_SHAPE_XYZ_EXTENTS
	$Selector_collider/Collision_shape.shape.extents.z = Constants.SELECTOR_COLLIDER_SHAPE_XYZ_EXTENTS
	
	$Selector_collider/Debug_collider_box.scale = collision_debug_box_scale
	#$Selector_collider.translation.z = -Constants.SELECTOR_COLLIDER_Z_SCALE
	
	# unproject the world selector scale for the 2d gui overlay representation
	selector_gui_size = unproject_world_selector_to_gui_representation(collision_debug_box_scale)
	# pass signals when a node is selected to the container containing the nodes
	var latent_nodes_container_ref = get_node("/root/App/Nodes/Nodes_container")
	connect("latent_node_selected", latent_nodes_container_ref ,"_on_latent_node_selected")

func handle_mouse_wheel_update(scalar : float) -> void:
	var collision_debug_box_scale : Vector3 = Vector3(Constants.SELECTOR_COLLIDER_DEBUG_BOX_XY,
													Constants.SELECTOR_COLLIDER_DEBUG_BOX_XY,
													Constants.SELECTOR_COLLIDER_DEBUG_BOX_Z)

#	var collider_scale_xy : float = 
#	$Selector_collider/Collider.scale = collider_scale
#	$Selector_collider/Debug_collider_mesh.scale = collider_scale
#	$Selector_collider.translation.z = -Constants.SELECTOR_COLLIDER_Z_SCALE
	# unproject the world selector scale for the 2d gui overlay representation
	selector_gui_size = unproject_world_selector_to_gui_representation(collision_debug_box_scale)
	update_selector_size()
	# pass signals when a node is selected to the container containing the nodes
#	var latent_nodes_container_ref = get_node("/root/App/Nodes/Nodes_container")
#	connect("latent_node_selected", latent_nodes_container_ref ,"_on_latent_node_selected")

func update_selector_size() -> void:
	var left : float = selector_screen_pos.x - selector_gui_size.x/2
	var right : float = selector_screen_pos.x + selector_gui_size.x/2	
	var top : float = selector_screen_pos.y - selector_gui_size.y/2
	var bottom : float = selector_screen_pos.y + selector_gui_size.y/2
	# translatet selector gui rectangle on mouse event
	$Selector_gui/Selector_rect.margin_left = left
	$Selector_gui/Selector_rect.margin_right = right
	$Selector_gui/Selector_rect.margin_top	= top
	$Selector_gui/Selector_rect.margin_bottom = bottom
	
func handle_mouse_move(event): 
	selector_screen_pos = Vector2(event.position.x, event.position.y)
	var left : float = selector_screen_pos.x - selector_gui_size.x/2
	var right : float = selector_screen_pos.x + selector_gui_size.x/2	
	var top : float = selector_screen_pos.y - selector_gui_size.y/2
	var bottom : float = selector_screen_pos.y + selector_gui_size.y/2
	# translatet selector gui rectangle on mouse event
	$Selector_gui/Selector_rect.margin_left = left
	$Selector_gui/Selector_rect.margin_right = right
	$Selector_gui/Selector_rect.margin_top	= top
	$Selector_gui/Selector_rect.margin_bottom = bottom
	# translate in world selector collider on mouse event
	var collider_pos : Vector3 = camera_ref.project_position(selector_screen_pos, 1)
	collider_pos.z = 0# -Constants.SELECTOR_COLLIDER_Z_SCALE
	$Selector_collider.translation = collider_pos
	
func handle_mouse_click() -> void:
	if(colliding_body):
		emit_signal("latent_node_selected", colliding_body)
		
func _on_body_entered_selector(body) -> void:
	colliding_body = body
	
func _on_body_exited_selector(body) -> void:
	colliding_body = null
	
func _on_mouse_wheel_update(mouse_wheel_value) -> void:
	handle_mouse_wheel_update(mouse_wheel_value)
	
func _ready():
	# uncomment to enable
	# init_selector_collider()
	
	# THIS DISABLES THE NODE 
	set_process(false)
	
func _process(delta):
	if Input.is_action_just_released("camera_pan_mouse") and not Input.is_action_pressed("camera_pan_key"):
		handle_mouse_click()
	
	#if Input.is_action_just_released("ui_mouse_left"):
	#	handle_mouse_click()
		
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_move(event)

		
		
