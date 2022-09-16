extends Node2D

var selected = false
var drop_point
var drop_zones = []

func _ready():
	drop_zones = get_tree().get_nodes_in_group("zone")
	drop_point = drop_zones[0].global_position
	#drop_zones[0].select()


func _physics_process(delta):
	if selected:
		followMouse(delta)
#	else:
#		followRestpoint(delta)
#		rotation = lerp_angle(rotation, 0, 10 * delta)

func followMouse(delta):
	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func followRestpoint(delta):
	global_position = lerp(global_position, drop_point, 10 * delta)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			selected = true
			
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		selected = false
		var shortest_dist = 75
		for child in drop_zones:
			var distance = global_position.distance_to(child.global_position)
			if distance < shortest_dist:
				child.select()
				drop_point = child.global_position
		
