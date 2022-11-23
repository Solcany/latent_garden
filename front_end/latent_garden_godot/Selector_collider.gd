extends Area

func _ready():
	#var bounding_box_coords : Array = Geom.get_bounding_box_from_vec3(SELECTOR_SCALE)
	#Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
	connect("body_entered", get_parent(), "_on_body_entered_selector")
	
