extends Node

var colliding_body = null
var selector_gui_size: Vector2
var selector_screen_pos : Vector2
onready var camera_ref = get_node("/root/App/Camera_controller/Camera")
signal latent_node_selected

#func handle_mouse_move(event): 
#	selector_screen_pos = Vector2(event.position.x, event.position.y)
#	var left : float = selector_screen_pos.x - selector_gui_size.x/2
#	var right : float = selector_screen_pos.x + selector_gui_size.x/2	
#	var top : float = selector_screen_pos.y - selector_gui_size.y/2
#	var bottom : float = selector_screen_pos.y + selector_gui_size.y/2
#	# translatet selector gui rectangle on mouse event
#	$Selector_gui/Selector_rect.margin_left = left
#	$Selector_gui/Selector_rect.margin_right = right
#	$Selector_gui/Selector_rect.margin_top	= top
#	$Selector_gui/Selector_rect.margin_bottom = bottom
#	# translate in world selector collider on mouse event
#	var collider_pos : Vector3 = camera_ref.project_position(selector_screen_pos, 1)
#	collider_pos.z = 0# -Constants.SELECTOR_COLLIDER_Z_SCALE
#	$Selector_collider.translation = collider_pos


func handle_mouse_click(event) -> void:
	var from = camera_ref.project_ray_origin(event.position)
	var to = from + camera_ref.project_ray_normal(event.position) * 100
	var direct_state = camera_ref.get_world().direct_space_state
	var collision = direct_state.intersect_ray(from, to)
	if collision:
		emit_signal("latent_node_selected", collision.collider)

	
	#emit_signal("latent_node_selected", colliding_body)
		
#func _on_body_entered_selector(body) -> void:
#	colliding_body = body
#
#func _on_body_exited_selector(body) -> void:
#	colliding_body = null
	
#func _on_mouse_wheel_update(mouse_wheel_value) -> void:
#	pass
	
func _ready():
	var latent_nodes_container_ref = get_node("/root/App/Nodes/Nodes_container")
	connect("latent_node_selected", latent_nodes_container_ref ,"_on_latent_node_selected")
	# init_selector_collider()
	
#func _process(delta):
#	if Input.is_action_just_released("camera_pan_mouse") and not Input.is_action_pressed("camera_pan_key"):
#
#		handle_mouse_click()

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		handle_mouse_click(event)
		

