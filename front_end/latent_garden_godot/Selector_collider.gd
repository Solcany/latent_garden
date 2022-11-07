extends Area

func handle_body_entered():
	connect("body_entered", self, "_on_body_entered_selector")

func _on_body_entered_selector(body):
	pass

func _ready():

	#var bounding_box_coords : Array = Geom.get_bounding_box_from_vec3(SELECTOR_SCALE)
	#Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
	
	handle_body_entered()
