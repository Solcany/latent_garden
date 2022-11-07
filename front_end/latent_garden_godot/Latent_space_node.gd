tool

extends Spatial

const NODE_SCALE = Vector3(0.07, 0.07, 0.07)
var is_selected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Collider.scale = NODE_SCALE
	#$Collider/Mesh.set_surface_material(0, mat)
	#$Collider/Mesh.scale = NODE_SCALE
	#var bounding_box : Array = Geom.get_bounding_box_from_vec3(NODE_SCALE)
	#Geom.add_debug_box_to_the_scene(self, bounding_box[0], bounding_box[1])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mat = $Collider/Mesh.get_surface_material(0)			
	if(is_selected):
		mat.albedo_color = Color(1,0,0)
	else:
		mat.albedo_color = Color(1,1,1)
