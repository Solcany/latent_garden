tool
extends Node

signal latent_node_selected
const SELECTOR_SCALE = Vector3(0.1, 0.1, 0.1)
onready var selector_gui_size: Vector2
onready var camera_ref = get_node("../Camera")

func unproject_in_world_selector_to_gui_representation(selector_world_scale: Vector3) -> Vector2: 
	# relative top left vertex
	var p1 = camera_ref.unproject_position(Vector3(-selector_world_scale.x, -selector_world_scale.y, selector_world_scale.z))
	# relative top right vertex
	var p2 = camera_ref.unproject_position(Vector3(selector_world_scale.x, -selector_world_scale.y, selector_world_scale.z))	
	# relative bottom left vertex
	var p3 = camera_ref.unproject_position(Vector3(-selector_world_scale.x, selector_world_scale.y, selector_world_scale.z))	
	var selector_gui_width = p1.distance_to(p2)
	var selector_gui_height = p1.distance_to(p3)		
	return Vector2(selector_gui_width, selector_gui_height)

func init_selector():
	# set world selector scales
	$Selector_collider/Collider.scale = SELECTOR_SCALE
	$Selector_collider/Debug_collider_mesh.scale = SELECTOR_SCALE
	# unproject the world selector scale for the 2d gui overlay representation
	selector_gui_size = unproject_in_world_selector_to_gui_representation(SELECTOR_SCALE)
	
	# pass signals when a node is selected to the container containing the nodes
	var latent_nodes_container_ref = get_node("../Latent_nodes_container")
	connect("latent_node_selected", latent_nodes_container_ref ,"_on_latent_node_selected")

func handle_mouse_event(event): 
	var mouse_x : float = event.position.x
	var mouse_y : float = event.position.y		
	var left : float = mouse_x - selector_gui_size.x/2
	var right : float = mouse_x + selector_gui_size.x/2	
	var top : float = mouse_y - selector_gui_size.y/2
	var bottom : float = mouse_y + selector_gui_size.y/2
	# translatet selector gui rectangle on mouse event
	$Selector_gui/Selector.margin_left = left
	$Selector_gui/Selector.margin_right = right
	$Selector_gui/Selector.margin_top	= top
	$Selector_gui/Selector.margin_bottom = bottom
	# translate in world selector collider on mouse event
	var collider_pos : Vector3 = camera_ref.project_position(Vector2(mouse_x,mouse_y), 1)
	$Selector_collider.translation = collider_pos
			
func _on_body_entered_selector(item_body):
	emit_signal("latent_node_selected", item_body)
	

func _ready():
	init_selector()
	
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_event(event)
