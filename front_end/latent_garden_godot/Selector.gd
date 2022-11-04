tool

extends Area

const SELECTOR_SCALE = Vector3(0.5, 0.5, 0.5)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func handle_body_entered():
	connect("body_entered", self, "_on_body_entered_selector")

func _on_body_entered_selector(body):
	print("body!")

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape.scale = SELECTOR_SCALE
	
	var bounding_box_coords : Array = Geom.get_bounding_box_from_vec3(SELECTOR_SCALE)
	Geom.add_debug_box_to_the_scene(self, bounding_box_coords[0], bounding_box_coords[1])
	
	handle_body_entered()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
