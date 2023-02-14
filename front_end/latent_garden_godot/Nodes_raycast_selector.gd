extends Node

var colliding_body = null
var selector_gui_size: Vector2
var selector_screen_pos : Vector2
onready var camera_ref = get_node("/root/App/Camera_controller/Camera")
signal latent_node_selected

func handle_mouse_move(event): 
	var left : float = event.position.x - 3
	var right : float = event.position.x + 3
	var top : float = event.position.y - 3
	var bottom : float = event.position.y + 3
	$Selector_gui/Selector_rect.margin_left = left
	$Selector_gui/Selector_rect.margin_right = right
	$Selector_gui/Selector_rect.margin_top	= top
	$Selector_gui/Selector_rect.margin_bottom = bottom

func handle_mouse_click(event) -> void:
	var from = camera_ref.project_ray_origin(event.position)
	var to = from + camera_ref.project_ray_normal(event.position) * 100
	var direct_state = camera_ref.get_world().direct_space_state
	var collision = direct_state.intersect_ray(from, to)
	if collision:
		emit_signal("latent_node_selected", collision.collider)
	
func _ready():
	connect("latent_node_selected", get_node("/root/App/Nodes/Nodes_container") ,"_on_latent_node_selected")
	
#func _process(delta):
#	if Input.is_action_just_released("camera_pan_mouse") and not Input.is_action_pressed("camera_pan_key"):
#
#		handle_mouse_click()

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		handle_mouse_click(event)
	elif event is InputEventMouseMotion:
		handle_mouse_move(event)
		

